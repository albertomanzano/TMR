clear all;

T = 1;  %final ime
delta_snaps = 0.01; %time-step for saving snaps
M = 128;  %number of mesh points for space discretization
epsilon = 0.1; %desired accuracy 
%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%
x = linspace(-10,10,M)';  %mesh points
% h = x(2)-x(1);
% u_initial = cos(pi/20*x).*exp(-0.04*(x+2).^2);%initial condition
% %u_initial = exp(-x.*x/2);
% t_interval = 0:delta_snaps:T;
% [~,SNAPS] = QuantumOscillator_NS(t_interval,u_initial,x,h,1e-8,1e-10);
SNAPS = [];
for i = 1:30
    funcion = 1/i*sin(pi*i*x/10);
   SNAPS = [SNAPS,funcion]; 
end



[Q,D,~] = svd(SNAPS,'econ');

for i = 1:size(Q,2)
    if D(i,i)<1e-4 break; end
end

D = D/norm(D,2);
D = D(1:i,1:i);
Q = Q(:,1:i);

save('./LF2.mat','D','Q')



