function learning(nbImages)
    
    T = loadImages(strcat([base_path,att_faces]));
    [m,s] = prepareNormalization(T);
    T_second = normalization(T,m,s);
    eigenfaces = analysisPC(T_second);
    D = projection(T_second,eigenfaces);
    storeData(path_data,m,'m');
    storeData(path_data,s,'s');
    storeData(path_data,eigenfaces,'eigenfaces');
    storeData(path_data,D, 'D');
    
    //affichage
//    m = resizeImg(m);
//    s = resizeImg(s);
//    e = resizeEigenfaces(eigenfaces)
//    afficherImage([m s e]);
endfunction

