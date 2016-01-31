clc;
clear all;
% addpath('./datan');

load('yeast.mat');

% [t, p, r]= pca(data);
[c,s,l] = pca(data);

% plot(r(1:6));
% plotbi(t,p,1,2,[],[],1:4,[],'o',1.3);

% [t, p, r]= pca(data);
% plotbi(t,p,1,2,[],[],1:4,[],'o',1.3);

