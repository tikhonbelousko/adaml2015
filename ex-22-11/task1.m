clc;
clear all;

% Load data
load data1.mat;
load data2.mat;
load data3.mat;
load data4.mat;

% Set parameters
class = class1;
data = data1;

% Use function
[testclass,t,whidden,woutput]=mlp(data,class,data);


% data1
plotmlp(10:0.5:28,10:0.5:28,whidden,woutput);
hold on;
plot(data(1, :), data(2, :), 'o', 'MarkerFaceColor', [0 0 0]);
hold off;

% data2
% plotmlp(0:0.1:5,0:0.1:5,whidden,woutput);
%%%
% Results
%%%

% For data1 exits with epoch max value
% For data2 wrong classes exits with max epoch value
% For data3 exits with epoch max value
% For data4 exits with epoch max value

