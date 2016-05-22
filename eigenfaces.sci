function overallAccuracy(max_imgs)
    //to get better result redo overall accuracy and plot
    [base_path,att_faces,path_data,classes] = initialization();
//    for j = 1 : 10
        overall_accuracy = zeros(1,max_imgs);
//        winH=waitbar('Work in progress');
        percent = 0;
        img_eigenfaces = [];
        disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
        for i = 1 : max_imgs
            
            //LEARNING
            disp(strcat(['learning :',string(i)]));
            confusion_matrix = zeros(size(classes,2),size(classes,2));
            tic();
            [m,s,eigenfaces] = learning(i);
            disp(strcat(['time :', string(toc())]));
//            img_eigenfaces = [img_eigenfaces resizeEigenfaces(eigenfaces)]
            
            tic();
            disp('TEST');
            for k = 1 : size(classes,2)
                [distance,img_classes,imgs] = launchRecognition(classes(1,k));
                for l = 1 : size(img_classes,1)
                    x = find(classes==classes(1,k));
                    confusion_matrix(x,img_classes(l)) = confusion_matrix(x,img_classes(l)) + 1;
                end
//                percent = grothWaitBar(percent,max_imgs*size(classes,2),winH)
            end
            disp(strcat(['time :', string(toc())]));
            overall_accuracy(j,i) = trace(confusion_matrix)/sum(confusion_matrix)
        end
//        close(winH);
//    end
    
    
    //eigenface display
    img_eigenfaces=repmat(img_eigenfaces,max_imgs,1)
    img_eigenfaces=resize_matrix(img_eigenfaces,size(img_eigenfaces,1),size(img_eigenfaces,2)/max_imgs)
    afficherImage(img_eigenfaces)
    
    disp("overall_accuracy");
    disp(overall_accuracy);
    plot(overall_accuracy,"rx-");
    xtitle("overall accuracy")
endfunction

function faceDetection(nb_imgs_base)   
    
    winH=waitbar('Work in progress');
    [base_path,att_faces,path_data,classes] = initialization();
    percent = 0;
    images = [];
    m = loadData(path_data,'m','double');
    s = loadData(path_data,'s','double');
    for k = 1 : nb_imgs_base
        //learning
        startLearning(k);
        imgs_used = loadData(path_data,'imgs','double');
        [imgs,img_name] = loadTestFacesImages(strcat([base_path,"/img_test"]));
        
        for i=1 : size(imgs,1)
            //distance calculation
            [dist,c,image_test_p] = testFace(imgs(i,:),size(imgs_used,2))
            img_pro(i,:)=image_test_p;
            images = [images resizeImg(imgs(i,:)) imageReconstruction(image_test_p)]
            distances(k,i)=dist;
            img_classes(k,i)=c;
            //distance between original image and its reconstructions
            img_ori = transformIntoVector(imgs(i,:));
            img_rec = transformIntoVector(imageReconstruction(img_pro(i,:)));
            img_ori=normalization(img_ori,m,s);
            img_rec=normalization(img_rec,m,s);
            //ca
            eucli_dist(i,k) = norm(img_ori)-norm(img_rec);
            percent = grothWaitBar(percent,nb_imgs_base*size(imgs,1),winH);
        end
    end
    close(winH);
    
    //img display
    images=repmat(images,nb_imgs_base,1)
    images=resize_matrix(images,size(images,1),size(images,2)/nb_imgs_base)
    afficherImage(images)
    
    figure
    f=gcf();
    subplot(221)
    plot2d([1:1:size(distances,1)]',distances([1:1:$],:),([1:1:size(distances,2)]));
    xtitle('distance / nb Image learning base','nb image learning base','distance')
    subplot(222)
    plot2d([1:1:size(img_classes,1)]',img_classes([1:1:$],:),([1:1:size(distances,2)]));
    //it would be perfect if the data was traced with dots.... but I don't know how to do it :/
    xtitle('classes / nb Image learning base','nb image learning base','classes')
    subplot(223)
    plot([1:1:size(imgs,1)]',eucli_dist,'x')
    xtitle('dist between img ori and rec','n° img','dist')
    subplot(224)
    legends(img_name(1:1:$,1),([1:1:size(distances,2)]),opt='lr')
    f.backgroundcolor=[0.7,0.7,0.7];
endfunction

function percent = grothWaitBar(percent,fac,winH)
    percent = percent + 1;
    waitbar(percent/fac,winH);
endfunction
