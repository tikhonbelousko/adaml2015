clc;
clear all;
addpath('./datan');

load('yeast.mat');

[t, p, r]= pca(data);

% plot(r(1:6));

% plotbi(t,p,1,2,[],[],1:4,[],'o',1.3);

[t, p, r]= pca(data(:,1:4));
plotbi(t,p,1,2,[],[],1:4,[],'o',1.3);

