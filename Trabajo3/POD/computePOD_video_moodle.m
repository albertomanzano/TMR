clear all, close all, clc
load A.mat

% Set a camera
cam=3
B=double(squeeze(A(50:350,300:400,cam,:)));
[nx ny nt]=size(B);

%% SET TIME
dt=1;
t=[0:nt-1]*dt;

%%
% Data movie
% for i=1:nt
%     contourf(squeeze(B(:,:,i)))
%     pause(0.1)
% end

R = reshape(B,nx*ny,nt);
%%
Y = R;


%% compute mean and subtract;
    Vavg = mean(Y,2);
contourf(reshape(Vavg,nx,ny));  % plot average wake

%% compute POD after subtracting mean (i.e., do PCA)
[PSI,S,V] = svd(Y-Vavg*ones(1,size(Y,2)),'econ');
    Vt = V';
% PSI are POD modes
figure
semilogy(diag(S)./sum(diag(S)),'o'); % plot singular vals

figure(110)
subplot(1,4,1)
contourf(reshape(PSI(:,1),nx,ny));
subplot(1,4,2)
contourf(reshape(PSI(:,2),nx,ny));
subplot(1,4,3)
contourf(reshape(PSI(:,3),nx,ny));
subplot(1,4,4)
contourf(reshape(PSI(:,4),nx,ny));


%% Reconstruction
Nmode=7; % Con cien modos
X_pod=PSI(:,1:Nmode)*S(1:Nmode,1:Nmode)*Vt(1:Nmode,:);

%ADD MEAN SUBSTRACTED ..> TEST WITHOUT MEAN
X_pod=X_pod+Vavg;


% figure(1001)
% for i=1:nt
% subplot(1,2,1)
% contourf(reshape(X_pod(:,i),nx,ny))
% subplot(1,2,2)
% contourf(squeeze(B(:,:,i)))
% pause(0.1)
% end

% RUN THE MOVIE TO SEE THE DIFFERENCES

%% Compute RRMSE reconstruction
for i=1:size(X_pod,2)
    Xreconst(:,:,i)=reshape(X_pod(:,i),nx,ny);
end
    
dif=Xreconst-B;
RRMSE=norm(dif(:),2)/norm(B(:),2)

