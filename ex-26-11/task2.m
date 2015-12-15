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

[Q, R] = qr(R1);

d = size(Q,2);
theta = [];
for i=1:k
    for j=i+1:k
        a = Q(:,i);
        b = Q(:,j);
        costheta = dot(a,b)/(norm(a)*norm(b));
        theta = [theta, acos(costheta)];
    end 
end

hist(theta);