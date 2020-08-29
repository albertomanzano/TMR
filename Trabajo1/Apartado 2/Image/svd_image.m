%==========================================================================
% Script dedicado al estudio del error de compresion por SVD y HOSVD
% Para poder cambiar de imagen utilar la herramiento para reemplazar
% palabras que tiene matlab. A continuacion se muestra la palabras que
% deben ser utilizadas para cambiar entre imagenes.
%   - Astr0naut
%   - Xeurat
%   - Kand1nsky
%   - Astr0naut
%==========================================================================

clearvars
clc
close all

% Lee imagen original
rgbImage = imread('./Astronaut/Astronaut.jpg');
rgbImage = double(rgbImage);
%figure(1)
%imshow(rgbImage)
%title('Imagen original')
%saveas(gcf, '/home/rodrigo/Documents/LaTeX/TMR/TMR_1/Figures/Astronaut/Imagen_original.png')

%% Descomposicion SVD
rgbImage_svd = double(rgbImage);

Image1 = rgbImage_svd(:,:,1); % Tensor correspondiente al color rojo
Image2 = rgbImage_svd(:,:,2); % Tensor correspondiente al color verde
Image3 = rgbImage_svd(:,:,3); % Tensor correspondiente al color negro

[u1,s1,v1] = svd(Image1); v1 = v1';
[u2,s2,v2] = svd(Image2); v2 = v2';
[u3,s3,v3] = svd(Image3); v3 = v3';

% Norma de Frobenius de la imagen original por colores
%imagen_orig = mean(mean(mean(double(rgbImage))));
imagen_orig_1 = norm(Image1,'fro');
imagen_orig_2 = norm(Image2,'fro');
imagen_orig_3 = norm(Image3,'fro');

% Distribucion de los valores singulares de cada descomposicon
figure(5)
subplot(1,3,1)
plot(diag(s1),'o-')
title('Valores singulares, Rojo')
subplot(1,3,2)
plot(diag(s2),'o-')
title('Valores singulares, Verde')
subplot(1,3,3)
plot(diag(s3),'o-')
title('Valores singulares, Negro')

% Carga de los distintos modos usados para la reconstruccion de la imagen
load ./Astronaut/Astronaut_modos.mat

% Matriz donde se almacenaran los errores
Err_arr_svd_1 = zeros(length(modos),1);
Err_arr_svd_2 = zeros(length(modos),1);
Err_arr_svd_3 = zeros(length(modos),1);

% Matriz donde se almacenaran las normas de Frobenius de cada
% reconstruccion
Medida_modos_svd_1 = zeros(length(modos),1);
Medida_modos_svd_2 = zeros(length(modos),1);
Medida_modos_svd_3 = zeros(length(modos),1);

% Rango de la precision
rango_compresion_1 = zeros(length(modos),1);
rango_compresion_2 = zeros(length(modos),1);
rango_compresion_3 = zeros(length(modos),1);

%==========================================================================
%   Compresion de los distintos canales
%==========================================================================
for i1 = 1:length(modos)
    % Reconstruccion del primer canal
    image1_rec = u1(:,1:modos(i1)) * s1(1:modos(i1),1:modos(i1)) * v1(1:modos(i1),:);
    % Norma de Frobenius del primer canal
    imagen_rec_svd_1 = norm(image1_rec,'fro');
    % Norma de la diferencia
    diff_1 = mean(mean(abs(image1_rec - Image1)));
    % Norma de Frobenius de la diferencia
    diff_1_fro = norm(image1_rec - Image1,'fro');
    % Error relativo
    err_rel_svd_1 = diff_1 / mean(mean(abs(Image1)));
    % Almacenamiento del error relativo
    Err_arr_svd_1(i1) = err_rel_svd_1;
    % Almacenamiento de la norma de frobenius
    Medida_modos_svd_1(i1) = imagen_rec_svd_1;
    % Almacenamiento del rango de compresion
    rango_compresion_1(i1) = length(diag(s1))/modos(i1);
end

for i2 = 1:length(modos)
    % Reconstruccion del segundo canal
    image2_rec = u2(:,1:modos(i2)) * s2(1:modos(i2),1:modos(i2)) * v2(1:modos(i2),:);
    % Norma de Frobenius del segundo canal
    imagen_rec_svd_2 = norm(image2_rec,'fro');
    % Norma de la diferencia
    diff_2 = mean(mean(abs(image2_rec - Image2)));
    % Norma de Frobenius de la diferencia
    diff_2_fro = norm(image2_rec - Image2,'fro');
    % Error relativo
    err_rel_svd_2 = diff_2 / mean(mean(abs(Image2)));
    % Almacenamiento del error relativo
    Err_arr_svd_2(i2) = err_rel_svd_2;
    % Almacenamiento de la norma de frobenius
    Medida_modos_svd_2(i2) = imagen_rec_svd_2;
    % Almacenamiento del rango de compresion
    rango_compresion_2(i2) = length(diag(s2))/modos(i2);
end

for i3 = 1:length(modos)
    % Reconstruccion del tercer canal
    image3_rec = u3(:,1:modos(i3)) * s3(1:modos(i3),1:modos(i3)) * v3(1:modos(i3),:);
    % Norma de Frobenius del tecer canal
    imagen_rec_svd_3 = norm(image3_rec,'fro');
    % Norma de la diferencia
    diff_3 = mean(mean(abs(image3_rec - Image3)));
    % Norma de Frobenius de la diferencia
    diff_3_fro = norm(image3_rec - Image3,'fro');
    % Error relativo
    err_rel_svd_3 = diff_3 / mean(mean(abs(Image3)));
    % Almacenamiento del error relativo
    Err_arr_svd_3(i3) = err_rel_svd_3;
    % Almacenamiento de la norma de frobenius
    Medida_modos_svd_3(i3) = imagen_rec_svd_3;
    % Almacenamiento del rango de compresion
    rango_compresion_3(i3) = length(diag(s3))/modos(i3);
end

figure(7)
subplot(3,1,1)
plot(0:length(modos)-1,Err_arr_svd_1,'o-')
xticks(0:length(modos)-1)
xticklabels({num2str(rango_compresion_1)})
xlabel('Rango de compresion')
ylabel('Error de reconstruccion')
title('Rojo')

subplot(3,1,2)
plot(0:length(modos)-1,Err_arr_svd_2,'o-')
xticks(0:length(modos)-1)
xticklabels({num2str(rango_compresion_2)})
xlabel('Rango de compresion')
ylabel('Error de reconstruccion')
title('Verde')

subplot(3,1,3)
plot(0:length(modos)-1,Err_arr_svd_3,'o-')
xticks(0:length(modos)-1)
xticklabels({num2str(rango_compresion_3)})
xlabel('Rango de compresion')
ylabel('Error de reconstruccion')
title('Negro')

disp(['Norma de Frobenius canal 1 original: ', num2str(imagen_orig_1)])
disp(['Norma de Frobenius canal 2 original: ', num2str(imagen_orig_2)])
disp(['Norma de Frobenius canal 3 original: ', num2str(imagen_orig_3)])

disp('===================================================================')
disp('Normas de Frobenius para cada canal y compresion')
Medidas = [Medida_modos_svd_1';Medida_modos_svd_2';Medida_modos_svd_3'];
T = array2table(Medidas);
T.Properties.VariableNames(1:length(modos)) = string(modos)

% Guardamos la tabla con las medidas
save ./Astronaut/Astronaut_tabla_medidas.mat T