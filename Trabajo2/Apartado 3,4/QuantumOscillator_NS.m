%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% Quantum armonic oscilator equation: integration of full problem %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [my_time,solution] = QuantumOscillator_NS(t_interval,u_initial,x,h,Rel_Tol,Abs_Tol)

cuadrado = x.*x;
h = x(2)-x(1);
% integration by "ode15s"
%%%
M = length(u_initial) + 1;

%S = eye(M-1) + diag(ones(1,M-2),1) + diag(ones(1,M-2),1).';     % Jacobian sparsity pattern

%%%
options = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol);

[my_time,solution] = ode15s(@FPDE,t_interval,u_initial,options,cuadrado,h);

solution = solution.';      % solution at different times by columns


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% right-hand side of the equation %%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function F_PDE = FPDE(t,u,cuadrado,h)

% Funciona mejor
% u(1) = 0;
% u(end) = 0;
% D = gradient(gradient(u,h),h);

% 
M = length(u) + 1;
D = ( -2*u + [u(2:M-1);0] + [0;u(1:M-2)] )*M^2;

F_PDE = 1i/2*(D-cuadrado.*u);













