function results = evaluate_texture_enhancement_v3new(original_img, enhanced_img, reference_img)
    % Enhanced texture evaluation function with publication-standard metrics
    % Inputs:
    %   original_img - Original input image
    %   enhanced_img - Enhanced output image
    %   reference_img - Ground truth reference (optional, can be same as original)
    
    % Handle optional reference image
    if nargin < 3
        reference_img = original_img; % Use original as reference if no ground truth
    end
    
    % Convert to double if needed
    if ~isa(original_img, 'double')
        original_img = im2double(original_img);
    end
    if ~isa(enhanced_img, 'double')
        enhanced_img = im2double(enhanced_img);
    end
    if ~isa(reference_img, 'double')
        reference_img = im2double(reference_img);
    end
    

    % 1. PSNR (Peak Signal-to-Noise Ratio)
    psnr_value = psnr(enhanced_img, reference_img);
    
    % 2. SSIM (Structural Similarity Index)
    ssim_value = ssim(enhanced_img, reference_img);
    
    % 3. MSE (Mean Square Error)
    mse_value = immse(enhanced_img, reference_img);
    
    % 4. RMSE (Root Mean Square Error)
    rmse_value = sqrt(mse_value);
    
    % 5. MAE (Mean Absolute Error)
    mae_value = mean(abs(enhanced_img(:) - reference_img(:)));
    
    % 6. Standard Deviation (Contrast measure)
    std_enh = std(enhanced_img(:));
    
    %7. Multiple edge detection methods
    edge_orig_sobel = edge(original_img, 'sobel');
    edge_enh_sobel = edge(enhanced_img, 'sobel');
    edge_orig_canny = edge(original_img, 'canny');
    edge_enh_canny = edge(enhanced_img, 'canny');
    
    % Edge strength comparison
    edge_strength_orig_sobel = sum(edge_orig_sobel(:));
    edge_strength_enh_sobel = sum(edge_enh_sobel(:));
        
    edge_strength_orig_canny = sum(edge_orig_canny(:));
    edge_strength_enh_canny = sum(edge_enh_canny(:));
    
    
results=[psnr_value,ssim_value,std_enh,edge_strength_enh_sobel,edge_strength_enh_canny];

