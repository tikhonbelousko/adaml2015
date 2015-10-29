  function  [x0,p,s] = repres(x,dim)
% keywords: classification
% call: [x0,p,s] = repres(x,dim)
% The function computes by PCA an ellipsoidal approximative
% representation of dimension 'dim' for a set of vectors.
%
% INPUT     x         the data matrix. The set of vectors is given as
%                     the rows of 'x'
%           dim       the dimension (n. of axes) of the ellipsoid
%
% OUTPUT    x0        the mean of the ellipsoid
%           p         the directions of the 'dim' principal axes
%           s         the lengths of the semiaxes, i.e., the mean
%                     deviations of the data along the directions 'p'

 [m,n] = size(x);
  x0   = mean(x);
 [t,p] = pca((x - ones(m,1)*x0));
  t = t(:,1:dim);
  p = p(:,1:dim);

  for i = 1:dim,
     s(i) = norm(t(:,i))/sqrt(m);
  end;
