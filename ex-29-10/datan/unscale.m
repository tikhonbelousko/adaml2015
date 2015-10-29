function y = unscale(x,xmean,xstd)
% keywords: scaling
% call: y = unscale(x,xmean,xstd)
% Function uncenters and unscales the matrix 'x'.
% INPUT:       x      matrix to be unscaled
%              xmean  known means 
%              xstd   known standard deviations
%                     OPTIONAL. With missing 'xstd'
%                     only uncentering done
% OUTPUT:      y      unscaled/uncentered matrix
%
% See also SCALE, CENTER

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

if nargin < 2
  error('Not enough input variables');
elseif nargin==2
  xstd=ones(1,length(xmean));
end

[m,n] = size(x);
y     = zeros(m,n);
i     = ones(m,1);
j     = 1:n;
y     = xmean(i,j) + xstd(i,j).*x;
