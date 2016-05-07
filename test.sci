function [l,c,image_test,dist] = test(s_class , n_img, nb_imgs)
    
    [m,s,eigenfaces,D,classes] = getDatas()
    
    img = strcat([base_path,att_faces,'/',s_class,'/',n_img,ext])
    image_test = chargerImage(img,0);
    image_test_v = transformIntoVector(image_test);
    
    [dist,class] = decided(image_test_v)
    
    l = find(classes==s_class);
    c = class;
endfunction

function [dist,class] = decided(image_test_v)
    image_test_n = normalization(image_test_v,m,s);
    image_test_p = projection(image_test_n,eigenfaces);
    [dist,class] = decision(image_test_p,D,nb_imgs);
endfunction

function [dist,class] = testFace(img,nb_imgs)
    
    [m,s,eigenfaces,D,classes] = getDatas()
    [dist,class] = decided(img)
    
endfunction

function [m,s,eigenfaces,D,classes] = getDatas()
    d = 'double';
    str = 'string';
    m = loadData(path_data,'m',d);
    s = loadData(path_data,'s',d);
    eigenfaces = loadData(path_data,'eigenfaces',d);
    D = loadData(path_data,'D',d);
    classes = loadData(path_data, 'classes',str);
endfunction
