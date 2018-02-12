clc;
clear;
close all;

addpath('LSM-NLR/Utilities')
addpath('LSM-NLR/Data')
rmpath('WESNR/Utilities')
addpath('FastTV2Phase')


img_name = 'images\boat.png';

sigma = 10;
salt_pepper = 0.25;
rvin = 0.05;

P = double(imread(img_name));

%TV settings
r=0;
tol=0.001;
eta=1;
beta = 0.002;

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

par.INlevel=  salt_pepper+rvin;
par.nsig   =  sigma;
par.I      =  x;
par.y      =  x;
par.im_ini =  tv_out;
par.ind = ~ind;

[lsm_tv,~,~]      =   LSM_NLR_Denoising(par); 

PSNR = psnr(lsm_tv,P,255)
SSIM = ssim(lsm_tv/255, P/255)
