
function faces = faceDetect(im)
    faces = detectfaces(im);
    [m,n] = size(faces);
    for i=1:m,
        im = rectangle(im, faces(i,:), [0,255,0]);
    end;
    imshow(im)
endfunction

