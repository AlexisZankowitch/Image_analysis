//UTILITY FUNCTIONS

function storeData(path,data,name)
    mkdir(path);
    cd(path);
    csvWrite(data, name);
    cd('../');
endfunction

function data = loadData(path,name,obj_type)
    //issue csvread string || double :o fixes -> obj_type
    cd(path);
    if obj_type == 'double' then
        data = csvRead(name);
    elseif obj_type == 'string' then 
        data = read_csv(name);
    end
    cd('../');
endfunction

//load image and stock it into a matrix
function matrix_image=chargerImage(path,isRGB)
    if isRGB == 0 then
        matrix_image=double(imread(path));
    else
        matrix_image=double(rgb2gray(imread(path)));
    end
endfunction

function imgs = resizeEigenfaces(eigenfaces)
    imgs = [];
    eigenfaces_show = eigenfaces * 1000 + 128;
    for ii = 1 : size(eigenfaces_show,2)
        img = matrix(eigenfaces_show(:,ii),56,46);
        imgs = [imgs img]
    end
    afficherImage(imgs)
endfunction

function img = resizeImg(vector,str)
    img=matrix(vector,56,46);
endfunction

//Show image
function afficherImage(matrix_image)
    imshow(uint8(matrix_image));
endfunction

//Save image
function image = ecrireImage(matrix_image,nomFichier)
    image=imwrite(matrix_image,nomFichier);
endfunction

//load all images
function [T,images] = loadTestFacesImages(path)
    cd(path)
    images = ls();
    T = tCreation(images,size(images,1));
    cd('../')
endfunction

//load rand nbImages per class
function T = loadImages(base_path,nbImages)
    images ="";
    
    //TEST
    for i = 1 : size(classes,2)
        folders_images = strcat([base_path,'/',classes(i),'/']);
        items = ls(folders_images);
        if size(items,1) < nbImages then
            error(['Not enough images into foldes -- loadImages';folders_images]);
        end
        //random
        rn = grand(1, "prm", (1:size(items,1)));
        rn = rn(1:1:nbImages);
        
        for j = 1 : size(rn,2)
            //fill images with all the path we need
            images = [images strcat([folders_images,items(rn(j))]);];
            imgs(i,j) = items(rn(j));
        end;
    end
//    delete first line
    images(1) = []
    images = images';
    T = tCreation(images,nbImages);
    
    //TEST
    if size(imgs,2) == nbImages then
        //save to load only images that we didn't use to create learning base
        storeData(path_data,imgs,'imgs');
    else 
        error('Wrong size imgs -- loadImages');
    end
endfunction

//T Creation
function T = tCreation(images,nbImages)
    img = chargerImage(images(1),0);
    img = transformIntoVector(img);
    T = zeros(size(classes,1)*nbImages,size(img,2));
    T(1,:) = img(1,:);
    for i = 2 : size(images,1)
        img = chargerImage(images(i),0);
        img = transformIntoVector(img);
        T(i,:) = img(1,:);
    end
endfunction

function test_images = getOtherImages(nb_folders)
    //number of elements per class
    images = [1:1:min(nb_folders)];
    test_images = [];
    //get other images
    for j = 1 : size(images,2)
        if isempty(find(imgs==images(j))) then
            test_images = [test_images images(j)]
        end
    end
endfunction

function [base_path,att_faces,path_data,classes,imgs_used] = initialization()
    stacksize('max')
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    path_data = strcat([base_path,'/data/']);
    classes = ls(strcat([base_path att_faces]));
    storeData(path_data,classes','classes');
    classes = loadData(path_data,'classes','string');
    imgs_used = loadData(path_data,'imgs','double');
endfunction
