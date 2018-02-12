clc;
clear;
close all;

addpath('WESNR/Utilities')
rmpath('LSM-NLR/Utilities')
addpath('FastTV2Phase')
load WESNR/Data/Lib/PCA_AR_TD2_c2.mat


img_name = 'images\boat.png';

sigma = 10;
salt_pepper = 0.25;
rvin = 0.05;

P = double(imread(img_name));

r=0;
tol=0.001;
eta=1;
beta = 0.002;

times = 5;
PSNR = zeros(times,3);
SSIM = PSNR;

img = P/255.0;
imn = img + sigma/255*randn(size(img));
[imn,Narr] = impulsenoise(imn,salt_pepper,0);
[imn,Narr] = impulsenoise(imn,rvin,1);

x = imn;
[amf,~]=adpmedft(x,19); %0-1
[acf,~] = acwmf(amf,3);

x = imn*255;
rec=acf*255;
ind= (x~=rec);
rec(~ind)=x(~ind);

[tv_out,v]=deblur_TV_L1_inc(rec,r,~ind,tol,beta,eta);

par.nSig                  =   sigma;
par.PCA_D                 =   PCA_D;
par.Codeword              =   centroids;
par.nim                   =   x;
par.pim                   =   tv_out;
par.I                     =   x;

[wesnr_tv,~,~]               =   WESNR_Denoising( par );

PSNR = psnr(wesnr_tv,P,255)
SSIM = ssim(wesnr_tv/255, P/255)
