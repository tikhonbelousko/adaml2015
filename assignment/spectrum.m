%%%
% Analysis of spectrum of the 
% first level.
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


% Draw spectrums of first N components
N = 3;
del = [140 146; 283 286; 142 148];

for i=1:N
    
    % FFT
    sfft = fft(s(:,i));
    sfft(del(i,1):del(i,2)) = 0;
    sfft(n-del(i,1):n-del(i,2)) = 0;

    subplot(3,N,1+N*(i-1));
    plot(s(:,i));
    title(sprintf('Component %d: spectrum',i));

    subplot(3,N,2+N*(i-1));
    plot(ifft(sfft, 'symmetric'));
    title(sprintf('Component %d: spectrum (remove peak)',i));

    subplot(3,N,3+N*(i-1));
    plot(imgaussfilt(ifft(sfft, 'symmetric'), 50));
    title(sprintf('Component %d: spectrum (remove peak + gaussian)',i));
    
end

