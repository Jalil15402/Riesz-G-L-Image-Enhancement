function results = evaluate_texture_enhancement(original_img, enhanced_img, reference_img)
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
    
    fprintf('=== COMPREHENSIVE IMAGE ENHANCEMENT EVALUATION ===\n\n');
    
    %% SECTION A: PUBLICATION-STANDARD QUALITY METRICS
    fprintf('A. STANDARD QUALITY METRICS:\n');
    
    % 1. PSNR (Peak Signal-to-Noise Ratio)
    psnr_value = psnr(enhanced_img, reference_img);
    fprintf('   PSNR: %.2f dB\n', psnr_value);
    
    % 2. SSIM (Structural Similarity Index)
    ssim_value = ssim(enhanced_img, reference_img);
    fprintf('   SSIM: %.4f\n', ssim_value);
    
    % 3. MSE (Mean Square Error)
    mse_value = immse(enhanced_img, reference_img);
    fprintf('   MSE: %.6f\n', mse_value);
    
    % 4. RMSE (Root Mean Square Error)
    rmse_value = sqrt(mse_value);
    fprintf('   RMSE: %.6f\n', rmse_value);
    
    % 5. MAE (Mean Absolute Error)
    mae_value = mean(abs(enhanced_img(:) - reference_img(:)));
    fprintf('   MAE: %.6f\n', mae_value);
    
    % 6. SNR (Signal-to-Noise Ratio)
    signal_power = mean(reference_img(:).^2);
    if signal_power > 0
        snr_value = 10 * log10(signal_power / mse_value);
        fprintf('   SNR: %.2f dB\n', snr_value);
    else
        snr_value = NaN;
        fprintf('   SNR: N/A (zero signal power)\n');
    end
    
    fprintf('\n');
    
    %% SECTION B: CONTRAST AND INTENSITY ANALYSIS
    fprintf('B. CONTRAST & INTENSITY ANALYSIS:\n');    
    % Standard Deviation (Contrast measure)
    std_orig = std(original_img(:));
    std_enh = std(enhanced_img(:));
    contrast_improvement = (std_enh - std_orig) / std_orig * 100;
    
    fprintf('   Original Std Dev: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        std_orig, std_enh, contrast_improvement);
    %% SECTION C: EDGE PRESERVATION AND ENHANCEMENT
    fprintf('C. EDGE ANALYSIS:\n');  
    % Multiple edge detection methods
    edge_orig_sobel = edge(original_img, 'sobel');
    edge_enh_sobel = edge(enhanced_img, 'sobel');
    edge_orig_canny = edge(original_img, 'canny');
    edge_enh_canny = edge(enhanced_img, 'canny');
    
    % Edge strength comparison
    edge_strength_orig_sobel = sum(edge_orig_sobel(:));
    edge_strength_enh_sobel = sum(edge_enh_sobel(:));
    edge_improvement_sobel = (edge_strength_enh_sobel - edge_strength_orig_sobel) / edge_strength_orig_sobel * 100;
    
    edge_strength_orig_canny = sum(edge_orig_canny(:));
    edge_strength_enh_canny = sum(edge_enh_canny(:));
    edge_improvement_canny = (edge_strength_enh_canny - edge_strength_orig_canny) / edge_strength_orig_canny * 100;
    
    % Edge Preservation Index (EPI)
    [Gx_orig, Gy_orig] = gradient(original_img);
    [Gx_enh, Gy_enh] = gradient(enhanced_img);
    grad_orig = sqrt(Gx_orig.^2 + Gy_orig.^2);
    grad_enh = sqrt(Gx_enh.^2 + Gy_enh.^2);
    
    % Correlation between gradients
    grad_correlation = corrcoef(grad_orig(:), grad_enh(:));
    epi = grad_correlation(1,2);
    
    fprintf('   Sobel Edges - Original: %d | Enhanced: %d | Change: %.2f%%\n', ...
        edge_strength_orig_sobel, edge_strength_enh_sobel, edge_improvement_sobel);
    fprintf('   Canny Edges - Original: %d | Enhanced: %d | Change: %.2f%%\n', ...
        edge_strength_orig_canny, edge_strength_enh_canny, edge_improvement_canny);
    fprintf('   Edge Preservation Index (EPI): %.4f\n', epi);
    fprintf('\n');
    
    %% SECTION D: TEXTURE PROPERTIES (GLCM-based)
    fprintf('D. TEXTURE PROPERTIES (GLCM):\n');    
    % Convert to uint8 for GLCM
    img_orig_uint8 = uint8(original_img * 255);
    img_enh_uint8 = uint8(enhanced_img * 255);
    
    % Multiple offset directions for robust GLCM analysis
    offsets = [0 1; 1 0; 1 1; 1 -1];
    glcm_orig = graycomatrix(img_orig_uint8, 'Offset', offsets, 'Symmetric', true);
    glcm_enh = graycomatrix(img_enh_uint8, 'Offset', offsets, 'Symmetric', true);
    
    % Calculate GLCM properties
    stats_orig = graycoprops(glcm_orig, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    stats_enh = graycoprops(glcm_enh, {'Contrast', 'Correlation', 'Energy', 'Homogeneity'});
    
    % Average across all directions
    contrast_glcm_orig = mean(stats_orig.Contrast);
    contrast_glcm_enh = mean(stats_enh.Contrast);
    energy_orig = mean(stats_orig.Energy);
    energy_enh = mean(stats_enh.Energy);
    homogeneity_orig = mean(stats_orig.Homogeneity);
    homogeneity_enh = mean(stats_enh.Homogeneity);
    correlation_orig = mean(stats_orig.Correlation);
    correlation_enh = mean(stats_enh.Correlation);
    
    fprintf('   GLCM Contrast - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        contrast_glcm_orig, contrast_glcm_enh, (contrast_glcm_enh-contrast_glcm_orig)/contrast_glcm_orig*100);
    fprintf('   GLCM Energy - Original: %.6f | Enhanced: %.6f | Change: %.2f%%\n', ...
        energy_orig, energy_enh, (energy_enh-energy_orig)/energy_orig*100);
    fprintf('   GLCM Homogeneity - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        homogeneity_orig, homogeneity_enh, (homogeneity_enh-homogeneity_orig)/homogeneity_orig*100);
    fprintf('   GLCM Correlation - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        correlation_orig, correlation_enh, (correlation_enh-correlation_orig)/correlation_orig*100);
    fprintf('\n');
    
    %% SECTION E: LOCAL TEXTURE ANALYSIS
    fprintf('E. LOCAL TEXTURE ANALYSIS:\n');  
    % Local Standard Deviation (multiple window sizes)
    window_sizes = [3, 5, 7];
    for w = window_sizes
        h = ones(w,w)/(w^2);
        mu_orig = imfilter(original_img, h, 'replicate');
        mu_enh = imfilter(enhanced_img, h, 'replicate');
        
        local_std_orig = sqrt(imfilter(original_img.^2, h, 'replicate') - mu_orig.^2);
        local_std_enh = sqrt(imfilter(enhanced_img.^2, h, 'replicate') - mu_enh.^2);
        
        mean_local_std_orig = mean(local_std_orig(:));
        mean_local_std_enh = mean(local_std_enh(:));
        local_texture_change = (mean_local_std_enh - mean_local_std_orig) / mean_local_std_orig * 100;
        
        fprintf('   Local Std (%dx%d) - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
            w, w, mean_local_std_orig, mean_local_std_enh, local_texture_change);
    end
    
    % Local Binary Pattern (LBP) - simplified version
    lbp_orig = local_binary_pattern(original_img);
    lbp_enh = local_binary_pattern(enhanced_img);
    lbp_similarity = corrcoef(lbp_orig(:), lbp_enh(:));
    fprintf('   LBP Similarity: %.4f\n', lbp_similarity(1,2));
    fprintf('\n');
    
    %% SECTION F: GRADIENT AND SHARPNESS ANALYSIS
    fprintf('F. GRADIENT & SHARPNESS ANALYSIS:\n');
%     fprintf('==================================\n');
    
    mean_grad_orig = mean(grad_orig(:));
    mean_grad_enh = mean(grad_enh(:));
    gradient_change = (mean_grad_enh - mean_grad_orig) / mean_grad_orig * 100;
    
    % Brenner Gradient (sharpness measure)
    brenner_orig = brenner_gradient(original_img);
    brenner_enh = brenner_gradient(enhanced_img);
    brenner_change = (brenner_enh - brenner_orig) / brenner_orig * 100;
    
    % Laplacian Variance (another sharpness measure)
    laplacian_orig = laplacian_variance(original_img);
    laplacian_enh = laplacian_variance(enhanced_img);
    laplacian_change = (laplacian_enh - laplacian_orig) / laplacian_orig * 100;
    
    fprintf('   Mean Gradient - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        mean_grad_orig, mean_grad_enh, gradient_change);
    fprintf('   Brenner Gradient - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        brenner_orig, brenner_enh, brenner_change);
    fprintf('   Laplacian Variance - Original: %.4f | Enhanced: %.4f | Change: %.2f%%\n', ...
        laplacian_orig, laplacian_enh, laplacian_change);
    fprintf('\n');
    
    
    %% SECTION H: RESULTS STRUCTURE FOR FURTHER ANALYSIS
    results = struct();
    results.psnr = psnr_value;
    results.ssim = ssim_value;
    results.mse = mse_value;
    results.rmse = rmse_value;
    results.mae = mae_value;
    results.snr = snr_value;
    results.contrast_improvement = contrast_improvement;
    results.edge_preservation_index = epi;
    results.gradient_change = gradient_change;
    results.glcm_contrast_change = (contrast_glcm_enh-contrast_glcm_orig)/contrast_glcm_orig*100;
    results.glcm_energy_change = (energy_enh-energy_orig)/energy_orig*100;
    results.brenner_change = brenner_change;
    results.laplacian_change = laplacian_change;
    
end

%% HELPER FUNCTIONS
function lbp = local_binary_pattern(img)
    % Simplified Local Binary Pattern implementation
    [rows, cols] = size(img);
    lbp = zeros(rows-2, cols-2);
    
    for i = 2:rows-1
        for j = 2:cols-1
            center = img(i, j);
            pattern = 0;
            
            % 8-neighborhood
            neighbors = [img(i-1,j-1), img(i-1,j), img(i-1,j+1), ...
                        img(i,j+1), img(i+1,j+1), img(i+1,j), ...
                        img(i+1,j-1), img(i,j-1)];
            
            for k = 1:8
                if neighbors(k) >= center
                    pattern = pattern + 2^(k-1);
                end
            end
            lbp(i-1, j-1) = pattern;
        end
    end
end

function brenner = brenner_gradient(img)
    % Brenner gradient sharpness measure
    [Gx, ~] = gradient(img);
    brenner = mean(Gx(:).^2);
end

function lap_var = laplacian_variance(img)
    % Laplacian variance sharpness measure
    laplacian_kernel = [0 -1 0; -1 4 -1; 0 -1 0];
    laplacian = imfilter(img, laplacian_kernel, 'replicate');
    lap_var = var(laplacian(:));
end