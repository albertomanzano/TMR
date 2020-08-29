%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% %% INPUT: %%
%%% d: parameter of DMD-d (higher order Koopman assumption)
%%% V: snapshot matrix
%%% Time: vector time
%%% varepsilon1: first tolerance (SVD)
%%% varepsilon: second tolerance (DMD-d modes)
%%% %% OUTPUT: %%
%%% Vreconst: reconstruction of the snapshot matrix V
%%% deltas: growht rate of DMD modes
%%% omegas: frequency of DMD modes(angular frequency)
%%% amplitude: amplitude of DMD modes
%%% modes: DMD modes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc
clear all
close all

load A2.mat
%A = vidFrames1_1;
% Set a camera
cam=3
B=double(squeeze(A(50:270,300:400,cam,:)));
% long: B=double(squeeze(A(50:350,300:400,cam,:)));
[nx ny nt]=size(B);

%% SET TIME
dt=1
t=[0:nt-1]*dt;

%%
% Data movie
% for i=1:nt
%     contourf(squeeze(B(:,:,i)))
%     pause(0.1)
% end

R = reshape(B,nx*ny,nt);

%%%%%%%%%%%%%%%%%%%%%% SAVE RESULTS IN FOLDER DMD_solution %%%%%%%%%%%%%%%
mkdir('DMD_solution')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Time=t;
%%% Input parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Number of snapshots: nsnap
nsnap=size(R,2)
V=R;
%% DMD-d
d=20;
% d=10, 1m2, RMSE=0.19/0.12-long
% d=15, 1m2, RMSE=0.22/0.13-long
% d=20, 1m2, RMSE=0.16/0.14-long
% d=25, 1m2, RMSE=0.17
% d=30, 1m2, RMSE=0.20
%
% d=15, 5m2, RMSE=0.25/0.19-long
% d=20, 5m2, RMSE=0.23/0.19-long
% d=25, 5m2, RMSE=0.20
% d=30, 5m2, RMSE=0.21
%
% d=20, 10m2, RMSE=0.20
% d=25, 10m2, RMSE=0.23
% d=30, 10m2, RMSE=0.25: ONLY DOMINANT, 2nd and 3d HARMONICS
%
% d=20, 15m2, RMSE=0.28: DOMINANT MODE
%% Tolerance DMD-d
varepsilon1=1e-2 %SVD
varepsilon=1e-2 %DMD 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[M N]=size(V)

if d>1
    [Vreconst,deltas,omegas,amplitude,DMDmode] =DMDd_SIADS(d,V,Time,varepsilon1,varepsilon);
else
    [Vreconst,deltas,omegas,amplitude,DMDmode] =DMD1_SIADS(V,Time,varepsilon1,varepsilon);
end 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% RMS Error %%%
NormV=norm(V(:),2);
diff=V-Vreconst;
RelativeerrorRMS=norm(diff(:),2)/NormV;
RelativeerrorRMS
%%% MAX Error %%%
RelativeerrorMax=norm(diff(:),Inf)/norm(V(:),Inf);
RelativeerrorMax

%% SAVE DATA
h=figure;
plot(omegas,deltas,'k+')
xlabel('\omega_n')
ylabel('\delta_n')
name1 = sprintf('./DMD_solution/OmegasDeltas_d%03i',d );
saveas(h,name1,'fig')

h2=figure;
semilogy(omegas,amplitude/max(amplitude),'k+')
xlabel('\omega_n')
ylabel('a_n')
name2 = sprintf('./DMD_solution/OmegasAmplitud_d%03i',d );
saveas(h2,name2,'fig')

%% SAVE FIGURE
Vreconst=real(Vreconst);
save ./DMD_solution/Vreconst.mat Vreconst
save ./DMD_solution/DMDmode.mat DMDmode
DeltasOmegasAmpl=[deltas' omegas' amplitude'];
save ./DMD_solution/DeltasOmegasAmpl.mat DeltasOmegasAmpl


%% COMPARE RECONSTRUCTION
%% Plot movie
for i=30:50
    snap=i;
    figure(10)
    subplot(1,2,1);
    contourf(real(reshape(V(:,snap),nx,ny)));
    shading interp;
    subplot(1,2,2);
    contourf(real(reshape(Vreconst(:,snap),nx,ny)));
    shading interp;
    pause(0.1)
end

%% Plot DMD modes
figure(1010)
subplot(1,4,1)
contourf(reshape(real(DMDmode(:,1)),nx,ny));
subplot(1,4,2)
contourf(reshape(real(DMDmode(:,3)),nx,ny));
subplot(1,4,3)
contourf(reshape(real(DMDmode(:,5)),nx,ny));
subplot(1,4,4)
contourf(reshape(real(DMDmode(:,7)),nx,ny));
%     figure(i+100)
%     contourf(reshape(imag(DMDmode(:,i)),nx,ny));



