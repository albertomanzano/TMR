clear all;

T = 1;  %final ime
delta_snaps = 0.001; %time-step for saving snaps
M = 128;  %number of mesh points for space discretization
epsilon = 0.1; %desired accuracy 
%%%%%%%%%%%%%%%%%%%%%%
% Initialization
%%%%%%%%%%%%%%%%%%%%%%
x = linspace(-10,10,M)';  %mesh points
h = x(2)-x(1);
u_initial = (1+1i)/2*cos(pi/4*x).*exp(-0.02*(x-5).^2)+cos(pi/20*x).*exp(-0.04*(x+3).^2);
%u_initial = exp(-x.*x/2);
t_interval = 0:delta_snaps:T;

t_initial = cputime;
[~,SNAPS] = QuantumOscillator_NS(t_interval,u_initial,x,h,1e-8,1e-10);
t_final = cputime; t_total = t_final-t_initial;
%%
index = 1:M;
norma = [];
for i=1:M
    index2 = sort(datasample(index,i,'Replace',false));
    x2 = x(index2);
    SNAPS_2 = SNAPS(index2,:);
    [Q,r] = POD_reducido(SNAPS,SNAPS_2);

    norma = [norma,norm(norm(norm(abs(r-SNAPS))))];
end
semilogy(index,norma,'r.-')
grid
title("Error");



%%
paso = 1;
index = 1:paso:M;
x1 = x(index);
SNAPS_1 = SNAPS(index,:);
[Q1,r1] = POD_reducido(SNAPS,SNAPS_1);


index2 = sort(datasample(index,64,'Replace',false));
x2 = x(index2);
SNAPS_2 = SNAPS(index2,:);
[Q2,r2] = POD_reducido(SNAPS,SNAPS_2);

index3 = sort(datasample(index,32,'Replace',false));
x3 = x(index3);
SNAPS_3 = SNAPS(index3,:);
[Q3,r3] = POD_reducido(SNAPS,SNAPS_3);

norma_completo2 = norm(norm(norm(abs(r1-SNAPS))))
norma_completo2 = norm(norm(norm(abs(r2-SNAPS))))
norma_completo2 = norm(norm(norm(abs(r3-SNAPS))))

%%
figure()
modo = 4;
subplot(1,3,1)
plot(x1,real(Q1(:,modo)),'k')
hold on
plot(x,real(Q(:,modo)),'ro');
title("Todos")
grid
legend('reducido','completo')

subplot(1,3,2)
plot(x2,real(Q2(:,modo)),'k')
hold on
plot(x,real(Q(:,modo)),'ro');
title("Mitad")
grid
legend('reducido','completo')

subplot(1,3,3)
plot(x3,real(Q3(:,modo)),'k')
hold on
plot(x,real(Q(:,modo)),'ro');
title("Cuarto")
grid
legend('reducido','completo')
hold off

%%
n1 = 2;
n2 = 5;
n3 = 10;
[U,S,V] = svd(SNAPS,'econ');
V = V';
r1 = U(:,1:n1)*S(1:n1,1:n1)*V(1:n1,:);
r2 = U(:,1:n2)*S(1:n2,1:n2)*V(1:n2,:);
r3 = U(:,1:n3)*S(1:n3,1:n3)*V(1:n3,:);


figure()
subplot(1,3,1)
imagesc(abs(SNAPS-r1)), colorbar, title('Dos modos')
subplot(1,3,2)
imagesc(abs(SNAPS-r2)), colorbar, title('Cinco modos')
subplot(1,3,3)
imagesc(abs(SNAPS-r3)), colorbar, title('Diez modos')
