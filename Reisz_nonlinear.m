clc
clear all
% parameters for cameraman image
A = imread('cameraman.tif');
AA = imresize(A, [180,180]);
img = im2double(AA);
h = 1;
a = 0.5;
b = 1;
alpha = 1.1;
beta = alpha;
D = .07;
dt = 0.1;
itteration = 10;

tic
%% Main Algorithem 
C = -1/(2*cos(pi*alpha/2));
Z = img;
% figure(1)
% imshow(img)
for i = 1:itteration
    img = Z;
    GWxL = grunwald_image_x_left(img,h,alpha);
    GWxR = grunwald_image_x_right(img,h,alpha);
    GWyL = grunwald_image_y_left(img,h,beta);
    GWyR = grunwald_image_y_right(img,h,beta);
    A = C * ( GWxL + GWxR );
    B = C * ( GWyL + GWyR );
    f = -b * img .* (img - a) .* (img - 1);
    Z = img + dt * (D * (A + B) + f);
%     figure(i+1)
%     imshow(Z)
end
toc

original_img = AA;
enhanced_img = Z;
reference_img = AA;
results = evaluate_texture_enhancement(original_img, enhanced_img, reference_img);

S = whos;
total_bytes = sum([S.bytes]);
total_kb = total_bytes / 1024;


