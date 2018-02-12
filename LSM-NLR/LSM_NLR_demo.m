% Please cite the following paper if you use this code:
% 
% T. Huang, W. Dong, X. Xie, G. Shi, X. Bai, "Mixed Noise Removal via
% Laplacian Scale Mixture Modeling and Nonlocal Low-rank Approximation,"
% IEEE Transcations on Image Processing, in press, 2017.
% For more information, please contact httz1001@163.com,
% wsdong@mail.xidian.edu.cn
%--------------------------------------------------------------------------

clear all; close all; 
addpath('Data','Utilities');

IN_level   =  [10,20,30,40,50]/100;
sigma      =  [10,20,30,50];
IN_idx     =  3;
sigma_idx  =  2;
par.INlevel=  IN_level(IN_idx);
par.nsig   =  sigma(sigma_idx);

par.I      =  double(imread('Lena512.tif'));
par.y      =  par.I + sigma(sigma_idx)*randn(size(par.I));
par.y      =  impulsenoise(par.y,par.INlevel,0);
par.im_ini =  adpmedft(par.y,19);

[im_re PSNR FSIM]      =   LSM_NLR_Denoising(par); 

disp( sprintf('The denoised result is: PSNR = %3.2f  FSIM = %3.4f\n',  PSNR, FSIM) ); 
imwrite(im_re/255, 'Results\Lena512_LSM_NLR.tif');
figure,imshow([par.y im_re]/255)
