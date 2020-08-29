clear all, clc
load A.mat

%A = vidFrames1_1;
% Set a camera
cam=3
B = double(A);
%B=double(squeeze(A(50:350,300:400,cam,:)));
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


%% Compute DMD
%%%%%% body of DMD %%%%%%%%%%
r=100;
%[omega,Phi,X_dmd]=DMD(R,r,t);
[omega,Phi,X_dmd,P]=DMDspectrum(R,r,t);

%% Order DMD modes and frequencies as function of P
dummy1=[omega P Phi'];
dummy2=sortrows(dummy1,-2);
omega=dummy2(:,1);
P=dummy2(:,2);
Phi=dummy2(:,3:end)';

%% DMD spectrum
figure(12)
f = abs(imag(omega)); % PLOT Freq vs. amplitude
stem(f, P, 'k');
xlim([-0.1 2]);
ylim([15000 322900])
axis square;

%% Plot movie
for i=1:50%size(X,2)-1
    snap=i
    figure(10)
    subplot(1,2,1);
    contourf(real(reshape(R(:,snap),nx,ny)));
    shading interp;
    subplot(1,2,2);
    contourf(real(reshape(X_dmd(:,snap),nx,ny)));
    shading interp;
    pause(0.1)
end

%% Plot DMD modes
figure(101)
subplot(1,4,1)
contourf(reshape(real(Phi(:,2)),nx,ny));
subplot(1,4,2)
contourf(reshape(real(Phi(:,4)),nx,ny));
subplot(1,4,3)
contourf(reshape(real(Phi(:,6)),nx,ny));
subplot(1,4,4)
contourf(reshape(real(Phi(:,8)),nx,ny));
%     figure(i+100)
%     contourf(reshape(imag(Phi(:,i)),nx,ny));




%%

dif=R-real(X_dmd);
RRMSE=norm(dif(:),2)/norm(R,2)
disp("Error de reconstruccion "),disp(RRMSE)