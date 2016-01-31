%%%
% Animation of the filtered temperature map,
% where highest peaks were removed.
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

% Inverse
N = 3;
IMAGES = cell(N,1);
TITLES = cell(N,1);

% Prepare for drawing
del = [140 146; 283 286; 138 148];

for i=1:N
    sfft = fft(s(:,i));
    sfft(del(i,1):del(i,2)) = 0;
    sfft(n-del(i,2):n-del(i,1)) = 0;
    si = ifft(sfft, 'symmetric');
    
    Xi = si * c(:,i)';
    norm(Xi(:) - Xc(:));
    IMAGES{i} = reshape((Xi+Xm)', lonsz, latsz, n);
    TITLES{i} = sprintf('Component #%d: Filtered', i);
end

% Draw images
for i=1:n
    for j=1:N
        d = IMAGES{j};
        subplot(1,3,j);
        image(d(:,:,i)','CDataMapping','scaled'); 
        title(TITLES{j});
    end
    pause(0.04);
end

