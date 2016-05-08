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
        
        //load other images TODO imgs_used randomized every lines
        tic();
        disp('TEST');
        for k = 1 : size(classes,2)
            for j = 1 : size(test_images,2)
                //todo test has changed
                [l,c] = test(classes(1,k),string(test_images(1,j)),i);
                l = find(classes==s_class);//clalculate l here
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

//ISSUE with img that are not in database...mais c'est un peu normal wesh
function faceOrNotFace()
    
    //improvement use big img and visagedetect
    //resizeImg(a, [56 46])
    //
    
//    threshold = startRecognition();
    
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
