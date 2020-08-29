clear all;

T = 1;  %final ime
delta_snaps = 0.01; %time-step for saving snaps
M = 128;  %number of mesh points for space discretization
epsilon = 0.01; %desired accuracy 
%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%
x = linspace(-10,10,M)';  % Mesh Points
t_interval = 0:delta_snaps:T; % Time interval
h = x(2)-x(1); % Discretization

u_initial = (1+1i)/2*cos(pi/4*x).*exp(-0.02*(x-5).^2)+cos(pi/20*x).*exp(-0.04*(x+3).^2);
%u_initial = exp(-x.*x/2);

t_initial = cputime;
[~,SNAPS] = QuantumOscillator_NS(t_interval,u_initial,x,1e-8,1e-10);
t_final = cputime; t_total = t_final-t_initial;
t_final
%% Representacion

[X,Y] = meshgrid(t_interval,x);
h = surfl(X,Y,real(SNAPS))
set(h, 'edgecolor','none')

