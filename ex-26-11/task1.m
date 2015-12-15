clc;
clearvars;
close all;

k = 100;

d1 = 10^3;
d2 = 10^4;
d3 = 10^5;

R1 = randn(d1, k);
R2 = randn(d2, k);
R3 = randn(d3, k);

theta = [];
for i=1:k
    for j=i+1:k
        a = R2(:,i);
        b = R2(:,j);
        costheta = dot(a,b)/(norm(a)*norm(b));
        theta = [theta, acos(costheta)];
    end 
end

hist(theta);






