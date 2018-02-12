function [im_re PSNR FSIM]      =   LSM_NLR_Denoising(par)

par           =   parasetting(par);    
par.nim_patch =   Im2Patch(par.y,par);
%par.ind       =   (par.y~=0)&(par.y~=255);
par.mask_patch=   Im2Patch(par.ind, par );

clock0        =   clock;
im_re         =   Denoising(par);
disp(sprintf('Total elapsed time = %4.2f s\n', (etime(clock,clock0)) ));

PSNR          =   csnr(im_re,par.I,0,0);
FSIM          =   FeatureSIM(im_re,par.I);

end