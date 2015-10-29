  function y = denschi(x,n)
% keywords: chi-squared distribution, chi-squared density
% call: y = denschi(x,n)
% The function computes the chi-squared distribution density
% function values 'y' for arguments 'x'
%
% INPUT
%             x    the input argument vector
%             n    the n. of degrees of freedom
% OUTPUT
%             y    the values of the density function

 x  = x(:)';
 n2 = n/2;
 c  = 1/(2^n2 * gamma(n2));

 y = c * (x.^(n2-1)) .* exp(-x/2);




