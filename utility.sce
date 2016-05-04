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


function [T,nb_item] = loadImages(base_path,nbImages)
    //TEST
    for i = 1 : size(classes,2)
        folders_images(i) = strcat([base_path,'/',classes(i),'/']);
        nb_item(i) = size(ls(folders_images),1);
        if nb_item(i) < nbImages then
            error(['Not enough images into foldes -- loadImages';folders_images]);
        end
    end
    
    images = string(1);
    imgs = grand(1, "prm", (1:min(nb_item)));
    imgs = imgs(1:1:nbImages);
    
    for i = 1 : size(folders_images,1)
        for j = 1 : size(imgs,2)
            images = [images(1:$, :); strcat([folders_images(i),string(imgs(j)),ext]);];
        end
    end
    //T Creation
    img = chargerImage(images(2),0);
    img = transformIntoVector(img);
    T = zeros(size(classes,1)*nbImages,size(img,2));
    T(1,:) = img(1,:);
    for i = 2 : size(images,1)-1
        img = chargerImage(images(i+1),0);
        img = transformIntoVector(img);
        T(i,:) = img(1,:);
    end
    
    //TEST
    if size(imgs,2) == nbImages then
        //save to load only images that we didn't use to create learning base
        storeData(path_data,imgs,'imgs');
        disp(["Images used :"]);
        disp(imgs)
    else 
        error('Wrong size imgs -- loadImages');
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

function [base_path,att_faces,path_data,ext,classes] = initialization()
    stacksize('max')
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    path_data = strcat([base_path,'/data/']);
    ext = '.pgm';
    classes = ls(strcat([base_path att_faces]));
    storeData(path_data,classes','classes');
    classes = loadData(path_data,'classes','string');
endfunction
