  function [yfit,b,T,P,q] = pcreg(X,Y,dim,iscale)
% keywords: principal components, regression, multivariate analysis
% call: [yfit,b,T,P,q] = pcreg(X,Y,dim,iscale);
% the function computes the principal component regression
% INPUT:            X,Y     the datamatrices
%                   dim     the largest dimension used; yfit calculated
%                           at each dimension
%                           OPTIONAL, default: dim = no. of x-variables
%                   iscale  perform the scaling and/or centering of 'X' 
%                            iscale = 0: no scaling
%                            iscale = 1: centering only
%                            iscale = 2: autoscaling
%                           OPTIONAL, default: iscale = 2
% OUTPUT:           yfit    prediction for y at each dimension
%                   b       regression coefficients for the highest dimension
%                   T       the scores, for dimensions 1:dim
%                   P       the loadings, for dimensions 1:dim
%                   q       the regression coefficients in principal
%                           coordinates for the highest dimension

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

[nx,mx] = size(X);
[ny,my] = size(Y);

if nx ~=ny
     error('pcreg: the dimenions of x and y do not fit');
end

if nargin == 3
   iscale = 2; 
elseif nargin == 2
   dim = mx; iscale = 2;
elseif nargin < 2
   error('pcreg: too few parameters');
end

if length(iscale)==0, iscale = 2;end
if length(dim) == 0, dim = mx; end

if dim > mx
   txt = ['pcreg: dimension ', num2str(dim), ' too large, max. here ',num2str(mx)];
   error(txt);
end

if iscale == 2
   [X,mex,sx] = scale(X);
elseif iscale == 1
   [X,mex] = scale(X,mean(X));
end;

yfit =[];

[TT,PP] = pcr(X,Y,dim);

for i = 1:dim
    T     =  TT(:,1:i);
    P     =  PP(:,1:i);
    q     =  inv(T'*T)*T'*Y;

   if (iscale == 2)
      [yf,b] =pcrpred(X,P,q,i,mean(Y));
      for j = 1:my
          b(2:mx+1,j) = b(2:mx+1,j)./(sx');
          b(1,j)      = mean(Y(:,j)) -(mex*b(2:mx+1,j));  
      end
   elseif (iscale == 1)
      [yf,b] = pcrpred(X,P,q,i,mean(Y));
      for j = 1:my
          b(1,j) = mean(Y(:,j)) -(mex*b(2:mx+1,j));
      end
   else
      [yf,b] =pcrpred(X,P,q,i,mean(Y),mean(X));
   end;
   yfit = [yfit yf];
end

