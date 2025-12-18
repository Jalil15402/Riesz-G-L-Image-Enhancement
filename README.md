

# Fractional Riesz–Grünwald Diffusion Algorithms for Image Enhancement

This repository provides MATLAB implementations of four
fractional-order PDE-based image enhancement algorithms
based on Grünwald–Letnikov and Riesz fractional operators.

Each algorithm has been evaluated on five standard benchmark
images using image-specific parameter settings. These
parameter sets are provided below to ensure full reproducibility.

---

## Algorithms Included

1. **Linear Fractional Diffusion (GL)**
2. **Nonlinear Fractional Diffusion (GL)**
3. **Riesz Linear Fractional Diffusion**
4. **Riesz Nonlinear Fractional Diffusion**

---

## Files

- `linear_fractional_diffusion.m`
- `nonlinear_fractional_diffusion.m`
- `riesz_linear_fractional_diffusion.m`
- `riesz_nonlinear_fractional_diffusion.m`
- `evaluate_texture_enhancement.m`
- `evaluate_texture_enhancement_v3new.m`
- 'grunwald_image_x_left.m'
- 'grunwald_image_y_left.m'
- 'grunwald_image_x_right.m'
- 'grunwald_image_y_right.m'

---

## Test Images

The algorithms were tested on the following grayscale images:

- concordaerial
- Peppers
- Cameraman
- Baboon
- fabric

All images are taken from MATLAB’s built-in image database
(`toolbox/images/imdata`).
the commond use are,
imshow('concordaerial.png')
imshow('peppers.png')
imshow('cameraman.tif')
imshow('baboon.png')
imshow('fabric.png')
the images are converted to gray scale by 'rgb2gray'
---

## Parameter Settings

Each image requires a specific parameter set for optimal performance.
The following parameter values were used in the experiments.
common parameter
h = 1;a = 0.5;b = 1;alpha = 1.1;
beta = alpha;D = .07;dt = 0.1;itteration = 10;

each image will have,
1. baboon,
B = imread('baboon.png');
baboon = rgb2gray(B);
AA = imresize(baboon,[256,256]);
img = im2double(AA);

2. fabric
A = imread('fabric.png');
fabric = rgb2gray(A);
AA = imresize(fabric, [256 256]);
img = im2double(AA);

3.cameraman
A = imread('cameraman.tif');
AA = imresize(A, [180,180]);
img = im2double(AA);

4. peppers
A = imread('peppers.png');
pep = rgb2gray(A);
AA = imresize(pep, [200,200]);
img = im2double(AA);

5.concordaerial
A = imread('concordaerial.png');
con = rgb2gray(A);
AA = imresize(con, [500,500]);
img = im2double(AA);


---

## How to Run

1. Open MATLAB
2. Set the repository folder as the current directory
3. Open the desired algorithm `.m` file
4. Select an image and corresponding parameter set from above
5. Run the script

---

## Using New Images

For new images, we recommend:
- Starting with parameter values of **Cameraman** for smooth images
- Starting with **Baboon** parameters for highly textured images
- Adjust `alpha` and `D` gradually for best performance

---

## Runtime and Memory Measurement

- Runtime is measured using `tic` / `toc`
- Memory usage is measured using MATLAB `whos`

---

