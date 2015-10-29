function [T,P] = pca2(X,dim,iprint)
% keywords: principal components, multivariate analysis
% call: [T,P] = pca2(X,dim,iprint)
% the function computes the PCA-decomposition of the matrix 'x'
% for dimensions 1,2,.. dim.
%
% INPUT:      x      the data matrix. Each observations is a row in x.
%             dim    the n of principal components computed.
%             iprint printing option.
% OUTPUT:     T     the 'scores' of the observations, i.e. the projections
%                   of the observations on the principal axes.
%             P     the  principal axes

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

[m,n]=size(X);
if dim>min(m,n), error('dim too big'), end
T=zeros(m,dim);
sqrm = sqrt(m);
P=zeros(n,dim);
for i=1:dim
  if iprint>0, disp(i), end
  var=std(X);
  [maxvar,maxind]=max(var');
  t=X(:,maxind);
  t0=0;
  count=0;
  while norm(t0-t,2)>10.E-10*sqrm;
    if count>100
      disp('pca2 did not converge with 100 iterations, norm is')
      disp(norm(t0-t,2))
      return
    end
    count=count+1;
    p=X'*t; %  /(t'*t);
    p=p/sqrt(p'*p);
    t0=t;
    t=X*p;
  end
  T(:,i)=t;
  P(:,i)=p;
  X=X-t*p';
end
