function im_re   =  Denoising(par)

y            =    par.y;
[h, w, ~]    =    size(y);
b            =    par.win;
N            =    h-b+1;
M            =    w-b+1;
r            =    [1:N];
c            =    [1:M];

itt_loop     =    par.itt_loop;
im_ini       =    par.im_ini;
ind          =    par.ind;
mask_patch   =    par.mask_patch;
nim_patch    =    par.nim_patch;

im_re        =    im_ini;
nsig         =    par.nsig;
W            =    20./abs(y-im_re);

for itt   =  1 : itt_loop
    
    if itt >= 2
        y     =   im_re  +  0.50*(y-im_re).*ind  - 0.2*(im_ini-im_re).*(1-ind) ;
    end
    S         =   solve_E (y-im_re, 1./(W.^2));
    im_patch  =   Im2Patch(y-S,par);
    blk_arr   =   Block_matching(im_patch, par);

    
    U         =  cell(size(blk_arr,2),1);
    L         =  cell(size(blk_arr,2),1);
    beta      =  par.beta;
    for it = 1 : 2
        Ys        =  zeros( size(im_patch) );
        T         =  zeros( size(im_patch) );
        for ii = 1 : size(blk_arr,2)
            blk_idx  =  blk_arr(:, ii);
            psite    =  mask_patch(:,blk_idx);
            RX       =  im_patch(:,blk_idx);
            if it == 1
                U{ii}    =  zeros(size(RX));
            end
            stop_L   =  1; iter = 0;
            if stop_L
                RX        =  RX - 0.8*(RX - nim_patch(:,blk_idx)).*psite;
                L{ii}     =  solve_NLR (RX + U{ii}/(2*beta), par);
                patch_pre =  RX;
                RX        =  L{ii};
                error     =  norm( patch_pre-L{ii},'fro');
                if  error < 10^(-5) || iter>=2
                    stop_L = 0;
                end
                iter      =  iter + 1;
            end
            Ys(:,blk_idx) =  Ys(:,blk_idx) + L{ii}; 
            T(:,blk_idx)  =  T(:, blk_idx) + 1;
        end
        
        im_out   =  zeros(h,w);
        im_wei   =  zeros(h,w);
        k        =   0;
        for i    =   1 : b
            for j  = 1 : b
                k    =  k+1;
                im_out(r-1+i,c-1+j)  =  im_out(r-1+i,c-1+j) + reshape( Ys(k,:)', [N M]);
                im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + reshape( T(k,:)',  [N M]);
            end
        end        
        im_re      =  ((y-S).*beta./(2*nsig^2) + im_out)./(beta./(2*nsig^2) + im_wei+eps);      
        im_patch   =  Im2Patch(im_re,par);
        for ii = 1 : size(blk_arr,2)
            blk_idx=  blk_arr(:, ii);
            U{ii}  =  U{ii} + beta*(im_patch(:,blk_idx)-L{ii});
        end
        beta       =  1.2*beta;
    end
       W           =   1./(abs(y-im_re-S)+eps);
       nsig        =   1.1*sqrt(norm((y-im_re-S).*ind,'fro')^2/sum(sum(ind)));
end
end

function [X_hat]   =   solve_NLR (X, par)

    [~,n]          =   size(X);
    [U0,Sigma0,V0] =   svd(full(X),'econ');
    Sigma0         =   diag(Sigma0);
    nsig           =   par.c2 * par.nsig;
    S              =   max( Sigma0.^2/n - nsig^2, 0 );
    thr            =   par.c3*(par.nsig)^2./ ( sqrt(S) + eps );
    S              =   soft(Sigma0, thr);
    rr             =   sum( S>0 );
    X_hat          =   U0(:,1:rr)*diag(S(1:rr))*V0(:,1:rr)';
end

function    S      =   solve_E (y, mu) 
    [~,n]          =   size(y);
    theta0         =   repmat(sqrt(sum(y.^2,2)/n),1,n);

    alpha          =   y./(theta0+eps); 
    a              =   alpha.^2;
    b              =   -2*alpha.*y;
    c              =   4*mu;
    
    tmp1           =   -b./(4*a+eps);
    tmp2           =   b.^2./(16*a.^2) - c./(2*a);
    idx            =   tmp2>=0;
    tmp1(idx==0)   =   0;
    tmp2(idx==0)   =   0;

    t1             =   tmp1 + sqrt(tmp2);
    t2             =   tmp1 - sqrt(tmp2);
        
    f0             =   c*log(eps);
    f1             =   a.*t1.^2 + b.*t1 + c.*log(t1+eps);
    f2             =   a.*t2.^2 + b.*t2 + c.*log(t2+eps);
    
    ind            =   f2<f1;
    f1(ind)        =   f2(ind);
    t1(ind)        =   t2(ind);
    ind            =   f0<f1;
    t1(ind)        =   0;
    theta          =   t1;
    
    aa             =   y./(theta+eps);
    thr            =   2*sqrt(2)*mu./(theta.^2+eps);
    alpha          =   soft(aa, thr); 
    S              =   theta.*alpha;
end