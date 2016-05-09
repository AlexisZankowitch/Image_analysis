function [m,s,eigenfaces] = learning(nbImages)
    
    disp('EIGENFACES GENERATION');
    T = loadImages(strcat([base_path,att_faces]),nbImages);
    [m,s] = prepareNormalization(T);
    T_second = normalization(T,m,s);
    eigenfaces = analysisPC(T_second);
    D = projection(T_second,eigenfaces);
    storeData(path_data,m,'m');
    storeData(path_data,s,'s');
    storeData(path_data,eigenfaces,'eigenfaces');
    storeData(path_data,D, 'D');

endfunction

function startLearning(max_imgs)
    [base_path,att_faces,path_data,classes] = initialization();
    tic();
    [m,s,eigenfaces] = learning(max_imgs);
    disp(strcat(['time :', string(toc())]));
    m = resizeImg(m);
    s = resizeImg(s);
    eigenfaces = resizeEigenfaces(eigenfaces)
    afficherImage([m s eigenfaces]);
endfunction
