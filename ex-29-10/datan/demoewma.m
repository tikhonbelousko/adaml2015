clc
echo on
% keywords: demo
% In this demo we plot an original time series and an ewma-smoothed
% time series.
%
% Here is the original time series:
%
%
pause % press any key to continue ....
echo off
x=0:.2:2*pi;  nc = length(x);
y=sin(x) + randng(1,nc);
plot(x,y),
title( 'original time series ')
y=y';
pause
echo on
%
%
%
% Then we make 'ewma-smoothing' (with lambda = 0.5) and plot
% the smoothed time series and the original time series.
%
%
pause   % press any key to continue .....
echo off
z=ewma(y,0.5);

plot(x,y,'-',x,z,'--'),
title( 'original (-)/ smoothed (--) (lambda=0.5) ')
clc

