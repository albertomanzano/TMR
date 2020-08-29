clc; clear; close all;

%Define scale number
scale = 20;

%read the photo and separate it in colors
m_color = imread('seurat.jpg');
m_red = m_color(:,:,1);
m_r = double(m_red);
m_green = m_color(:,:,2);
m_g = double(m_green);
m_blue = m_color(:,:,3);
m_b = double(m_blue);

% Kandinsky:
% num_rows = 500;
% num_columns = 500;
% pos_x = 1000;
% pos_y = 1500;

% Monet:
% num_rows = 300;
% num_columns = 300;
% pos_x = 500;
% pos_y = 50;
% 
%Seurat:
num_rows = 300;
num_columns = 300;
pos_x = 50;
pos_y = 50;



%crop a piece of the image to show pixelation
rect = [pos_x,pos_y,num_rows,num_columns];
m_r_crop = imcrop(m_r,rect);
m_g_crop = imcrop(m_g,rect);
m_b_crop = imcrop(m_b,rect);
m_crop = uint8(cat(3, m_r_crop, m_g_crop, m_b_crop));

%show original image
figure(1)
imshow(m_color);
hold on
rectangle('Position',rect,'Edgecolor', 'r','LineWidth',4);
hold off
%%
%reduce image to test the error of the method
m_r_redu = imresize(m_r_crop,1/scale);
m_g_redu = imresize(m_g_crop,1/scale);
m_b_redu = imresize(m_b_crop,1/scale);
m_redu = uint8(cat(3, m_r_redu, m_g_redu, m_b_redu));

%SVD in each color
%red
[u_r, s_r, v_r] = svd(m_r_crop);
vt_r = v_r';
%green
[u_g, s_g, v_g] = svd(m_g_crop);
vt_g = v_g';
%blue
[u_b, s_b, v_b] = svd(m_b_crop);
vt_b = v_b';

%SVD in each color for the test reduction
%red
[u_r_redu, s_r_redu, v_r_redu] = svd(m_r_redu);
vt_r_redu = v_r_redu';
%green
[u_g_redu, s_g_redu, v_g_redu] = svd(m_g_redu);
vt_g_redu = v_g_redu';
%blue
[u_b_redu, s_b_redu, v_b_redu] = svd(m_b_redu);
vt_b_redu = v_b_redu';

%Interpolation in SVD modes
%get dimensions
dims = size(u_r_redu);
row = scale*(1:size(u_r_redu,1));
row_0 = scale:row(end);
%resize u
u_r_new = interp1(row,u_r_redu,row_0);
u_g_new = interp1(row,u_g_redu,row_0);
u_b_new = interp1(row,u_b_redu,row_0);
%resize v
vt_r_new_aux = interp1(row,vt_r_redu',row_0);
vt_g_new_aux = interp1(row,vt_g_redu',row_0);
vt_b_new_aux = interp1(row,vt_b_redu',row_0);

vt_r_new = vt_r_new_aux';
vt_g_new = vt_g_new_aux';
vt_b_new = vt_b_new_aux';

%Reconstruction by interpolated SVD modes
crt = dims(1);
m_r_rec = u_r_new(:,1:crt)*s_r_redu(1:crt,1:crt)*vt_r_new(1:crt,:);
m_g_rec = u_g_new(:,1:crt)*s_g_redu(1:crt,1:crt)*vt_g_new(1:crt,:);
m_b_rec = u_b_new(:,1:crt)*s_b_redu(1:crt,1:crt)*vt_b_new(1:crt,:);

%SVD in each color for the amplification after reduction
%red
[u_r_rec, s_r_rec, v_r_rec] = svd(m_r_rec);
vt_r_rec = v_r_rec';
%green
[u_g_rec, s_g_rec, v_g_rec] = svd(m_g_rec);
vt_g_rec = v_g_rec';
%blue
[u_b_rec, s_b_rec, v_b_rec] = svd(m_b_rec);
vt_b_rec = v_b_rec';

%assemble RGB matrix and cast to image format
m_rec = uint8(cat(3, m_r_rec, m_g_rec, m_b_rec));
%show images
figure(2)
subplot(1,3,1)
imshow(m_crop);
title('Recorte original')
subplot(1,3,2)
imshow(m_rec);
title('Recorte reconstruido')
subplot(1,3,3)
imshow(m_redu);
title('Recorte pixelado')
%%
%show result of process
figure(3)
subplot(1,3,1)
imagesc(m_r_crop-m_r_rec)
colorbar
title('RED')
subplot(1,3,2)
imagesc(m_g_crop-m_g_rec)
colorbar
title('GREEN')
subplot(1,3,3)
imagesc(m_b_crop-m_b_rec)
colorbar
title('BLUE')
%%
%show error in modes normalized in each color
figure(4)
subplot(1,3,1)
title('Red')
norm1 = norm(s_r);
norm1_rec = norm(s_r_rec);
hold on
for i=1:min(size(m_r_crop));
    scatter(i,s_r(i,i)./norm1-s_r_rec(i,i)./norm1_rec,'r','filled')
end
set(gca,'Yscale','log');
hold off

subplot(1,3,2)
title('Green')
norm1 = norm(s_g);
norm1_rec = norm(s_g_rec);
hold on
for i=1:min(size(m_g_crop));
     scatter(i,s_g(i,i)/norm1-s_g_rec(i,i)/norm1_rec,'r','filled')
end
set(gca,'Yscale','log');
hold off

subplot(1,3,3)
title('Blue')
norm1 = norm(s_b);
norm1_rec = norm(s_b_rec);
hold on
for i=1:min(size(m_b_crop));
    scatter(i,s_b(i,i)/norm1-s_b_rec(i,i)/norm1_rec,'r','filled')
end
set(gca,'Yscale','log');
hold off




