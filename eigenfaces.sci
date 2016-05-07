function overallAccuracy(max_imgs)
    
    [base_path,att_faces,path_data,ext,classes] = initialization();
    
    overall_accuracy = zeros(1,max_imgs);
    
    disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
    for i = 1 : max_imgs
        
        //LEARNING
        disp(strcat(['learning :',string(i)]));
        confusion_matrix = zeros(size(classes,2),size(classes,2));
        tic();
        [m,s,eigenfaces] = learning(i);
        disp(strcat(['time :', string(toc())]));
        imgs = loadData(path_data,'imgs','double');
        
        //TESTING
        test_images = getOtherImages(nb_folders)
        
        //load other images
        tic();
        disp('TEST');
        for k = 1 : size(classes,2)
            for j = 1 : size(test_images,2)
                [l,c] = test(classes(1,k),string(test_images(1,j)),i);
                confusion_matrix(l,c) = confusion_matrix(l,c) + 1;
            end
        end
        disp(strcat(['time :', string(toc())]));
        
        overall_accuracy(1,i) = trace(confusion_matrix)/sum(confusion_matrix)
        
        //test
        sum_th = size(classes,2) * size(test_images,2);
        sum_re = sum(confusion_matrix);
        if sum_th ~= sum_re then
            error('Wrong size imgs into confusion Matrix--');
        end
    end
    disp("overall_accuracy");
    disp(overall_accuracy);
    plot(overall_accuracy,"rx-");
    xtitle("overall accuracy")
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

//TODO img_used changed go to line x to get imgs_used by class

function startRecognition()
    
    [base_path,att_faces,path_data,ext,classes,imgs_used] = initialization();
    
    
    n_class = size(classes,2) + 1;
    n_img = imgs_used(1);


//    choose class
    while (size(classes,2)<n_class)
        n_class = input(strcat(["choose a class between 1 and ",string(size(classes,2)),": "]));
    end
    n_class = strcat(["/s",string(n_class)]);
    
//    while(find(imgs_used==n_img))
//        disp(["Images used :"]);
//        disp(imgs_used);
//        n_img = input("Choose a different image than those which have been used: ");
//    end
    
    class_path = strcat([base_path,att_faces,n_class]);
    imgs_class = ls(class_path);
    for i = 1 : size(imgs_class,1)
        if ~isempty(find(imgs_used==imgs_class(i))) then
            disp(strcat([class_path,'/',imgs_class(i)]))
        else
            disp("aze")
        end
//        [l,class,image_test,dist] = testFace(strcat([class_path,'/',imgs_class(i)]),size(imgs_used,2));
    end
    
//    [l,class,image_test,dist] = test(n_class,string(n_img),size(imgs_used,2));
//    
//    disp("class :");
//    disp(strcat([n_class, ' / ', classes(class)]));
//    disp(strcat(["dist :",string(dist)]));
//    img_decision = chargerImage(strcat([base_path,att_faces,'/',classes(class),'/1',ext]),0);
//    afficherImage([img_decision image_test]);
    
endfunction

function faceOrNotFace()
    
    //improvement use big img and visagedetect
    //resizeImg(a, [56 46])
    //
    
    [base_path,att_faces,path_data,classes] = initialization();
    imgs_used = loadData(path_data,'imgs','double');
    
    [imgs,img_name] = loadTestFacesImages(strcat([base_path,"/img_test"]));
    images = []
    for i=1 : size(imgs,1)
        [dist,c] = testFace(imgs(i,:),size(imgs_used,2))
        disp(strcat([img_name(i)," :" , string(dist), " classe: ", classes(c)]))
        images = [images resizeImg(imgs(i,:))]
    end
    afficherImage(images)
endfunction
