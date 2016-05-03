function image_analysis(max_imgs)
    rand('seed',getdate('s'));
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    path_data = strcat([base_path,'/data/']);
    ext = '.pgm';
    overall_accuracy = zeros(1,max_imgs);
    classes = ls(strcat([base_path att_faces]));
    storeData(path_data,classes','classes');
    classes = loadData(path_data,'classes','string');
    
    stacksize('max')
    
    disp(strcat(['Start image analysis with  :',string(max_imgs),' image(s)']));
    for i = 5 : max_imgs
        disp(strcat('learning :',string(i)));
        confusion_matrix = zeros(size(classes,2),size(classes,2));
        learning(i);
        imgs = loadData(path_data,'imgs','double');
        
        //number of elements per class
        images = [1:1:10];
        test_images = [];
        //get other images
        disp("get other images");
        for j = 1 : size(images,2)
            if isempty(find(imgs==images(j))) then
                test_images = [test_images images(j)]
            end
        end
        
        //load other images
        disp("test other images");
        for k = 1 : size(classes,2)
            for j = 1 : size(test_images,2)
                [l,c] = test(classes(1,k),string(test_images(1,j)));
//                disp(classes(1,k))
//                disp(l)
//                disp(c)
                confusion_matrix(l,c) = confusion_matrix(l,c) + 1;
            end
        end
        
        overall_accuracy(1,i) = trace(confusion_matrix)/sum(confusion_matrix)
        
        sum_th = size(classes,2) * size(test_images,2);
        sum_re = sum(confusion_matrix);
        if sum_th ~= sum_re then
            error('Wrong size imgs into confusion Matrix--');
        end
    end
    disp("Done analysis");
    disp("overall_accuracy");
    disp(overall_accuracy);
endfunction





image_analysis(5);
