function [Q_few,r2] = POD_reducido(SNAPS,SNAPS_few)

n = size(SNAPS_few,1);
[Q_few,S_few,V2] = svd(SNAPS_few,'econ');
Q_all = SNAPS*V2*diag(diag(1./S_few));
V2 = V2';
r2 = Q_all(:,1:n)*S_few(1:n,1:n)*V2(1:n,:);
end

