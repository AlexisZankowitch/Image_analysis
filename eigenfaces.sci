function overallAccuracy(max_imgs)
    
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    
    overall_accuracy = zeros(1,max_imgs);
    
    disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
    for i = 1 : max_imgs
        
        //LEARNING
        disp(strcat(['learning :',string(i)]));
        confusion_matrix = zeros(size(classes,2),size(classes,2));
        tic();
        [m,s,eigenfaces] = learning(i);
        disp(strcat(['time :', string(toc())]));
        
        //load other images imgs_used randomized every lines
        tic();
        disp('TEST');
        for k = 1 : size(classes,2)
            [distance,img_classes] = startRecognition(classes(1,k));
            for l = 1 : size(img_classes,1)
                x = find(classes==classes(1,k));
                confusion_matrix(x,img_classes(l)) = confusion_matrix(x,img_classes(l)) + 1;
            end
        end
        disp(strcat(['time :', string(toc())]));
        
        overall_accuracy(1,i) = trace(confusion_matrix)/sum(confusion_matrix)
///////////////////////////////TODO/////////////////////////////////////////////
        //test
//        sum_th = size(classes,2) * size(test_images,2);
//        sum_re = sum(confusion_matrix);
//        if sum_th ~= sum_re then
//            error('Wrong size imgs into confusion Matrix--');
//        end
///////////////////////////////TODO/////////////////////////////////////////////
    end
    disp("overall_accuracy");
    disp(overall_accuracy);
    plot(overall_accuracy,"rx-");
    xtitle("overall accuracy")
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
