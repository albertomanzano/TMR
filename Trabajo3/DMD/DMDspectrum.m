function [omega,Phi,X_dmd,P]=DMDspectrum(X,r,t)

%% DMD
X1=X(:,1:end-1);
X2=X(:,2:end);

% Reduce rank
% SVD rank
[U,S,V]=svd(X1,'econ');
Ur=U(:,1:r);
Sr=S(1:r,1:r);
Vr=V(:,1:r);

% Build Atilde and DMD modes
Atilde=Ur'*X2*Vr/Sr;

%% spectrum
% alternate scaling of DMD modes
Ahat = (Sr^(-1/2))*Atilde*(Sr^(1/2));
[What,D] = eig(Ahat);
W_r = Sr^(1/2)*What;
Phi = X2*Vr/Sr*W_r;

P = diag(Phi'*Phi);

%% PLOT RITZ spectrum

figure(1000)
theta = (0:1:100)*2*pi/100;
plot(cos(theta),sin(theta),'k--') % plot unit circle
hold on, grid on
scatter(real(diag(D)),imag(diag(D)),'ok')
axis([-1.1 1.1 -1.1 1.1]);

%%

% DMD spectra
dt=t(2)-t(1);
lambda=diag(D);
omega=log(lambda)/dt;

% Reconstruct the solution with DMD
X1=X(:,1); % Initial condition
b=Phi\X1; % This is an inverse regression.
%But we can solve and optimization problem to obtain b: Optimized DMD
time_dynamics=zeros(r,length(t));
for iter=1:length(t)
    time_dynamics(:,iter)=(b.*exp(omega*t(iter)));
end
X_dmd=Phi*time_dynamics;

