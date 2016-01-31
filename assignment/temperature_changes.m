%%%
% Temperature changes of a single 
% point from the subset before and after
% filtering. Subset is extracted from level 1.
%%%
clc;
clearvars;
close all;
tic();

% Load data
load('air.mon.level1.mat');
n = size(time, 1); % # of timestemps
d = lonsz * latsz; % # of grid points
k = floor(d * 0.05); 

% Flatten data
X = reshape(data, d, n)';
Xm = repmat(mean(X),size(X,1),1);
Xc = X - Xm;

% PCA with real data
[c,s,l,~,e] = pca(X);
toc();

% Component to test
N = 1;
del = [140 146; 283 286; 138 148];

% Draw original changes
Xi = s(:,N) * c(:,N)';
datai = reshape((Xi+Xm)', lonsz, latsz, n);
point = datai(floor(lonsz/4), floor(latsz/4),:);
subplot(2,1,1);
plot(point(:));
title('Original temperature changes');

% Filter
sfft = fft(s(:,N));
sfft(del(N,1):del(N,2)) = 0;
sfft(n-del(N,2):n-del(N,1)) = 0;
si = ifft(sfft, 'symmetric');

% Draw filtered changes in a point
Xi = si * c(:,N)';
datai = reshape((Xi+Xm)', lonsz, latsz, n);
point = datai(floor(lonsz/4), floor(latsz/4),:);
subplot(2,1,2);
plot(point(:));
title('Temperature changes without seasonal changes');