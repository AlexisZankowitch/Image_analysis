function [l,c] = test(s_class , n_img, nb_imgs)
    
    d = 'double';
    str = 'string';
    img = strcat([base_path,att_faces,'/',s_class,'/',n_img,ext])
    image_test = chargerImage(img,0);
    image_test_v = transformIntoVector(image_test);
    m = loadData(path_data,'m',d);
    s = loadData(path_data,'s',d);
    eigenfaces = loadData(path_data,'eigenfaces',d);
    D = loadData(path_data,'D',d);
    classes = loadData(path_data, 'classes',str);
    
    
    image_test_n = normalization(image_test_v,m,s);
    image_test_p = projection(image_test_n,eigenfaces);
    class = decision(image_test_p,D,nb_imgs);
    
//    disp("class :");
//    disp(strcat([s_class, ' / ', classes(class)]));
//    img_decision = chargerImage(strcat([base_path,att_faces,'/',classes(class),'/1',ext]),0);
    //try to decide with n nearer neighbours 
//    afficherImage([img_decision image_test]);
    
    l = find(classes==s_class);
    c = class;
endfunction
