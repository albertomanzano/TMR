function [omega,Phi,X_dmd]=DMD(X,r,t)

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
[W,D]=eig(Atilde);
Phi=X2*Vr/Sr*W; % DMD modes

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