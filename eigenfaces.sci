function image_analysis()
    clear
    close
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    path_data = strcat([base_path,'/data/']);
    ext = '.pgm';
    nb = 3;
    learning(base_path,att_faces,path_data,ext,nb);
//    test(base_path,att_faces,path_data,strcat([base_path,att_faces,'/s37/8',ext]),nb,ext);
endfunction

function learning(base_path,att_faces,path_data,ext,nb)
    stacksize('max')
        
    [T,classes] = loadImages(strcat([base_path,att_faces]),nb,ext);
    [m,s] = prepareNormalization(T);
    T_second = normalization(T,m,s);
    eigenfaces = analysisPC(T_second);
    D = projection(T_second,eigenfaces);
    storeData(path_data,classes','classes');
    storeData(path_data,m,'m');
    storeData(path_data,s,'s');
    storeData(path_data,eigenfaces,'eigenfaces');
    storeData(path_data,D, 'D');
    
    //affichage
    m = resizeImg(m);
    s = resizeImg(s);
    e = resizeEigenfaces(eigenfaces)
    afficherImage([m s e]);
endfunction

function test(base_path,att_faces,path_data,img,nb,ext)
    d = 'double';
    str = 'string';
    image_test = chargerImage(img,0);
    image_test_v = transformIntoVector(image_test);
    m = loadData(path_data,'m',d);
    s = loadData(path_data,'s',d);
    eigenfaces = loadData(path_data,'eigenfaces',d);
    D = loadData(path_data,'D',d);
    classes = loadData(path_data, 'classes',str);
    image_test_n = normalization(image_test_v,m,s);
    image_test_p = projection(image_test_n,eigenfaces);
    class = decision(image_test_p,D,nb);
    disp("classe :");
    disp(classes(class));
    img_decision = chargerImage(strcat([base_path,att_faces,'/',classes(class),'/1',ext]),0);
    disp(size(img_decision));
    disp(size(image_test));
    afficherImage([img_decision image_test]);
    
endfunction

function [T,folders] = loadImages(base_path,nbImages,ext)
    folders = ls(base_path);
    folders_images = "";
    images = string(1);
    for i = 1 : size(folders,1)
        folders_images = strcat([base_path,'/',folders(i),'/']);
        for j = 1 : nbImages
            images = [images(1:$, :); strcat([folders_images,string(j),ext]);];
        end
    end
    //T Creation
    img = chargerImage(images(2),0);
    img = transformIntoVector(img);
    T = zeros(size(folders,1)*nbImages,size(img,2));
    //ISSUE 
    T(1,:) = img(1,:);
    for i = 2 : size(images,1)-1
        img = chargerImage(images(i+1),0);
        img = transformIntoVector(img);
        T(i,:) = img(1,:);
    end
endfunction

function [m,s] = prepareNormalization(T)
    m = mean(T,1);
    s = stdev(T,1);
endfunction

function [T_second] = normalization(T,m,s)   
    m1 = repmat(m, size(T,1),1);
    s1 = repmat(s, size(T,1), 1);
    T_second = T-m1;
    T_second = T_second ./ s1;
endfunction

function vector = transformIntoVector(m)
    m = imresize(m,0.5);
    vector = matrix(m,size(m,1)*size(m,2),1)';
endfunction

function eigenfaces = analysisPC(T_second)
    disp('EIGENFACES GENERATION');
    stacksize('max')
    cov_T_Second = cov(T_second);
    [u,s,v] = svd(cov_T_Second,0);
    eigenfaces = u(:,[1:1:48]);
    disp('GENERATION DONE');
endfunction

function D = projection(vec, eigenfaces)
    D = vec * eigenfaces;
endfunction

function class = decision(vector,D,nb)
    class = 0;
    D_img = repmat(vector, size(D,1),1);
    D_img = D_img - D;
    [D_img,c] = min(diag(D_img * D_img'));
    //finds index
    class = ceil(c/nb);
endfunction
















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

image_analysis();
