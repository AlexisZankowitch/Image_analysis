// starts recognition for images of a class which were not used to make descriptors
function [threshold,img_classes] = startRecognition(n_class)
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    checkClasses();
    if isnum(string(n_class)) then
        n_class = strcat(['s',string(n_class)]);
    end
    [dist,img_classes,image_test_p,imgs] = recognition(classes(find(classes==n_class)));
    threshold = mean(dist);
    
    //img reconstruction
    imgs = [imgs imageReconstruction(image_test_p)];
    afficherImage(imgs);
endfunction

// recogntition for one image
function [c,image_test,dist,image_test_p] = test(path_img, nb_imgs)
    
    [m,s,eigenfaces,D,classes] = getDatas()
    image_test = chargerImage(path_img,0);
    image_test_v = transformIntoVector(image_test);
    
    [dist,class,image_test_p] = decided(image_test_v)
    
    c = class;
endfunction

// returns the class of an image
function [dist,class,image_test_p] = decided(image_test_v)
    image_test_n = normalization(image_test_v,m,s);
    image_test_p = projection(image_test_n,eigenfaces);
    [dist,class] = decision(image_test_p,D,nb_imgs);
endfunction

//test vector img
function [dist,class,image_test_p] = testFace(img,nb_imgs)
    
    [m,s,eigenfaces,D,classes] = getDatas()
    [dist,class,image_test_p] = decided(img)
    
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

//TODO RETURN classes table
function [distances,img_classes,img_pro,imgs] = recognition(n_class)
    imgs=[];
    imgs_not_used=[];
    imgs_decision=[];
    if isempty(find(classes==n_class)) then
        error('class does not exist');
    end
    
    class_path = strcat([base_path,att_faces,'/',n_class]);
    imgs_class = ls(class_path);
    
    //delete imgs_used
    for i = 1 : size(imgs_class,1)
        if isempty(find(imgs_used(find(classes==n_class),:)==imgs_class(i))) then
            imgs_not_used=[imgs_not_used imgs_class(i)];
        end
    end
    
    for i = 1 : size(imgs_not_used,2)
        [c,image_test,dist,image_test_p] = test(strcat([class_path,'/',imgs_class(i)]),size(imgs_used,2));
        distances(i)=dist;
        //todo check if dist = 0 isn't a mistake :/
        str = strcat([n_class, ' / ', classes(c)]);
//            disp(strcat(["image :",imgs_class(i)]) strcat(["dist :",string(dist)]) strcat(["class :",str]));
        img_classes(i)=c;
        img_decision = chargerImage(strcat([base_path,att_faces,'/',classes(c),'/1.pgm']),0);//todo don't like 1.pgm
        //must resize img because img_pro.size = (56,46)
        imgs = [imgs imresize(img_decision,0.5)];
        imgs = [imgs imresize(image_test,0.5)];
        img_pro(i,:)=image_test_p;
    end
    
    
//    afficherImage(imgs);
    
endfunction

// starts recognition for all classes
function threshold = startAllRecognition()
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    checkClasses();
    
    winH=waitbar('Recognition in progress');
    for i=1:size(classes,2)
        [dist,img_class]=recognition(classes(1,i));
        distances(i,:) = dist'
        mean_distances(i)=mean(dist);
        img_classes(i,:) = img_class';
        waitbar(i/size(classes,2),winH);
    end
    disp(size(distances)) //distances de chaque img
    disp(size(img_classes)) //classe de chaque image    
    close(winH);
///////////////////////////////TODO/////////////////////////////////////////////
//      Trace a figure per class but it will be a lot of figure wesh
///////////////////////////////TODO/////////////////////////////////////////////
    //plot
    plot(img_classes,distances,'-')//figure not really readable :/
    plot([1:1:size(classes,2)],mean_distances,'x-');
    xtitle("Distance and mean per class","class","distance");
    threshold = mean(distances);
endfunction

// test if classes are initialized
function checkClasses()
    check =ls(strcat([base_path,att_faces]))';
    if size(classes,2) ~= size(check,2) then
        error('Classes not initialzied -- use startLearning(x)')
    end
endfunction

