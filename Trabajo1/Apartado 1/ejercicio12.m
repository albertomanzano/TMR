clear all; close all; clc

A = imread('monet','jpg');
A1 = double(A(:,:,1));
A2 = double(A(:,:,2));
A3 = double(A(:,:,3));

B = imnoise(A,'gaussian',0.01);
B1 = double(B(:,:,1));
B2 = double(B(:,:,2));
B3 = double(B(:,:,3));

%%
% SVD en cada una de las imagenes
[U1,S1,V1] = svd(B1,'econ');
[U2,S2,V2] = svd(B2,'econ');
[U3,S3,V3] = svd(B3,'econ');
V1 = V1';
V2 = V2';
V3 = V3';

% Diagonales
diagonal = diag(S1);
subplot(1,3,1);
semilogy(1:size(S1),diagonal/norm(diagonal),'.'), grid

diagonal = diag(S2);
subplot(1,3,2);
semilogy(1:size(S2),diagonal/norm(diagonal),'.'), grid

diagonal = diag(S3);
subplot(1,3,3);
semilogy(1:size(S3),diagonal/norm(diagonal),'.'), grid


%%
n1 = 350; n2 = 350; n3 = 310; 
C1 = U1(:,1:n1)*S1(1:n1,1:n1)*V1(1:n1,:);
C2 = U2(:,1:n2)*S2(1:n2,1:n2)*V2(1:n2,:);
C3 = U3(:,1:n2)*S3(1:n2,1:n2)*V3(1:n2,:);

C(:,:,1) = C1;
C(:,:,2) = C2;
C(:,:,3) = C3;

figure(2)
C = uint8(C);
subplot(1,3,1), imshow(A), title('Original')
subplot(1,3,2), imshow(C), title('Reconstruida')
subplot(1,3,3), imshow(B), title('Corrupta')



figure(3)
colormap(hot)
bottom = min(min(min(abs(A1-B1))),min(min(abs(A1-C1))));
top  = max(max(max(abs(A1-B1))),max(max(abs(A1-C1))));
subplot(2,3,1), imagesc(abs(A1-B1)), colorbar, caxis([bottom top]), title('Imagen Corrupta')
subplot(2,3,4), imagesc(abs(A1-C1)), colorbar, caxis([bottom top]), title('Imagen Corregida')

bottom = min(min(min(abs(A2-B2))),min(min(abs(A2-C2))));
top  = max(max(max(abs(A2-B2))),max(max(abs(A2-C2))));
subplot(2,3,2), imagesc(abs(A2-B2)), colorbar, caxis([bottom top]), title('Imagen Corrupta')
subplot(2,3,5), imagesc(abs(A2-C2)), colorbar, caxis([bottom top]), title('Imagen Corregida')

bottom = min(min(min(abs(A3-B3))),min(min(abs(A3-C3))));
top  = max(max(max(abs(A3-B3))),max(max(abs(A3-C3))));
subplot(2,3,3), imagesc(abs(A3-B3)), colorbar, caxis([bottom top]), title('Imagen Corrupta')
subplot(2,3,6), imagesc(abs(A3-C3)), colorbar, caxis([bottom top]), title('Imagen Corregida')
%%

error_recons = mean(mean(mean(abs(A-C))))
error_noise = mean(mean(mean(abs(A-B))))
