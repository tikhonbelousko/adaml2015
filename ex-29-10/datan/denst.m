  function y = denst(x,n)
% keywords: t-distribution, t density
% call: y = denst(x,n)
% The function computes the t-distribution density function
% values 'y' for arguments 'x'
%
% INPUT
%              x            the input argument vector
%              n            the n. of  degrees of freedom
% OUTPUT
%              y            the values of the density function

 x   = x(:)';
 m   = length(x);
 n2  = n/2;
 n12 = (n+1)/2;
% c   = gamma(n12)/(sqrt(pi*n) * gamma(n2));
  c   = exp(gammaln(n12)- log(sqrt(pi*n)) - gammaln(n2));

 y   = (ones(1,m)*c) ./  ((1 + x.^2/n).^n12);
