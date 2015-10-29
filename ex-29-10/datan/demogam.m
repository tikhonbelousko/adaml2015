clc
echo on
clc
%keywords: demo
%
%
% In this demo we first plot gamma-distribution density function
% with different alfa-values: x = 0:0.1:100, alfa = 10:1:14, beta = 4
% (x0 = 0).
%
%
% Compute the values: ( y = densgamm(x,alfa,4,0) ).
% wait ...
echo off

x=0:0.1:100;

y0=densgamm(x,10,4,0);
y1=densgamm(x,11,4,0);
y2=densgamm(x,12,4,0);
y3=densgamm(x,13,4,0);
y4=densgamm(x,14,4,0);


echo on
%
%
%
% then plot the values:
pause, clc % press any key to continue ...
echo off
clc
plot(x,y0,x,y1,x,y2,x,y3,x,y4),

title('gamma-distribution density function')
xlabel(' alfa = 10:1:14, beta = 4, x0 = 0 ')

pause, echo on
%
%
% Then we plot density function with different
% beta-values (alfa = 10, beta = 3.0:0.5:5.0 (x0 = 0)).
% wait ....
echo off

y0=densgamm(x,10,3,0);
y1=densgamm(x,10,3.5,0);
y2=densgamm(x,10,4,0);
y3=densgamm(x,10,4.5,0);
y4=densgamm(x,10,5,0);
echo on
%
%
%
pause, clc % press any key to continue ...
echo off
plot(x,y0,x,y1,x,y2,x,y3,x,y4),
title(' gamma-distribution density function')
xlabel(' alfa = 10, beta = 3:0.5:5, x0 = 0  ')
clear
clc
