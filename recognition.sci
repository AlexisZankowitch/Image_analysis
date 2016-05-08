function [c,image_test,dist] = test(path_img, nb_imgs)
    
    [m,s,eigenfaces,D,classes] = getDatas()
    image_test = chargerImage(path_img,0);
    image_test_v = transformIntoVector(image_test);
    
    [dist,class] = decided(image_test_v)
    
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

//TODO RETURN classes table
function [distances,class] = recognition(n_class)
    imgs=[];
    imgs_not_used=[];
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
        [class,image_test,dist] = test(strcat([class_path,'/',imgs_class(i)]),size(imgs_used,2));
        distances(i)=dist;
        //todo check if dist = 0 isn't a mistake :/
        str = strcat([n_class, ' / ', classes(class)]);
//            disp(strcat(["image :",imgs_class(i)]) strcat(["dist :",string(dist)]) strcat(["class :",str]));
        imgs = [imgs image_test];
    end
    
//    img_decision = chargerImage(strcat([base_path,att_faces,'/',classes(class),'/1.pgm']),0);//todo don't like 1.pgm :o
//    afficherImage([img_decision imgs]);
    
endfunction

function threshold = startAllRecognition()
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    checkClasses();
    distances = []
    
    winH=waitbar('Recognition in progress');
    for i=1:size(classes,2)
        dist=recognition(classes(1,i));
        distances = [distances dist];
        mean_distances(i)=mean(dist);
        waitbar(i/size(classes,2)),winH);
    end
    close(winH);
    
    //y construction yep I know not very sexy.... =D
    c = 0;
    y = [];
    for i=1:size(classes,2)*size(imgs_used,2)
        if modulo(i,size(imgs_used,2))=1 then
            c = c+1;
        end
        y = [y c];
    end
    y = matrix(y,size(imgs_used,2),size(classes,2))
    
    //plot
    plot(y,distances,'o-')
    plot([1:1:size(classes,2)],mean_distances,'x-');
    xtitle("Distance and mean per class","class","distance");
    
    threshold = mean(distances);
endfunction

function threshold = startRecognition(n_class)
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    checkClasses();
    n_class = strcat(['s',string(n_class)]);
    dist = recognition(classes(find(classes==n_class)));
    threshold = mean(dist);
endfunction

function checkClasses()
    check =ls(strcat([base_path,att_faces]))';
    if size(classes,2) ~= size(check,2) then
        error('Eigenfaces not initialzied -- use startLearning(x)')
    end
endfunction

