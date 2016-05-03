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

function vector = transformIntoVector(m)
    m = imresize(m,0.5);
    vector = matrix(m,size(m,1)*size(m,2),1)';
endfunction

function eigenfaces = analysisPC(T_second)
    disp('EIGENFACES GENERATION');
    cov_T_Second = cov(T_second);
    disp("cov");
    [u,s,v] = svd(cov_T_Second,0);
    disp("svd");
    //afficher lamba pour justifier le 48
//    disp(size(u));
//    disp(size(s));
//    disp(size(v));
    eigenfaces = u(:,[1:1:48]);
    disp('GENERATION DONE');
endfunction

function D = projection(vec, eigenfaces)
    D = vec * eigenfaces;
endfunction

function class = decision(vector,D,nb)
    class = 0;
    D_img = repmat(vector, size(D,1),1);
    D_img = D_img - D;
    [D_img,c] = min(diag(D_img * D_img'));
    //finds index
    class = ceil(c/nb);
endfunction
