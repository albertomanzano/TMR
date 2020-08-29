% Identify modes:
close all
% set level number
L=4

diary mrDMD_history.txt

err=0.01
freq=0.15/2/pi % 

for i=1:size(mrdmd,2)
    z=floor(i)
    A=mrdmd{L,z}.omega;
    pause(0.5)
    ind=find(imag(A)<(freq+err) & imag(A)>(freq-err));
    if isempty(ind)==0
        ini=i;
        break
    end
end


figure(100)
subplot(1,3,1)
contourf(reshape(real(mrdmd{L,ini}.Phi(1:n,ind)), nx, ny),'LineStyle','none');
subplot(1,3,2)
contourf(reshape(imag(mrdmd{L,ini}.Phi(1:n,ind)), nx, ny),'LineStyle','none');
subplot(1,3,3)
contourf(reshape(abs(mrdmd{L,ini}.Phi(1:n,ind)), nx, ny),'LineStyle','none');

diary off