  function A = integrat(y,x)
% keywords: numerical integration
% call: A = integrat(y,x)
% the function computes a (crude) integral of the  vector y
% versus the vector x
%
% INPUT       x  the abscissa values
%             y  the ordinate values
%
% OUTPUT      A  the value of the integral

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

m = length(y); n = length(x);
if m~=n, error(' y and x must have same lengths'); end
x = x(:)'; y=y(:)';
A = sum(means(y).*diff(x));

