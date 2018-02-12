clc;
clear;
close all;

addpath('BM3D_CODE')
addpath('FastTV2Phase')


img_name = 'images\boat.png';

sigma = 25;
salt_pepper = 0.30;

P = double(imread(img_name));

r=0;
tol=0.001;
eta=1;
beta = 0.0002;

times = 1;

img = P/255.0;
imn = img + sigma/255*randn(size(img));
[imn,Narr] = impulsenoise(imn,salt_pepper,0);


[amf,ind_amf] = adpmedft(imn,19);


x = imn*255;
rec=amf*255;
ind=((x==255)|(x==0));
rec(~ind)=x(~ind);

[tv_out,v]=deblur_TV_L1_inc(rec,r,~ind,tol,beta,eta);

[~,bm3d_rv] = BM3D(1, tv_out, sigma);
bm3d_rv = bm3d_rv*255;

PSNR = psnr(bm3d_rv,P,255)
SSIM = ssim(bm3d_rv/255, P/255)
