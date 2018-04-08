clc
close all

I = imread('gallery_1.tiff');
h = ones(100,100)/10000;
%h = ones(5,5)/25;
I2 = imfilter(I,h);
% figure
% imshow(I2)
% title('Filtered Image');
imwrite(I2,'myGray.png')
