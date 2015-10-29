function y = dfun2(x,A,B,E)

[m,n] = size(A);
x = reshape(x,m,1);
Ehat = A*sin(x)+ B*cos(x);
y = [];
for i = 1:n
     derva = sum(-2*(E-Ehat).*(A(:,i)*cos(x(i))-B(:,i)*sin(x(i))));
     y = [y;derva];
end

