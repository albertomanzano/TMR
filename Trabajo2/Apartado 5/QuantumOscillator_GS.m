%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%% Ginzburg-Landau equation: integration of Galerkin system %%%%%%% 
%%%%%%%%%%              error is controlled by Enn1                 %%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [my_time,A] = QuantumOscillator_GS(Q,t_interval,u_initial,n,n1,epsilon,x,Rel_Tol,Abs_Tol)

M = length(u_initial) + 1;
n2 = size(Q,2);

% Sistema con n1 modos
A_initial_1 = Q(:,1:n1)'*u_initial;
D2V_1 = ( -2*Q(:,1:n1) + [Q(2:M-1,1:n1);zeros(1,n1)] + [zeros(1,n1);Q(1:M-2,1:n1)] )*M^2;
L_Galerkin_1 = 1i/2*(Q(:,1:n1)'*D2V_1-Q(:,1:n1)'*(x.*x.*Q(:,1:n1)));

% Sistema con n2 modos
A_initial_2 = Q'*u_initial;
D2V_2 = ( -2*Q + [Q(2:M-1,:);zeros(1,n2)] + [zeros(1,n2);Q(1:M-2,:)] )*M^2;
L_Galerkin_2 = 1i/2*(Q'*D2V_2-Q'*(x.*x.*Q));

% Sistema completo
A_initial = [A_initial_1;A_initial_2];
L_Galerkin = [L_Galerkin_1 zeros(n1,n2);zeros(n2,n1) L_Galerkin_2];

options = odeset('RelTol',Rel_Tol,'AbsTol',Abs_Tol,'Events',@ErrorControl,'vectorized','on');


%%%
[my_time,A] = ode15s(@FGalerkin,t_interval,A_initial,options,Q,L_Galerkin,n,n1,n2,epsilon);
A = A.';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTROLERROR (para ode15s)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [value,terminar,direccion]=ErrorControl(t,b,Q,L_Galerkin,n,n1,n2,epsilon)
Enn1=norm(b(n+1:n1,1),2)/norm(b(1:n1,1),2);
En1n2=norm(b(n1+n1+1:n1+n2,1),2)/norm(b(n1+1:n1+n2,1),2);
aux=[b(n1+1:n1+n,1)-b(1:n,1); b(n1+n+1:n1+n2,1)];
enn2=norm(aux,2)/norm(b(n1+1:n1+n2,1),2);


value=[Enn1-epsilon;En1n2-epsilon/10;abs(enn2-Enn1)-epsilon/100];
terminar=[1;1;1];
direccion=[1;1;1];




%%%%%%%%%%%%%%%%%%%%%
%%%%% FGalerkin %%%%%
%%%%%%%%%%%%%%%%%%%%%  

function FGalerkin = FGalerkin(t,b,Q,L_Galerkin,n,n1,n2,epsilon)
%%%
FGalerkin = L_Galerkin*b;


















