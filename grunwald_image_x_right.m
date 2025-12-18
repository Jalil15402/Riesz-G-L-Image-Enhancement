function GWxR = grunwald_image_x_right(img,h,alpha)

[M, N,C] = size(img);
w = zeros(1, max(M,N));

for k = 0:min(M,N)-1
    w(k+1) = (-1)^k * gamma(alpha+1) / (gamma(k+1) * gamma(alpha - k + 1));
end

D_frac = zeros(M, N,C);
for c = 1 : C
    for i = 1:M
        for j = 1:N
            X = 0;
            for k = 0:N-j
               X = X + w(k+1) * img(i, j+k,c);
            end
            
            D_frac(i, j,c) = X/(h^alpha);
        end
    end
end
GWxR = D_frac;% = mat2gray(D_frac);

end              