function  pos_arr   =  Block_matching(im_patch,par)
im        =   par.y;
S         =   21;
f         =   par.win;
s         =   par.step;
m         =   par.nblk;

N         =   size(im,1)-f+1;
M         =   size(im,2)-f+1;
r         =   [1:s:N];
r         =   [r r(end)+1:N];
c         =   [1:s:M];
c         =   [c c(end)+1:M];
L         =   N*M;

X         =   im_patch';
mX        =   sum(X.^2, 2)/2;
i         =   1;
j         =   1;

% Index image
I     =   (1:L);
I     =   reshape(I, N, M);
N1    =   length(r);
M1    =   length(c);
pos_arr   =   zeros(m, N1*M1 );

for  t  =  1 : N1*M1

        off     =   (c(j)-1)*N + r(i);
        
        rmin    =   max( r(i)-S, 1 );
        rmax    =   min( r(i)+S, N );
        cmin    =   max( c(j)-S, 1 );
        cmax    =   min( c(j)+S, M );
         
        idx     =   reshape(I(rmin:rmax, cmin:cmax), [], 1);
        ii      =   find(idx==off);
        idx(ii) =   [];
        dis     =   (mX(idx, :) + mX(off, :) - X(idx, :)*X(off, :)');
        
        [val,ind]            =   sort(dis);               
        pos_arr(2:m, t)      =   idx( ind(1:m-1) ); 
        pos_arr(1, t)        =   off;

        i   =  i + 1;
        if i>N1
            i   =  1;
            j   =  j + 1;
        end
end