function [im_out, PSNR, FSIM]  =  WESNR_Denoising( par )
time0            =   clock;
nim              =   par.nim;
nSig             =   par.nSig;
par.sigma        =   1.7;
par.win          =   7; %mask size win x win
par.step         =   3; %stride value
par.beta         =   0.0008;
par.em           =   0.1;


if nSig<=10
    par.nblk      =   20;
    par.lamba     =   0.5;     
    par.K         =   8;
    
elseif nSig <= 20
    par.nblk      =   60;
    par.lamba     =   1;
    par.K         =   10; 
    
else
     par.nblk     =   60;
    par.lamba     =   1;
    par.K         =   12;  

end
       n_im       =   nim;
    
    if isfield(par, 'I')  
      ori_im      =     par.I;
    end
    PSNR          =    csnr( nim, ori_im, 0, 0 );
    FSIM          =    FeatureSIM(nim, ori_im);
    
 disp(sprintf('The initial value of PSNR = %12.8f  FSIM=%12.8f\n', PSNR, FSIM));

[im_out, PSNR,  FSIM]      =  Denoising(n_im, par, ori_im);
    
disp(sprintf('Total elapsed time = %f s\n', (etime(clock,time0)) ));
return;