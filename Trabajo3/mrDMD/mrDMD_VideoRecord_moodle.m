clear all, close all, clc
load A.mat
% Set a camera
cam=3
% B=double(squeeze(A(50:350,300:400,cam,:)));
B=double(squeeze(A(50:270,300:400,cam,:)));
[nx ny nt]=size(B);

%%
dt = 1;
t = [0:nt-1]*dt;
R = reshape(B,nx*ny,nt);
%% 
X=R;
dt=t(2)-t(1);
n=nx*ny;

%% take a look at the movie
% figure;
% for ti = 1:numel(t),
%     Pic = reshape(X(:, ti), nx, ny);
%     imagesc(Pic, range(X(:))/2*[-1 1]);
%     axis square; axis off;
%     pause(dt);
% end;

%% compute mrDMD
L = 7; % number of levels
r = 20; % rank of truncation

mrdmd = mrDMD(X, dt, r, 2, L);

% compile visualization of multi-res mode amplitudes
[map, low_f] = mrDMD_map(mrdmd);
[L, J] = size(mrdmd);

%%
figure; 
imagesc(-map); 
%set(gca, 'YTick', 0.5:(L+0.5), 'YTickLabel', floor(low_f*10)/10); 
%set(gca, 'XTick', J/T*(0:T) + 0.5);
%set(gca, 'XTickLabel', (get(gca, 'XTick')-0.5)/J*T);
%axis xy;
xlabel('Time (sec)');
ylabel('Freq. (Hz)');
colormap pink;
grid on;

pause

%% Plot DMD frequency vs GR at level kk
figure(200)
hold on
box on
for kk=1:L-1
plot(imag(mrdmd{kk,1}.omega),real(mrdmd{kk,1}.omega),'*'); 
pause
end

%% Plot DMD mode at level kk
for kk=1:L-1
figure;
imagesc(reshape(abs(mrdmd{kk,1}.Phi(1:n,1)), nx, ny));
axis square;
pause
end

