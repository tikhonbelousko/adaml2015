function y = fun2(x,A,B,E)

[m,n] = size(A);
x = reshape(x,m,1);
Ehat = A*sin(x)+B*cos(x);
y = sum((E-Ehat).^2);
