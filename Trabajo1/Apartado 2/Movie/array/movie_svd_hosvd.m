%==========================================================================
%   Script dedicado al analisis del error producido por la compresion de un
%   video por HOSVD
%==========================================================================

clearvars
close all
clc

%% Read movie

load('../video_orig.mat')
% Esta parte del codigo requiere usar la herramienta videoReader. 
% Ademas en linux no funciona, hace falta instalar algo extra.
%
% El archivo video_orig.mat contiene el tensor video_orig que se devuelve
% al final de esta seccion de codigo.
%{
vid = VideoReader('Movie.mp4');

vid.CurrentTime = 55;  % Segundo del video a partir del cual empezara a contar.

video_orig = zeros(1080,1920,384);
video_compri = zeros(1080,1920,384);

i1 = 1;
while hasFrame(vid)
   i1 = i1 + 1;
   frame = readFrame(vid);
   video_orig(:,:,i1) = rgb2gray(frame);    
end
%}
%==========================================================================
%                               HOSVD
%==========================================================================
video_orig = video_orig(1:30,1:30,:);

r1 = size(video_orig,1); r2 = size(video_orig,2); r3 = size(video_orig,3);
% Descomposicion hosvd
[S, U] = hosvd(video_orig);

%% Reconstrucción
% Modos escogidos para las dos primera dimensiones.
modos = [1,7,10,20,25];

% Numero de modos que se usara para reconstruir la dimension tiempo.
tiempo = 5;

% Almacenamiento errores
Err_matrix = zeros(length(modos),length(modos));
% Almacenamiento norma Frobenius
Medidas_matrix = zeros(length(modos),length(modos),tiempo);
% Almacenamiento norma error Frobenius
Medidas_matrix_diff = zeros(length(modos),length(modos),tiempo);
video_compri=zeros(r1,r2,r3);

for i1 = 1:length(modos)
    for i2 = 1:length(modos)
        q1=modos(i1); q2=modos(i2); q3=tiempo;

        U1{1} = U{1}(:,1:q1); 
        U1{2} = U{2}(:,1:q2); 
        U1{3} = U{3};
        S1 = S(1:q1,1:q2,:);

        video_compri = tprod(S1,U1);
        
        %% Errors
        % Norma diferencia
        e_mean = mean(mean(mean(abs(video_orig-video_compri))));
        % Error relativo
        error = e_mean / mean(mean(mean(video_orig)));
        % Almacenamiento del error relativo
        Err_matrix(i1,i2) = error;
        
        for j1 = 1:tiempo
            % Norma Frobenius orginal
            vid_fro = norm(video_orig(:,:,j1),'fro');
            % Norma Frobenius reconstruida
            vid_rec = norm(video_compri(:,:,j1),'fro');
            % Norma Frobenius diferencia
            vid_rec_diff = norm(video_compri(:,:,j1) - video_orig(:,:,j1),'fro');
    
            % Almacenamiento de norma de Frobenius 
            Medidas_matrix(i1,i2,j1) = vid_rec;
            % Almacenamiento de norma de Frobenius de la diferencia
            Medidas_matrix_diff(i1,i2,j1) = vid_rec_diff;
        end
    end
end

%% Resultados
imagesc(Err_matrix), colorbar
