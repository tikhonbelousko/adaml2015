%%%
% The effect of Nth
% principle component is demonstrated
% in this file. Run it to see this 
% animation. Fot that perpose the first level
% is utilized.
%%%

clc;
clearvars;
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
N = 4;
IMAGES = cell(N,1);
TITLES = cell(N,1);

% Prepare for drawing
for i=1:N-1
    Xi = s(:,i) * c(:,i)';
    norm(Xi(:) - Xc(:));
    IMAGES{i} = reshape((Xi+Xm)', lonsz, latsz, n);
    TITLES{i} = sprintf('component #%d', i);
end
IMAGES{N} = data;
TITLES{N} = 'All components';

% Draw images
for i=1:n
    for j=1:N
        d = IMAGES{j};
        subplot(2,2,j);
        image(d(:,:,i)','CDataMapping','scaled'); 
        title(TITLES{j});
    end
    pause(0.04);
end

