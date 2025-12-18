function GWyR = grunwald_image_y_right(img,h,beta)

[M, N,C] = size(img);
w = zeros(1, max(M,N)+1);

for k = 0:min(M,N)-1
    w(k+1) = (-1)^k * gamma(beta+1) / (gamma(k+1) * gamma(beta - k + 1));
end

D_frac = zeros(M, N,C);
for c = 1 : C
    for j = 1:N
        for i = 1:M
            Y = 0;
            for k = 0:M-i
               Y = Y + w(k+1) * img(i+k,j,c);
            end
            D_frac(i, j,c) = Y/(h^beta);
        end
    end
end
GWyR = D_frac;% = mat2gray(D_frac);

end              