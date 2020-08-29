clc; clear all; close all;

%load snaps
myFolder = './databaseA/';
filePattern = fullfile(myFolder, '/*.png');
dirSnaps = dir(filePattern);

noise = 10
%initialize snaps storage
baseFileName = dirSnaps(1).name;
fullFileName = fullfile(myFolder, baseFileName);
fprintf(1, 'Now reading %s\n', fullFileName);

m_color = imread(fullFileName);
m_red = m_color(:,:,1);
s = size(m_red);

init_svd = zeros(s(1), s(2));
init_one = zeros(s(1), s(2),length(dirSnaps));
init_array = zeros(s(1), s(2),3,length(dirSnaps));
init_array_snaps = zeros(s(1)*s(2),length(dirSnaps));

snaps_r = init_one;
snaps_g = init_one;
snaps_b = init_one;

% Corruptos
snaps_r_cor = init_one;
snaps_g_cor = init_one;
snaps_b_cor = init_one;

% Reconstruidos
snaps_r_rec = init_one;
snaps_g_rec = init_one;
snaps_b_rec = init_one;

%% Pixeles corruptos

masks = init_one;

%% Transformacion columnas
snaps = init_array;
snaps_cor = init_array;
snaps_rec = init_array;

snaps_r_columns = init_array_snaps ;
snaps_g_columns = init_array_snaps ;
snaps_b_columns = init_array_snaps ;

snaps_r_columns_rec = init_array_snaps ;
snaps_g_columns_rec = init_array_snaps ;
snaps_b_columns_rec = init_array_snaps ;

masks_columns = init_array_snaps;

s_r_all = init_svd;
s_g_all = init_svd;
s_b_all = init_svd;

%% Add noise to each image
for k = 1:length(dirSnaps)
    baseFileName = dirSnaps(k).name;
    fullFileName = fullfile(myFolder, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    
    m_color = imread(fullFileName);
    
    m_red = m_color(:,:,1);
    snaps_r(:, :, k) = m_red;
    
    m_green = m_color(:,:,2);
    snaps_g(:, :, k) = m_green;
    
    m_blue = m_color(:,:,3);
    snaps_b(:, :, k) = m_blue;
    
    %SVD in each color average of snaps
    %red
    [u_r, s_r, v_r] = svd(double(m_red));
    vt_r = v_r';
    s_r_all = s_r_all + s_r./length(dirSnaps);
    
    %green
    [u_g, s_g, v_g] = svd(double(m_green));
    vt_g = v_g';
    s_g_all = s_g_all + s_r./length(dirSnaps);
    
    %blue
    [u_b, s_b, v_b] = svd(double(m_blue));
    vt_b = v_b';
    s_b_all = s_b_all + s_r./length(dirSnaps);   
    
    %assemble colors
    snaps(:, :, :, k) = (cat(3, m_red, m_green, m_blue));
    
    %create mask
    linearIndices = randperm(numel(m_red), round(numel(m_red)/noise));
    mask_index = size(m_red);
    mask   = zeros(mask_index(1),mask_index(2));
    mask(linearIndices) = 1;
    
    masks(:, :, k) = mask;
    masks_columns(:,k) = mask(:);
    
    %corrupt data
    m_red(linearIndices) = 255;
    m_green(linearIndices) = 255;
    m_blue(linearIndices) = 255;
    
    snaps_r_cor(:, :, k) = m_red;
    snaps_g_cor(:, :, k) = m_green;
    snaps_b_cor(:, :, k) = m_blue;
    
    snaps_cor(:, :, :, k) = (cat(3, m_red, m_green, m_blue));
    
    %prepare data for Everson Sirovicho
    snaps_r_columns(:,k) = m_red(:);
    snaps_g_columns(:,k) = m_green(:);
    snaps_b_columns(:,k) = m_blue(:);
end
%%
%Represent average modes svd

figure
%red
subplot(1,3,1)
title('Red')
hold on
for i=1:min(size(m_red))
    scatter(i,s_r(i,i),'r','filled')
end
set(gca,'Yscale','log');
hold off

%green
subplot(1,3,2)
title('Green')
hold on
for i=1:min(size(m_green))
    scatter(i,s_g(i,i),'r','filled')
end
set(gca,'Yscale','log');
hold off

%blue
subplot(1,3,3)
title('Blue')
hold on
for i=1:min(size(m_blue))
    scatter(i,s_b(i,i),'r','filled')
end
set(gca,'Yscale','log');
hold off


%%
%Apply Everson-Sirovich
nmodes = 3;
m_red_rec_columns = es_repairing(snaps_r_columns,masks_columns,nmodes,.1);
m_green_rec_columns = es_repairing(snaps_g_columns,masks_columns,nmodes,.1);
m_blue_rec_columns = es_repairing(snaps_b_columns,masks_columns,nmodes,.1);

%%
%assemble colors in one image
aux = 0;
for k = 1:length(dirSnaps)
    element = 1;
    aux = 0;
    for i = 1:s(2)
        for j = 1:s(1)
            snaps_r_rec(j,i,k) = m_red_rec_columns(element,k);
            snaps_g_rec(j,i,k) = m_green_rec_columns(element,k);
            snaps_b_rec(j,i,k) = m_blue_rec_columns(element,k);
            %             aux_r = snaps_r_rec(j,i,k)-snaps_r_cor(j, i, k);
            %             aux_g = snaps_g_rec(j,i,k)-snaps_g_cor(j, i, k);
            %             aux_b = snaps_b_rec(j,i,k)-snaps_b_cor(j, i, k);
            %             aux = aux_r+aux_g+aux_b;
            element = element+1;
        end
    end
    snaps_rec(:, :, :, k) = (cat(3, snaps_r_rec(:,:,k), snaps_g_rec(:,:,k), snaps_b_rec(:,:,k)));
end

%save data
foldername = 'repairedA';
for k=1:length(dirSnaps)
    filename = fullfile(foldername, sprintf('%d.jpg',k));
    imwrite(uint8(snaps_rec(:, :, :, k)), filename);
end
%%
%%Figures of results
for k=1:3
    figure
    subplot(1,3,1)
    
    imshow(uint8(snaps(:, :, :, k)))
    title('Original')
    drawnow;
    subplot(1,3,2)
    
    imshow(uint8(snaps_cor(:, :, :, k)))
    title('Píxeles alterados')
    drawnow;
    subplot(1,3,3)
    
    imshow(uint8(snaps_rec(:, :, :, k)))
    title('Reconstrucción')
    drawnow;
end
