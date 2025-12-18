clc
clear all
% parameters for fabric image
cam = imread('cameraman.tif');
AA = imresize(cam, [180,180]);
img = im2double(AA);
h = 1;
a = 0.5;
b = 1;
alpha = 1.1;
beta = alpha;
D = .07;
dt = 0.1;
itteration = 10;

%% Main Algorithem 

alphav = 1.1:0.1:1.2;
for ii=1:length(alphav)
beta = alphav(ii);
alpha = alphav(ii);
C = -1/(2*cos(pi*alpha/2));
imgSL = img; imgSN = img;
imgRL = img; imgRN = img;
% figure(1)
% imshow(img)
for i = 1:itteration
    img1 = imgSL; img2 = imgSN; img3 = imgRL; img4 = imgRN;
    GWxL1 = grunwald_image_x_left(img1,h,alpha);
    GWyL1 = grunwald_image_y_left(img1,h,beta);
    
    GWxL2 = grunwald_image_x_left(img2,h,alpha);
    GWyL2 = grunwald_image_y_left(img2,h,beta);
    
    GWxL3 = grunwald_image_x_left(img3,h,alpha);
    GWyL3 = grunwald_image_y_left(img3,h,beta);
    GWxR3 = grunwald_image_x_right(img3,h,alpha);
    GWyR3 = grunwald_image_y_right(img3,h,beta);
    
    GWxL4 = grunwald_image_x_left(img4,h,alpha);
    GWyL4 = grunwald_image_y_left(img4,h,beta);
    GWxR4 = grunwald_image_x_right(img4,h,alpha);
    GWyR4 = grunwald_image_y_right(img4,h,beta);
    
    
    A =  ( GWxL1 + GWyL1 );
    B =  ( GWxL2 + GWyL2 );
    f = -b * img2 .* (img2 - a) .* (img2 - 1);
    
    aa = C * ( GWxL3 + GWxR3 );
    bb = C * ( GWyL3 + GWyR3 );
    
    cc = C * ( GWxL4 + GWxR4 );
    dd = C * ( GWyL4 + GWyR4 );
    ff = -b * img4 .* (img4 - a) .* (img4 - 1);
    
    imgSL = img1 + dt * D * (A);
    imgSN = img2 + dt * (D * (B) + f);  
    imgRL = img3 + dt * (D * ( aa + bb ));
    imgRN  = img4 + dt * (D * (cc + dd) + ff);

end


original_img = img;
enhanced_img1 = imgSL;
enhanced_img2 = imgSN;
enhanced_img3 = imgRL;
enhanced_img4 = imgRN;
reference_img = img;
camSL(ii,:) = evaluate_texture_enhancement_v3new(original_img, enhanced_img1, reference_img);
camSN(ii,:) = evaluate_texture_enhancement_v3new(original_img, enhanced_img2, reference_img);
camRL(ii,:) = evaluate_texture_enhancement_v3new(original_img, enhanced_img3, reference_img);
camRN(ii,:) = evaluate_texture_enhancement_v3new(original_img, enhanced_img4, reference_img);

end


figure (1)
subplot(1,2,1)
plot(alphav,camSL(:,3))
hold on
plot(alphav,camSN(:,3))
plot(alphav,camRL(:,3))
plot(alphav,camRN(:,3))

subplot(1,2,2)
plot(alphav,camSL(:,4))
hold on
plot(alphav,camSN(:,4))
plot(alphav,camRL(:,4))
plot(alphav,camRN(:,4))



figure (2)
subplot(1,2,1)
plot(alphav,camSL(:,1))
hold on
plot(alphav,camSN(:,1))
plot(alphav,camRL(:,1))
plot(alphav,camRN(:,1))

subplot(1,2,2)
plot(alphav,camSL(:,2))
hold on
plot(alphav,camSN(:,2))
plot(alphav,camRL(:,2))
plot(alphav,camRN(:,2))
