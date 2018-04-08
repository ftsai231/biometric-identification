clc
close all

%addpath(genpath('F:\University of Florida\first year 2\Biometric identification\HW\HW5\iris-img\iris_img\gallery'));
addpath(genpath('F:\University of Florida\first year 2\Biometric identification\HW\HW5\iris-img\iris_img\gallery'));


for k = 1:100
    matFilename = sprintf('gallery_%d.tiff',k);
    I = imread(matFilename);
    h = ones(5,5)/25;
    I2 = imfilter(I,h);
    imwrite(I2,sprintf('filtered_gellery_%d.png',k));
end



