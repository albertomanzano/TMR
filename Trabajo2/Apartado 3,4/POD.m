
function [n,n1,n2,sv,modes] = POD(SNAPS,epsilon)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SNAPS = matrix whose columns are the considered snapshots
% epsilon = desired accuracy for the reconstruction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% n = number of retained POD modes
% sv = vector with the retained POD singular values
% modes = matrix whose columns are the retained POD modes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t_initial = cputime;

% applying SVD to the snapshot matrix
%%%
[U,mu,V] = svd(SNAPS,'econ');
%%%
mu = diag(mu);

% selecting the number of POD modes
%%%
NN = length(mu);
mu_aux = zeros(1,NN+1);
rms_sum = norm(mu,2);
n_aux1 = 0;
n_aux2 = 0;
n_aux3 = 0;
for k = 1 : NN
   mu_aux(k+1) = mu_aux(k) + mu(NN-k+1)^2;
   val = sqrt(mu_aux(k+1)) / rms_sum;
   if val < epsilon
      n_aux1 = n_aux1 + 1;
   end
   if val < epsilon/5
       n_aux2 = n_aux2+1;
   end
   if val < epsilon/10
       n_aux3 = n_aux3+1;
   end
end
%%%

n = max(1,NN-n_aux1);
n1 = max(1,NN-n_aux2);
n2 = max(1,NN-n_aux3);

if (n2 == n1) n2 = n2+1; end
n 
n1
n2
% POD singular values
%%%
sv = mu(1:n2);

% POD modes
%%%
modes = U(:,1:n2);

% computational cost
%%%
cost = cputime - t_initial;











