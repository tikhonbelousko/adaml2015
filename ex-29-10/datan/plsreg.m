  function [yfit,b,T,P,Q,W,U] = plsreg(X,Y,dim,iscale)
% keywords: PLS, multivariate analysis, chemometrics, regression
% call: [yfit,b,T,P,Q,W,U] = plsreg(X,Y,dim,iscale)
% The function computes a PLS regression model for the data X,Y.
% INPUT
%      X,Y         The datamatrices
%      dim         the (largest) dimension computed. OPTIONAL.
%                  default: dim = minimum dimension of X
%      iscale      perform the scaling of 'X' and 'Y'
%                  OPTIONS: 0: no scaling
%                           1: centering
%                           2: autoscaling
%                  OPTIONAL, default iscale = 2.
% OUTPUT
%      yfit        fits for y with dimension dim
%      b           regression coefficients:
%                      yfit=[ones(X(:,1)) X]*b
%      T           scores of x-set           t = X*w
%      P           loadings of x-set         p = X'*t/(t'*t)
%      Q           loadings of y-set         q = Y'*u/(u'*u)
%      W           the x-weights             w = X'*u/(u'*u)
%      U           the y-scores            

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

[nx,mx] = size(X);
[ny,my] = size(Y);
mdim    = min(mx,nx);

if nx ~= ny
    error('plsreg: the dimensions of x and y do not fit');
end

if nargin == 3
    iscale =2;
elseif nargin == 2
    dim = mdim; iscale = 2;
elseif nargin < 2
    error('plsreg: too few parameters');
end

if length(dim) == 0, dim = mdim; end;
if length(iscale) == 0, iscale = 2; end;

if dim > mdim
    txtdim = num2str(mdim);
    error(['PLS dim ' num2str(dim) ' too large, maximum here ' txtdim]);
end

if iscale == 2
   [X,mex,sx] = scale(X); [Y,mey,sy] = scale(Y);
end;

if iscale == 1
   [X,mex] = scale(X,mean(X)); [Y,mey]  = scale(Y,mean(Y));
end;

[T,P,Q,W,U] = pls(X,Y,dim);

if iscale == 2
   [yfit,b]  = plspred(X,P,Q,W,dim);
   yfit      = unscale(yfit,mey,sy);
   for i = 1:my
      b(:,i) = sy(i)*b(:,i);
      b(2:mx+1,i) = b(2:mx+1,i)./(sx');
      b(1,i)  = mey(i) -(mex*b(2:mx+1,i));
   end  
elseif iscale == 1
   [yfit,b]  = plspred(X,P,Q,W,dim);
   yfit      = unscale(yfit,mey);
   for i = 1:my
     b(1,i)  = mey(i) -(mex*b(2:mx+1,i));
   end
elseif iscale == 0
   [yfit,b]  = plspred(X,P,Q,W,dim,mean(Y),mean(X));
end

