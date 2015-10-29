  function plotdim(y,ypred,ny,idim,ind)
% keywords: plot for PCR/PLS regression
% call: plotdim(y,ypred,ny,idim,ind)
% The function plots observed versus predicted values of y-variables using
% dimension 'dim' and matrix 'ypred' from CROSPLS or CROSPCR.
%
% INPUT  :      y       the matrix of the observed data values
%               ypred   matrix whose columns contain the observed and
%                       predicted y-variables, see CROSPLS or CROSPCR.
%               ny      the number of y-variables
%               idim    index of the chosen dimension (i.e. idim'th
%                       element of the vector 'dim' in CROSPLS or CROSREG)
%               ind     indices for a subset of y columns, OPTIONAL
%                       default: all y-variables plotted.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/09 15:16:12 $

if nargin == 4
   ind = 1:ny;
elseif nargin < 4
   error('too few inputs')
end

[m,n]  = size(ypred);
yest   = ypred(:,(idim-1)*ny+1:idim*ny);

plot(1:m,y(:,ind),'*',1:m,yest(:,ind),'-'),title('Data  *    Prediction  -')


