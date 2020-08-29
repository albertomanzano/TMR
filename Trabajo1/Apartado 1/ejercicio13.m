    clear all; close all; clc

addpath('./tptool/array');
A = imread('monet','jpg');
A1 = A(:,:,1);
A2 = A(:,:,2);
A3 = A(:,:,3);


B = imnoise(A,'gaussian',0.001);
error_noise = mean(mean(mean(abs(A-B))));
B1 = B(:,:,1);
B2 = B(:,:,2);
B3 = B(:,:,3);
B= double(B);

[S,U,sv,tol] = hosvd(B);
%%
figure(1)
plot(sv{1,1},'ob')
hold on
plot(sv{1,2},'or')
set(gca,'yscale','log');
hold off
grid


%%
n = 20; %540 kandinsky

y = [];
x = [90,100,110,120,130,140,150,160,170,180,200];

for i=1:length(x)
    n = x(i);
    U1{1} = U{1}(:,1:n); 
    U1{2} = U{2}(:,1:n); 
    U1{3} = U{3};
    S1 = S(1:n,1:n,:);

    C = tprod(S1,U1);
    C = uint8(C);
    y(i) = mean(mean(mean(abs(A-C))));
end
scatter(x,y)
grid

%%

    n = x(find(y == min(y)));
    U1{1} = U{1}(:,1:n); 
    U1{2} = U{2}(:,1:n); 
    U1{3} = U{3};
    S1 = S(1:n,1:n,:);

    C = tprod(S1,U1);
    C = uint8(C);
    n
error_recons =  min(y)
error_noise
C1 = C(:,:,1);
C2 = C(:,:,2);
C3 = C(:,:,3);
%%
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

