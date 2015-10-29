  echo on
% keywords: demo
% In this demo we show some examples on how to plot log-normal
% distribution density functions.
%
% Take the values: x = 10..^(-3:.1:3), mu = log(100), sigma = 1 and
% x0 = 0.
%
%
% First compute the density values: ( y = denslogn(x,log(100),1,0) ).
echo off
x=10..^(-3:.1:3);
y=denslogn(x,log(100),1,0);
echo on
%
%
%
% then plot the values:
pause, clc % press any key to continue ...
echo off
plot(x,y),
title( ' log-normal distribution density function ')
pause;
echo on
%
%
%
% Next we plot the log-normal distribution with logarithmic scale
% on x axis - to see that really  log(x - x0) ~ N(mu,sigma)  - using
% Matlab's  'semilogx' function.
%
%
%
pause, clc % press any key to continue ...
echo off
semilogx(x,y)
clc
