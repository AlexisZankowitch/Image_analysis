function image_analysis()
    clear
    close
    base_path = "/home/zank/git/Image_analysis";
    att_faces = "/att_faces";
    ext = '.pgm';
    nb = 5;
    learning(base_path,att_faces,ext,nb);
//    test(base_path,strcat([base_path,att_faces,'/s1/2',ext]),nb);
endfunction

function learning(base_path,att_faces,ext,nb)
    T = loadImages(strcat([base_path,att_faces]),nb,ext);
    [m,s] = prepareNormalization(T);
    T_second = normalization(T,m,s);
    eigenfaces = analysisPC(T_second);
    D = projection(T_second,eigenfaces);
    
    storeData(strcat([base_path,'/data']),m,'m');
    storeData(strcat([base_path,'/data']),s,'s');
    storeData(strcat([base_path,'/data']),eigenfaces,'eigenfaces');
    storeData(strcat([base_path,'/data']),D, 'D');
endfunction

function test(base_path,img,nb)
    image_test = chargerImage(img,0);
    afficherImage(image_test);
    image_test = transformIntoVector(image_test);
    m = loadData(strcat([base_path,'/data/']),'m');
    s = loadData(strcat([base_path,'/data/']),'s');
    eigenfaces = loadData(strcat([base_path,'/data/']),'eigenfaces');
    D = loadData(strcat([base_path,'/data/']),'D');
    image_test = normalization(image_test,m,s);
    image_test = projection(image_test,eigenfaces);
    class = decision(image_test,D,nb);
    disp(class);
endfunction

function T = loadImages(base_path,nbImages,ext)
    folders = ls(base_path);
    folders_images = "";
    images = string(1);
    for i = 1 : size(folders,1)
        folders_images = strcat([base_path,'/',folders(i),'/']);
        for j = 1 : nbImages
            images = [images(1:$, :); strcat([folders_images,string(j),ext]);];
        end
    end
//    T Creation
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
    //add test to check size
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
    vector = m(:)';
endfunction

function eigenfaces = analysisPC(T_second)
    disp('EIGENFACES GENERATION');
    stacksize('max')
    cov_T_Second = cov(T_second);
    [U,S,V] = svd(T_second,0);
    [eigVec, eigVal] = spec(cov_T_Second);
    eigenfaces = eigVec(:,[1:1:48]);
    //TODO ISSUE eigenfaces pas bon du tout http://www.pages.drexel.edu/~sis26/Eigencode.htm
    disp('GENERATION DONE');
endfunction

function D = projection(vec, eigenfaces)
    D = vec * eigenfaces;
endfunction

function class = decision(vector,D,nb)
    class = 0;
    for i =1 : size(D,1)
//        vector = [vector(1:$, :);D(i,:);]
//        n = norm(vector);
//        if i>1 & n < n_pre then
//            n_pre = n;
//            c = i;
//        else
//            n_pre = n;
//            c = i;
//        end
        if vector == D(i,:) then
            class = i;
        end
    end
    class = ceil(class/nb);
endfunction




//UTILITY FUNCTIONS

function storeData(path,data,name)
    mkdir(path);
    cd(path);
    csvWrite(data, name);
    cd('../');
endfunction

function data = loadData(path,name)
    cd(path);
    data = csvRead(name);
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

//Show image
function afficherImage(matrix_image)
    imshow(uint8(matrix_image));
endfunction

//Save image
function image = ecrireImage(matrix_image,nomFichier)
    image=imwrite(matrix_image,nomFichier);
endfunction

image_analysis();
