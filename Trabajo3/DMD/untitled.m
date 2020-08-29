load A.mat

%% Plot movie
for i=1:50%size(X,2)-1
    snap=i
    figure(10)
    subplot(1,2,1);
    contourf(real(reshape(R(:,snap),nx,ny)));
    shading interp;
    subplot(1,2,2);
    contourf(real(reshape(X_dmd(:,snap),nx,ny)));
    shading interp;
    pause(0.1)
end
