%% Activity using MPPCA denoising.
close all; clear; clc;

%% Load jpg image. Contains three matrices, corresponding to RGB components.
test_image = imread('smile.png');

%% Add noise with mean and std deviation 50 to each matrix associated with the image.
pd = makedist('normal', 'mu', 50, 'sigma', 50);
%pd = makedist('gamma', 'b', 50);
%pd = makedist('uniform', 'lower', -36.6, 'upper', 136.6);
noisy = double(test_image);
for i = 1:3
    noisy(:,:,i) = double(test_image(:,:,i)) + random(pd, size(test_image(:,:,i)));
end

%% Denoise matrices.
denoised = noisy;
for i = 1:3
    denoised(:,:,i) = denoise(noisy(:,:,i));
end

%% Display the original image, image with noise, and denoised image.
subplot(1,3,1);
imshow(test_image);
title('Original Image');
subplot(1,3,2);
imshow(uint8(noisy));
title('Noisy Image');
subplot(1,3,3);
imshow(uint8(denoised));
title('Image Denoised with MPPCA');

%% Plot spectra (signular values) of all three images.
figure;
subplot(3,3,1);
[~,S,~] = svd(double(test_image(:,:,1)));
plot(log(diag(S)));
title('Log Spectrum for Original Image (R)');
subplot(3,3,2);
[~,S,~] = svd(double(test_image(:,:,2)));
plot(log(diag(S)));
title('Log Spectrum for Original Image (G)');
subplot(3,3,3);
[~,S,~] = svd(double(test_image(:,:,3)));
plot(log(diag(S)));
title('Log Spectrum for Original Image (B)');

subplot(3,3,4);
[~,S,~] = svd(noisy(:,:,1));
plot(log(diag(S)));
title('Log Spectrum for Noisy Image (R)');
subplot(3,3,5);
[~,S,~] = svd(noisy(:,:,2));
plot(log(diag(S)));
title('Log Spectrum for Noisy Image (G)');
subplot(3,3,6);
[~,S,~] = svd(noisy(:,:,3));
plot(log(diag(S)));
title('Log Spectrum for Noisy Image (B)');

subplot(3,3,7);
[~,S,~] = svd(denoised(:,:,1));
plot(log(diag(S)));
title('Log Spectrum for MPPCA Denoised Image (R)');
subplot(3,3,8);
[~,S,~] = svd(denoised(:,:,2));
plot(log(diag(S)));
title('Log Spectrum for MPPCA Denoised Image (G)');
subplot(3,3,9);
[~,S,~] = svd(denoised(:,:,3));
plot(log(diag(S)));
title('Log Spectrum for MPPCA Denoised Image (B)');