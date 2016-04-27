function image_analysis()
    algorithm();
endfunction

function algorithm()
    clear
    close
    base_path = "/home/zank/git/Image_analysis/att_faces";
    loadImages(base_path,5,'.pgm');
endfunction

function reshape_images()
    
endfunction

function T = loadImages(base_path,nbImages,ext)
    folders = ls(base_path);
    folders_images = "";
    images = string(1);
    for i = 1 : size(folders,1)
        folders_images = strcat([base_path,'/',folders(i),'/']);
        for j = 1 : nbImages
            images = [images(1:$, :); strcat([folders_images,string(j),ext]);]
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
        T(i,:) = m(1,:);
    end
    //add test to check size
endfunction

function T_second = normalization(T)
    m = mean(T,2);
    s = std(T,2);
    disp(size(m));
    disp(size(t));
endfunction

function vector = transformIntoVector(m)
    m = imresize(m,0.5);
    vector = m(:)';
endfunction

//transformer mat image en un vect
//eigenfaces sont les vecteurs propres des diagonalisation matrice 


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
