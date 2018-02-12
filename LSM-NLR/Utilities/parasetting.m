function par  =   parasetting( par )
par.step      =   4;
par.nblk      =   40;
noise_var     =   par.nsig; 
par.c3        =   3;
par.beta      =  1.2;
if  par.INlevel <= 0.15
    par.win   =   7;
else
    par.win   =   8;
end
if noise_var <= 10
    par.c2          =  1.2; 
    if par.INlevel  <  0.3   
       par.itt_loop =  3; 
    else
       par.itt_loop =  5; 
    end
elseif noise_var <=20
    if par.INlevel <=  0.3
       par.itt_loop =  2;       
       par.c2       =  1.5;          
    else           
       par.itt_loop =  4; 
       par.c2       =  1.2;          
    end
elseif noise_var <=30    
    par.itt_loop    =  2;    
    if par.INlevel  <  0.3
       par.c2       =  1.5;   
    else
       par.c2       =  1.2;
    end
else
    par.nblk        =  50;
    par.itt_loop    =  2;    
    par.c2          =  1.2;
end
end