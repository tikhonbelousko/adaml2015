  function y = densf(x,m,n);
% keywords: F-distribution, F density
% call: y = densf(x,m,n);
% The function computes the F-distribution F_{m,n} density function
% values 'y' for arguments 'x'.
%
% INPUT
%            x      the input argument vector
%            m,n    the n. of degrees of freedom
%
% OUTPUT
%            y       the values of the density function

 x  = x(:)';
 m2 = m/2;
 n2 = n/2;
 mn = m/n;
 mn2= m2+n2;

% c  = gamma(mn2)/gamma(m2)/gamma(n2) * mn^m2;
  c  = exp(gammaln(mn2)-gammaln(m2)-gammaln(n2)) * mn^m2;
  y  = c * (x.^(m2-1)) .* ((1 + mn*x).^(-mn2));
