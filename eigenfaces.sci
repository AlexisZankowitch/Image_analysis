function overallAccuracy(max_imgs)
    
    [base_path,att_faces,path_data,classes,imgs_used] = initialization();
    
    overall_accuracy = zeros(1,max_imgs);
    winH=waitbar('Work in progress');
    perCent = 0;
    disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
    for i = 1 : max_imgs
        
        //LEARNING
        disp(strcat(['learning :',string(i)]));
        confusion_matrix = zeros(size(classes,2),size(classes,2));
        tic();
        [m,s,eigenfaces] = learning(i);
        disp(strcat(['time :', string(toc())]));
        
        tic();
        disp('TEST');
        for k = 1 : size(classes,2)
            [distance,img_classes] = startRecognition(classes(1,k));
            for l = 1 : size(img_classes,1)
                x = find(classes==classes(1,k));
                confusion_matrix(x,img_classes(l)) = confusion_matrix(x,img_classes(l)) + 1;
            end
            grothWaitBar(percent,max_imgs*size(classes,2),winH)
        end
        disp(strcat(['time :', string(toc())]));
        overall_accuracy(1,i) = trace(confusion_matrix)/sum(confusion_matrix)
    end
    //TEST
    sum_th = size(classes,2) * size(imgs_used,2);
    sum_re = sum(confusion_matrix);
    if sum_th ~= sum_re then
        error('Wrong size imgs into confusion Matrix--');
    end
    close(winH);
    disp("overall_accuracy");
    disp(overall_accuracy);
    plot(overall_accuracy,"rx-");
    xtitle("overall accuracy")
endfunction

//ISSUE with img that are not in database...mais c'est un peu normal wesh
function faceDetection()
    
    //improvement use big img and visagedetect
    //resizeImg(a, [56 46])
    //
///////////////////////////////TODO/////////////////////////////////////////////
//      threshold ? try to reconstruct the image and calculte dist between 
//      original and recreate
///////////////////////////////TODO/////////////////////////////////////////////
//    threshold = startRecognition();
    
    
    winH=waitbar('Work in progress');
    [base_path,att_faces,path_data,classes] = initialization();
    percent = 0;
    for k = 10 : 10 
//        startLearning(k);
        imgs_used = loadData(path_data,'imgs','double');
        [imgs,img_name] = loadTestFacesImages(strcat([base_path,"/img_test"]));
        images = []
        
        for i=1 : size(imgs,1)
            [dist,c,image_test_p] = testFace(imgs(i,:),size(imgs_used,2))
            img_pro(i,:)=image_test_p;
            images = [images resizeImg(imgs(i,:))]
            distances(k,i)=dist;
            img_classes(k,i)=c;
            percent = grothWaitBar(percent,10*size(imgs,1),winH);
        end
//        afficherImage(images)
    end
    close(winH);
    
    figure
    plot2d([1:1:size(distances,1)],distances([1:1:$],:),([1:1:size(distances,2)]));
    xtitle('distance / nb Image learning base','nb image learning base','distance')
    legends(img_name(1:1:$,1),[1:1:size(distances,2)],opt='lr')
    figure
    plot([1:1:size(img_classes,1)],img_classes([1:1:$],:),([1:1:size(img_classes,2)]));
    //it would be perfect if the data was traced with dots.... but I don't know how to do it :/
    xtitle('classes / nb Image learning base','nb image learning base','classes')
    legends(img_name(1:1:$,1),([1:1:size(img_classes,2)]),opt='lr')
   
    imgs = imageReconstruction(img_pro);
    
    afficherImage(imgs)
   
endfunction

function percent = grothWaitBar(percent,fac,winH)
    percent = percent + 1;
    waitbar(percent/fac,winH);
endfunction
