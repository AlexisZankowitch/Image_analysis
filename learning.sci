
// Eigenfaces and Descriptors generation
// nbImages (int) : number of images used per class
function [m,s,eigenfaces] = learning(nbImages)
    disp('EIGENFACES GENERATION');
    T = loadImages(strcat([base_path,att_faces]),nbImages);
    [m,s] = prepareNormalization(T);
    T_second = normalization(T,m,s);
    eigenfaces = pcAnalysis(T_second);
    D = projection(T_second,eigenfaces);
endfunction


// Use this function to generate and store Eigenfaces and Descriptors
function startLearning(max_imgs)
    [base_path,att_faces,path_data,classes] = initialization();
    tic();
    [m,s,eigenfaces] = learning(max_imgs);
    disp(strcat(['time :', string(toc())]));
    m = resizeImg(m);
    s = resizeImg(s);
endfunction
