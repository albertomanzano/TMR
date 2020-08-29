clc
clear all
close all

load ./DMD_solution_d10/DeltasOmegasAmpl.mat 
D1=DeltasOmegasAmpl;
load ./DMD_solution_d15/DeltasOmegasAmpl.mat 
D2=DeltasOmegasAmpl;
load ./DMD_solution_d20/DeltasOmegasAmpl.mat 
D3=DeltasOmegasAmpl;
load ./DMD_solution_d25/DeltasOmegasAmpl.mat 
D4=DeltasOmegasAmpl;

figure1 = figure;
axes1 = axes('Parent',figure1);
hold(axes1,'on');
box on

semilogy(D1(:,2),D1(:,3)/max(D1(:,3)),'k+')
semilogy(D2(:,2),D2(:,3)/max(D2(:,3)),'bx')
semilogy(D3(:,2),D3(:,3)/max(D3(:,3)),'ro')
semilogy(D4(:,2),D4(:,3)/max(D4(:,3)),'g*')

% Podemos normalizarlo o no normalizarlo
% semilogy(D1(:,2),D1(:,3));
% semilogy(D2(:,2),D2(:,3));
% semilogy(D3(:,2),D3(:,3));
% semilogy(D4(:,2),D4(:,3));
xlabel('\omega_n')
ylabel('a_n')

set(axes1,'YMinorTick','on','YScale','log');