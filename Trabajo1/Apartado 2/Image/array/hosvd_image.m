clearvars
close all
clc

% Read in original RGB image.
imagen_orig = imread('../Monet/Monet.jpg');
%figure(1)
%imshow(rgbImage)
%title('Imagen original')
%saveas(gcf, '/home/rodrigo/Documents/LaTeX/TMR/TMR_1/Figures/Monet/Imagen_original.png')

%% Descomposicion HOSVD
% Recorte de la imagen original
imagen_recortada = imagen_orig(end-300:end,end-300:end,:);
imagen_recortada = double(imagen_recortada);

r1 = size(imagen_recortada,1);
r2 = size(imagen_recortada,2);
r3 = size(imagen_recortada,3);

% Descomposicion hosvd
[S, U] = hosvd(imagen_recortada);

sigma = S;
u_modos = U{1,1};
v_modos = U{1,2};
w_modos = U{1,3};

%% Reconstrucción HOSVD
modos = [10,30,60,80,100]; % Modos utilizados para la reconstruccion.
%modos = [10,30];

% Norma Frobenius imagen recortada
imagen_orig_recortada_1 = norm(imagen_recortada(:,:,1),'fro');
imagen_orig_recortada_2 = norm(imagen_recortada(:,:,2),'fro');
imagen_orig_recortada_3 = norm(imagen_recortada(:,:,3),'fro');

% Matriz donde se almacenaran los errores
Err_arr_hosvd = zeros(length(modos),length(modos));

% Matriz donde se almacenaran las normas de Frobenius de cada
% reconstruccion
Medida_modos_hosvd_1 = zeros(length(modos),length(modos));
Medida_modos_hosvd_2 = zeros(length(modos),length(modos));
Medida_modos_hosvd_3 = zeros(length(modos),length(modos));

%==========================================================================
%   Bucle que combina distintos modos en las dos dimensiones de la matriz
%==========================================================================
for i1 = 1:length(modos)
    disp(['modo dim 1 hosvd: ', num2str(i1)])
    for i2 = 1:length(modos)
            q1=modos(i1); q2=modos(i2); q3=3;

            image_recortada_recon=zeros(r1,r2,r3);

            U1{1} = U{1}(:,1:q1); 
            U1{2} = U{2}(:,1:q2); 
            U1{3} = U{3};
            S1 = S(1:q1,1:q2,:);
            
            image_recortada_recon = tprod(S1,U1);
               
            % Norma de Frobenius de la imagen reconstruida
            norm_imagen_recon_1 = norm(image_recortada_recon(:,:,1),'fro');
            norm_imagen_recon_2 = norm(image_recortada_recon(:,:,2),'fro');
            norm_imagen_recon_3 = norm(image_recortada_recon(:,:,3),'fro');
            
            % Norma de Frobenius de la diferencia
            diff = mean(mean(mean(abs(image_recortada_recon - imagen_recortada))));
            diff_1 = norm(image_recortada_recon(:,:,1) - imagen_recortada(:,:,1),'fro');
            diff_3 = norm(image_recortada_recon(:,:,2) - imagen_recortada(:,:,2),'fro');
            diff_2 = norm(image_recortada_recon(:,:,3) - imagen_recortada(:,:,3),'fro');
            
            % Error relativo de la reconstruccion local
            err_rel_hosvd = diff / mean(mean(mean(imagen_recortada)));
            
            % Almacenamiento de los errores y medidas obtenidos en esta
            % iteracion.
            Err_arr_hosvd(i1,i2) = err_rel_hosvd;
            Medida_modos_hosvd_1(i1,i2) = norm_imagen_recon_1;
            Medida_modos_hosvd_2(i1,i2) = norm_imagen_recon_2;
            Medida_modos_hosvd_3(i1,i2) = norm_imagen_recon_3;
    end
end

%%
% Guardamos las normas de Frobenius de 
Medida_modos_hosvd(:,:,1) = Medida_modos_hosvd_1;
Medida_modos_hosvd(:,:,2) = Medida_modos_hosvd_2;
Medida_modos_hosvd(:,:,3) = Medida_modos_hosvd_3;

%Representacion grafica de la matriz de errores
imagesc(Err_arr_hosvd)
colorbar
xticks(0:length(modos)-1)
yticks(0:length(modos)-1)
xticklabels(string(modos))
yticklabels(string(modos))

% Guardado de la representacion del error y las medidas
%saveas(gcf, '/home/rodrigo/Documents/LaTeX/TMR/TMR_1/Figures/Monet/Error_Truncamiento_HOSVD.png')
%save ../Monet/Monet_Medidas_modos_HOSVD.mat Medida_modos_hosvd

disp(['Norma Frobenius imagen original recortada canal 1: ', num2str(imagen_orig_recortada_1)])
disp(['Norma Frobenius imagen original recortada canal 2: ', num2str(imagen_orig_recortada_2)])
disp(['Norma Frobenius imagen original recortada canal 3: ', num2str(imagen_orig_recortada_3)])

% Representacion de la imagen recortada original
figure(3)
imshow(uint8(imagen_recortada));
title('Imagen original recortada')
%saveas(gcf, '/home/rodrigo/Documents/LaTeX/TMR/TMR_1/Figures/Monet/Imagen_original_recortada.png')

% Representacion de la imagen recortada reconstruida
figure(4)
imshow(uint8(image_recortada_recon));
title('Imagen recortada reconstruida por HOSVD')
%saveas(gcf, '/home/rodrigo/Documents/LaTeX/TMR/TMR_1/Figures/Monet/Imagen_recortada_reconstruida.png')
