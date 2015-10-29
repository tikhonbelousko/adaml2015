  function [ind,xp,level] = classi(x,x0,p,s,level)
% keywords: classification
% call: [ind,xp,level] = classi(x,x0,p,s,level)
% The function classifies given vectors, whether they belong to
% an ellipsoidal 'pattern' or not. cf. also the function 'repres'.
% INPUT:   x       the data matrix. The vectors to be classified are
%                  given as the rows of 'x'.
%          x0      the center point of the ellipsoid
%          p       the eigenvectors of the ellipsoid
%          s       the eigenvalues, i.e., the (relative) lengths
%                  of the semiaxes of the ellipsoid
%          level   the classification criteria: vectors  whose projections
%                  'xp' on 'p' satisfy
%                    ||(x0 - xp)./s|| < level
%                  are classified to be 'in' the ellipsoid pattern.
%                  OPTIONAL.  Default: Suppose the ellipsoid represents
%                  a multidimensional Gaussian distribution with mean 'x0'
%                  and mean deviations 's' in the directions 'p'. The 'level'
%                  is computed to give the 95% confidence region.
% OUTPUT:   ind    the index vector.
%                  ind(i) = 1    the vector x(i,:) is inside the ellipsoid
%                  ind(i) = 0    the vector x(i,:) is outside the ellipsoid
%           xp     the projections of the vectors on 'p' (xp = x*p)
%           level  the classification parameter. 

 x0     = x0(:)';   %x0 is a row vector
[m,n]   = size(x);  [pm,pn] = size(p);
 ind    = zeros(m,1);
 x      = x - ones(m,1)*x0;
 if nargin < 5
    level = signichi(pn);
 end
 if level == 99
    [xx,level] = signichi(pn);
 end
 xp     = x*p;
      for i=1:m
          if norm(xp(i,:)./s)^2 < level
             ind(i,1) = 1;
          end;
      end;

