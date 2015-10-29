  function [y,xbounds]=code2(x,ybounds,xbounds)
% keywords: data scaling
% call: [y,xbounds]=code2(x,ybounds,xbounds)
%
% This function codes 'x' to have min and max values as given in 'bounds'
%
% INPUT:       x        A (n by p) matrix whose rows give the coordinates to
%                       be transformed.
%              ybounds  A (2 by p) matrix giving the minimum (1.row) and
%                       maximum (2.row) values of the 'y'-coordinates.
%              xbounds  A (2 by p) matrix giving the minimum (1.row) and
%                       maximum (2.row) values of the 'x'-coordinates.
%                       OPTIONAL: default xbounds = [min(x);max(x)]
%
% OUTPUT       y        The transformed coordinates
%              xbounds  see INPUT
%
% NOTE:        The inverse tranformation is achieved by reversing the
%              order of 'ybounds' and 'xbounds'!
%
% SEE ALSO: CODE

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

if nargin == 2
   xbounds = [min(x);max(x)];
elseif nargin < 2
   error('too few inputs')
end

y=code(x,xbounds,1);
y=code(y,ybounds,-1);
