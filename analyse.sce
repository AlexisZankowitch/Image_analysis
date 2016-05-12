function [m,s] = prepareNormalization(T)
    m = mean(T,1);
    s = stdev(T,1);
endfunction

function [T_second] = normalization(T,m,s)   
    m1 = repmat(m, size(T,1),1);
    s1 = repmat(s, size(T,1), 1);
    T_second = T-m1;
    T_second = T_second ./ s1;
endfunction

function vector = transformIntoVector(v)
    v = v(:,:,1);
    v = imresize(v,[56 46]);
    vector = matrix(v,size(v,1)*size(v,2),1)';
endfunction

function eigenfaces = analysisPC(T_second)
    cov_T_Second = cov(T_second);
    [u,s,v] = svd(cov_T_Second,0);
    //afficher lamba pour justifier le 48
    eigenfaces = u(:,[1:1:48]);
endfunction

function D = projection(vec, eigenfaces)
    D = vec * eigenfaces;
endfunction

function [dist,class] = decision(vector,D,nb)
    class = 0;
    D_img = repmat(vector, size(D,1),1);
    D_img = D_img - D;
    [dist,c] = min(diag(D_img * D_img'));
    //finds index
///////////////////////////////TODO/////////////////////////////////////////////
// create table size D each line contains class of D
///////////////////////////////TODO/////////////////////////////////////////////
    class = ceil(c/nb);
endfunction

///////////////////////////////TODO/////////////////////////////////////////////
//      Reconstruct img wesh issue WITH RECONSTRUCT
///////////////////////////////TODO/////////////////////////////////////////////
function imgs = imageReconstruction(img_pro)
    //Img reconstruction
    [m,s,eigenfaces,D,classes] = getDatas()
    m1 = repmat(m, size(eigenfaces,1),1);
    s1 = repmat(s, size(eigenfaces,1),1);
    imgs = []
    for i=1:size(img_pro,1)
        img_pro_rec = eigenfaces*img_pro(i,:)'; 
        img_pro_rec = img_pro_rec' * s1';
        img_pro_rec = img_pro_rec + m;
        imgs = [imgs resizeImg(img_pro_rec)]
    end
endfunction
