clear all; close all; clc

A = imread('monet','jpg');
B = imnoise(A,'gaussian',0.01);

figure(1)
subplot(1,2,1), imshow(A)
subplot(1,2,2), imshow(B)
% Double porque está en integers!
% Normalizamos
A1 = double(rgb2gray(A));
B1 = double(rgb2gray(B));


%%

 figure(2)
 [U,S,V] = svd(B1,'econ');
 V = V';
 diagonal = diag(S);
 semilogy(1:size(S),diagonal/norm(diagonal),'.'), grid
 
%% 
y = [];
x = [70,80,90,95,100,110,120];

for i=1:length(x)
    n = x(i);
    C = U(:,1:n)*S(1:n,1:n)*V(1:n,:);
    y(i) = mean(mean(abs(A1-C)));
end
scatter(x,y)
grid
y(5)
error_noise = mean(mean(abs(A1-B1)))
error_recons = mean(mean(abs(A1-C)))


%%
figure(3)
subplot(1,3,1), pcolor(flipud(A1)), shading interp, colormap(gray), title('Original')
subplot(1,3,2), pcolor(flipud(C)), shading interp, colormap(gray), title('Corregida')
subplot(1,3,3), pcolor(flipud(B1)), shading interp, colormap(gray), title('Corrupta')
%%

error1 = abs(B1-A1);
error2 = abs(C-A1);
bottom = min(min(min(error1)),min(min(error2)));
top  = max(max(max(error1)),max(max(error2)));

figure(4)
subplot(1,2,1), imagesc(error1), colorbar, colormap(flipud(gray)), caxis([bottom top]), title('Imagen Corrupta')
subplot(1,2,2), imagesc(error2), colorbar, colormap(flipud(gray)), caxis([bottom top]), title('Imagen Corregida')


