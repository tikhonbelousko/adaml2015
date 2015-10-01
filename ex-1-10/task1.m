% For reproducibility
% rng default
clc
clear all

SAMPLES_COUNT = 500;

%%%
% Equal varience, no covarience
%%%

% data 1
mu = [10,10];
sigma = [5,0;0,5];
r = mvnrnd(mu,sigma,SAMPLES_COUNT);

% plot 1
ax = subplot(3,3,1);
plot(r(:,1), r(:,2),'r+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% mean and varience
ax = subplot(3,3,2);
r_mnv = mnv(r, sigma);
plot(r_mnv(:,1) ,r_mnv(:,2),'b+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% normalization
ax = subplot(3,3,3);
r_sm = softmax(r, sigma);
plot(r_sm(:,1) ,r_sm(:,2),'g+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);


%%%
% Inequal varience, no covarience
%%%

% data 2
mu = [10,10];
sigma = [1,0;0,5];
r = mvnrnd(mu,sigma,SAMPLES_COUNT);

% plot 2
ax = subplot(3,3,4);
plot(r(:,1), r(:,2),'r+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% mean and varience
ax = subplot(3,3,5);
r_mnv = mnv(r, sigma);
plot(r_mnv(:,1) ,r_mnv(:,2),'b+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% normalization
ax = subplot(3,3,6);
r_sm = softmax(r, sigma);
plot(r_sm(:,1) ,r_sm(:,2),'g+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

%%%
% Inequal varience, no covarience
%%%

% data 3
mu = [10,10];
sigma = [1,1.5;1.5,5];
r = mvnrnd(mu,sigma,SAMPLES_COUNT);

% plot 3
ax = subplot(3,3,7);
plot(r(:,1), r(:,2),'r+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% mean and varience
ax = subplot(3,3,8);
r_mnv = mnv(r, sigma);
plot(r_mnv(:,1) ,r_mnv(:,2),'b+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);

% normalization
ax = subplot(3,3,9);
r_sm = softmax(r, sigma);
plot(r_sm(:,1) ,r_sm(:,2),'g+');
xlim(ax, [-5, 20]);
ylim(ax, [-5, 20]);
