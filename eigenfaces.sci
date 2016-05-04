function image_analysis(max_imgs)
    stacksize('max')
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    path_data = strcat([base_path,'/data/']);
    ext = '.pgm';
    overall_accuracy = zeros(1,max_imgs);
    classes = ls(strcat([base_path att_faces]));
    storeData(path_data,classes','classes');
    classes = loadData(path_data,'classes','string');
    
    disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
    for i = 1 : max_imgs
        
        //LEARNING
        disp(strcat(['learning :',string(i)]));
        confusion_matrix = zeros(size(classes,2),size(classes,2));
        tic();
        learning(i);
        disp(strcat(['time :', string(toc())]));
        imgs = loadData(path_data,'imgs','double');
        
        
        //TESTING
        
        //number of elements per class
        images = [1:1:10];
        test_images = [];
        //get other images
        for j = 1 : size(images,2)
            if isempty(find(imgs==images(j))) then
                test_images = [test_images images(j)]
            end
        end
        
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
