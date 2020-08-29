clc
clear all
close all

load ./DMD_solution_d20_10m2/DeltasOmegasAmpl.mat 
D1=DeltasOmegasAmpl;
load ./DMD_solution_d25_10m2/DeltasOmegasAmpl.mat 
D2=DeltasOmegasAmpl;
load ./DMD_solution_d30_10m2/DeltasOmegasAmpl.mat 
D22=DeltasOmegasAmpl;
load ./DMD_solution_d20_5m2/DeltasOmegasAmpl.mat 
D3=DeltasOmegasAmpl;
load ./DMD_solution_d25_5m2/DeltasOmegasAmpl.mat 
D4=DeltasOmegasAmpl;
load ./DMD_solution_d30_5m2/DeltasOmegasAmpl.mat 
D44=DeltasOmegasAmpl;

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
box on

semilogy(D1(:,2),D1(:,3)/max(D1(:,3)),'k+')
semilogy(D2(:,2),D2(:,3)/max(D2(:,3)),'kx')
semilogy(D22(:,2),D22(:,3)/max(D22(:,3)),'k*')
semilogy(D3(:,2),D3(:,3)/max(D3(:,3)),'bo')
semilogy(D4(:,2),D4(:,3)/max(D4(:,3)),'bs')
semilogy(D44(:,2),D44(:,3)/max(D44(:,3)),'b^')

% semilogy(D1(:,2),D1(:,3),'k+')
% semilogy(D2(:,2),D2(:,3),'kx')
% semilogy(D22(:,2),D22(:,3),'k*')
% semilogy(D3(:,2),D3(:,3),'bo')
% semilogy(D4(:,2),D4(:,3),'bs')
% semilogy(D44(:,2),D44(:,3),'b^')
xlabel('\omega_n')
ylabel('a_n')
xlim([-0.01 2])
%ylim([1e-2 1.5])

set(axes1,'YMinorTick','on','YScale','log');