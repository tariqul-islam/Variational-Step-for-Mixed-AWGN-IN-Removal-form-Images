clc;
clear;
close all;

addpath('BM3D_CODE')
addpath('FastTV2Phase')

img_name = 'images\boat.png';

sigma = 10;
salt_pepper = 0.25;
rvin = 0.05;

P = double(imread(img_name));

%TV Settings
r=0;
tol=0.001;
eta=1;
beta = 0.002;



img = P/255.0;
imn = img + sigma/255*randn(size(img));
[imn,Narr] = impulsenoise(imn,salt_pepper,0);
[imn,Narr] = impulsenoise(imn,rvin,1);


amf = adpmedft(imn,19);
acf = acwmf(amf,3);


x = imn*255;
rec=acf*255;
ind= (x~=rec);
rec(~ind)=x(~ind);

[tv_out,v]=deblur_TV_L1_inc(rec,r,~ind,tol,beta,eta);

[~,bm3d_tv] = BM3D(1, tv_out, sigma);
bm3d_tv = bm3d_tv*255;

PSNR = psnr(bm3d_tv,P,255)
SSIM = ssim(bm3d_tv/255, P/255)
