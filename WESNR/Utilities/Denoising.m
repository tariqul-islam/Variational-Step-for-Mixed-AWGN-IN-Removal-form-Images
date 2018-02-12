function  [im_out, PSNR, FSIM] = Denoising(n_im, par, ori_im)
d_im           =   par.pim; 
cnt            =   1;
 

    for i  =  1 : par.K    
        
        if i==1 
            Y  =   Im2Patch( n_im, par );
            [Arr, Wei] =   find_blks( d_im, par );  
            [PCA_D, cls_idx, s_idx, seg,D1]  =   Set_PCA_idx( d_im, par, par.Codeword );                  
            [im_out , T]   =   WESNR1( Y,d_im, cls_idx, PCA_D, par, s_idx, seg, D1,Arr,Wei);
            d_im   =   im_out;

        else          
            if (mod(i,4)==0)             
                [Arr,  Wei] =    find_blks( d_im, par );
            end             
            [im_out,  T] = WESNR2( Y,d_im, cls_idx, PCA_D, par, s_idx, seg, D1,Arr,Wei,T); 
            d_im = im_out;
        end
                  
        PSNR            =   csnr( d_im, ori_im, 0, 0 );
        FSIM           =   FeatureSIM(ori_im,d_im);
        % fprintf( 'Preprocessing, Iter %d : PSNR = %12.8f,   FSIM=%12.8f\n', cnt, PSNR,FSIM);
        cnt           =  cnt + 1; 
    end
       
end    
    