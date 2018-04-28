clear
clc

addpath(genpath('F:\University of Florida\first year 2\Biometric identification\HW\HW3\GallerySet'));
gallery_set = cell(100,1);
cg1 = cell(100,1);
for i = 1:100
    matFilename = sprintf('subject%d_img1.PGM',i);
    cg1{i,1} = imread(matFilename);
    gallery_set{i} = matFilename;
end

