%% Image/matrix denoising using Marchenko-Pastur distribution.
function clean = denoise(image)
    % initialize number of significant eigenvalues to 1
    p = 1;
    
    % center and shape
    [m, n] = size(image);
    flipped = 0;
    if m < n
        image = image';
        [m, n] = size(image);
        flipped = 1;
    end
    temp = mean(image, 2);
    image = image - temp;
    
    % compute SVD
    [U, S, V] = svd(image, 'econ');
    
    % compute MP parameters
    lambda_min = S(n, n)^2/n;
    lambda_max = S(p + 1, p + 1)^2/n;
    cutoff = 0.25*sqrt(n*(n - p))*(lambda_max - lambda_min);
    
    % estimate p
    while trace(S(p + 1:n, p + 1:n).^2)/n < cutoff
        p = p + 1;
        lambda_max = S(p + 1, p + 1)^2/n;
        cutoff = 0.25*sqrt(n*(n - p))*(lambda_max - lambda_min);
    end
    
    % output result
    disp(p);
    S(p + 1:n, p + 1:n) = zeros(n - p, n - p);
    if flipped
        clean = (U*S*V' + temp)';
    else
        clean = U*S*V' + temp;
    end
end