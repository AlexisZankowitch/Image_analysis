//UTILITY FUNCTIONS

function storeData(path,data,name)
    mkdir(path);
    cd(path);
    csvWrite(data, name);
    cd('../');
endfunction

function data = loadData(path,name,obj_type)
    //issue csvread string || double :o
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
    for i = 1 : size(eigenfaces_show,2)
        img = matrix(eigenfaces_show(:,i),56,46);
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


function T = loadImages(base_path,nbImages)
    folders_images = "";
    images = string(1);
    imgs = grand(1, "prm", (1:10));
    imgs = imgs(1:1:nbImages);
    
    for i = 1 : size(classes,2)
        folders_images = strcat([base_path,'/',classes(i),'/']);
        for j = 1 : size(imgs,2)
            images = [images(1:$, :); strcat([folders_images,string(imgs(j)),ext]);];
        end
    end
    //T Creation
    img = chargerImage(images(2),0);
    img = transformIntoVector(img);
    T = zeros(size(classes,1)*nbImages,size(img,2));
    //ISSUE 
    T(1,:) = img(1,:);
    for i = 2 : size(images,1)-1
        img = chargerImage(images(i+1),0);
        img = transformIntoVector(img);
        T(i,:) = img(1,:);
    end
//    disp(imgs);
//    disp(images)
//    disp(size(images))
    //test
    if size(imgs,2) == nbImages then
        //save to load only images that we didn't use to create learning base
        storeData(path_data,imgs,'imgs');
    else 
        error('Wrong size imgs -- loadImages');
    end
endfunction
