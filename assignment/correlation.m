%%%
% Corelation between 
% real and projected data. Calculated
% using the first level.
%%%
clc;
clearvars;
tic();

% IDs
load('air.mon.level1.mat');

n = size(time, 1); % # of timestemps
d = lonsz * latsz; % # of grid points
k = floor(d * 0.05); 

% Flatten data
X = reshape(data, d, n)';
Xm = repmat(mean(X),size(X,1),1);
Xc = X - Xm;

% Random matrix
R = rand(d, k);
R(R<1/6) = -sqrt(3);
R(R>5/6) = sqrt(3);
R((R>-sqrt(3)) & (R<sqrt(3))) = 0;

% Projection
P = Xc * R;
Pm = repmat(mean(P),size(P,1),1);

% PCA with real data
[c,s,l,~,e] = pca(X);

% PCA with prjected data
[cp,sp,lp,~,ep] = pca(P);

% Normalize components
s0 = s./repmat(std(s),size(s,1),1);
sp0 = sp./repmat(std(sp),size(sp,1),1);

% Draw components
N = 4;
for i=1:N
    subplot(N,1,i);
    plot(s0(:,i), 'b');
    hold on; 
    plot(sp0(:,i), 'r');
    hold off;

    cor = corr(s0(:,i), sp0(:,i));
    title(sprintf('Component %d, Correlation: %1.2f\n', i, cor));
end
