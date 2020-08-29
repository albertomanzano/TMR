%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%% Ginzburg-Landau equation: basic ROM  %%%%%%%%%%%%% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all, close all
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters for the problem
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PARAMETERS FOR THE NC AND THE ROM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

T = 1;  %final ime
delta_snaps = 0.001; %time-step for saving snaps
M = 128;  %number of mesh points for space discretization
epsilon = 0.1; %desired accuracy 
epsilonPOD = epsilon; %tolerance for POD

%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%
x = linspace(-10,10,M)';  %mesh points
h = x(2)-x(1);
u_initial = (1+1i)/2*cos(pi/4*x).*exp(-0.02*(x-5).^2)+cos(pi/20*x).*exp(-0.04*(x+3).^2);%initial condition
%u_initial = exp(-x.*x/2);
t_interval = 0:delta_snaps:T;
t_completo = 0;
t_reducido = 0;
t_extra = 0;    

%%  Soluciones
uNS = [];
uROM = [];

% Intervalos temporales
intervalo = 0;
n_puntos = round(0.01*length(t_interval));
longitud_minima = round(0.01*length(t_interval));
puntos_extra = max(3,round(0.2*n_puntos));

% Guardamos modos
load('./LF.mat');
D = diag(D);
while(intervalo<length(t_interval))
    
    if (length(t_interval)-intervalo < n_puntos+5) 
        % Ajustamos el intervalo que queda
        NC_interval = t_interval(intervalo-3:end);
        % Añadimos la solución
        [~,SNAPS] = QuantumOscillator_NS(NC_interval,u_initial,x,h,1e-8,1e-10);
        uNS = [uNS,SNAPS(:,5:end)];
        uROM = [uROM,SNAPS(:,5:end)];
        break;
    end
    
    % Definimos intervalos de integracion
    T0_NC = intervalo+1;
    NC_interval = t_interval(T0_NC:intervalo+1+n_puntos);
    intervalo = intervalo+n_puntos+1;
    GS_interval = t_interval(intervalo+1:end);
    
    
    while (intervalo<length(t_interval))
        t_inicial = cputime;
        [~,SNAPS] = QuantumOscillator_NS(NC_interval,u_initial,x,h,1e-8,1e-10);
        t_final = cputime; t_completo=t_completo+(t_final-t_inicial);
        uNS = [uNS,SNAPS];
        uROM = [uROM,SNAPS];
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        % ROM solution
        %%%%%%%%%%%%%%%%%%%%%%%%%%

        %%% POD %%%
        [n,n1,n2,sv,modes] = POD(D,Q,uROM(:,T0_NC:end),epsilonPOD);

        %%% Galerkin system %%%
        GS_initial = SNAPS(:,end);
        t_inicial = cputime;
        [GS_time,A] = QuantumOscillator_GS(modes,GS_interval,GS_initial,n,n1,epsilon,x,1e-8,1e-10);
        t_final = cputime; t_reducido=t_reducido+(t_final-t_inicial);
        if (length(GS_time)>= longitud_minima | puntos_extra+2>length(t_interval)-intervalo) 
            break;
        else
            u_initial = GS_initial;
            NC_interval = t_interval(intervalo+1:intervalo+puntos_extra);
            intervalo = intervalo+puntos_extra;
            GS_interval = t_interval(intervalo+1:end);
        end

    
    end
    %%% Full system %%%
    t_inicial = cputime;
    if (length(GS_time)==2) 
        SNAPS = [modes(:,1:n)*A(1:n,1:end)];
    else
        [~,SNAPS] = QuantumOscillator_NS(GS_time,GS_initial,x,h,1e-8,1e-10);
    end
    t_final = cputime; t_extra=t_extra+(t_final-t_inicial);
    intervalo = intervalo+length(GS_time);
   
    %%% ROM solution in [T0,T0+GS_end] 
    uROM = [uROM,modes(:,1:n)*A(1:n,1:end)];
    [D,Q] = pesos(GS_time,modes,sv,A(1:n2,1:end),epsilon);
    n_puntos = round(0.01*length(t_interval));
    uNS = [uNS,SNAPS];
    u_initial = uROM(:,end);
    
end
%%
aceleracion = (t_completo+t_extra)/(t_completo+t_reducido)
aceleracion_teorica = (t_completo+t_extra)/t_completo
% [X,Y] = meshgrid(t_interval,x);
% surf(X,Y,real(uROM),'EdgeColor','none'


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Error computation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t_index = length(t_interval);
% Computed error in the GS interval
for k = 1 : t_index
    L2_error(k) = norm( uNS(:,k) - uROM(:,k) ) / norm( uNS(:,k) );
    L2_error(k) = max(L2_error(k),10^-6);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plots
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure(1)
h = subplot(3,1,1);
set(h,'FontSize',13);
hold on;
plot(t_interval,abs(uNS(round(M/4),:)),'g','linewidth',1);
plot(t_interval,abs(uNS(round(M/2),:)),'r','linewidth',1);
plot(t_interval,abs(uNS(round(3*M/4),:)),'b','linewidth',1);
xlim([0 T]);
%legend('|u(1/4,t)|','|u(1/2,t)|','|u(3/4,t)|','fontsize',10)
xlabel('t','fontsize',13);
ylabel('|q_{NC}|','fontsize',13);

h = subplot(3,1,2);
set(h,'FontSize',13);
hold on;
plot(t_interval,abs(uROM(round(M/4),:)),'g','linewidth',1);
plot(t_interval,abs(uROM(round(M/2),:)),'r','linewidth',1);
plot(t_interval,abs(uROM(round(3*M/4),:)),'b','linewidth',1);
xlim([0 T]);
%legend('|u(1/4,t)|','|u(1/2,t)|','|u(3/4,t)|','fontsize',10)
xlabel('t','fontsize',13);
ylabel('|q_{ROM}|','fontsize',13);

h = subplot(3,1,3);
hh=semilogy(t_interval,L2_error,'k',[0,T],[epsilon,epsilon],'c:');
set(hh,'Linewidth',1)
xlim([0 T]);
ylim([10^-6 10^1]);
yticks([10^-4 10^-2 10^0])
yticklabels({'10^{-4}','10^{-1}','10^{0}'})
xlabel('t','fontsize',13);
ylabel('error','fontsize',13);
set(h,'FontSize',13);


