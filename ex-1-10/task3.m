clc
clear all
close all

load balloon.mat

n = 1:2000;
A = [1:2000; ones(1, 2000)]';
x = A \ balloon;
balloon2 = balloon - A*x;
m = mean(balloon2);
v = var(balloon2);

[l] = size(balloon2)

hold on
for i=1:l
    if abs(balloon2(i) -  m) < 10*v
        plot(i, balloon(i), 'or')
    else 
        plot(i, balloon(i), 'ob')
    end 
end
hold off
