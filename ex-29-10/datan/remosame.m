  function [y,k] = remosame(x,tol)
% keywords: removing rows, linear dependence
% call: [y,k] = remosame(x,tol)
% The function removes  from the matrix 'x' columns whose absolute
% value of correlation coefficient is smaller than 'tol'.
%
% INPUT:     x      the original matrix
%            tol    given tolerance
%                   OPTIONAL, DEFAULT: tol = 1.0e-10
%
% OUTPUT:    y      the transformed matrix
%            k      indexies of the removed colums

[m,n] = size(x);

if nargin == 1
       tol = 1.0e-10;
end

if nargin >= 3
       disp( 'too many inputs')
       break
end

k = find(std(x) < tol);
x(:,k) = rand(m,length(k));
C = corrcoef(x);
C = C-diag(ones(n,1));

for i = 1:n
    kk = find(abs(C(i,:)-1) < tol);
    ii = find(kk>i);
    k  = unionset(k,kk(ii));
end

y = remove(x,[],k);
