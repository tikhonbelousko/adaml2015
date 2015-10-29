  function   [T,P,Q,W,U] = pls(X,Y,dim,svd)
% keywords: PLS, multivariate analysis, chemometrics
% call: [T,P,Q,W,U] = pls(X,Y,dim,svd)
% Makes the PLS-model for two set of variables, x and y.
% INPUT : X,Y    the datamatrices
%         dim    the (largest) dimension computed
%         svd    svd=1 => use svd, otherwise use pca2
%
% OUTPUT: T	 scores of x-set		t = X*w
%         P	 loadings of x-set	        p = X'*t/(t'*t)
%         Q	 loadings of y-set	        q = Y'*u/(u'*u)
%	  W	 the x-weights		        w = X'*u/(u'*u)
%         U	 scores of y-set  	        

if nargin==3, svd=1; end;

 [m,nx] = size(X);
 [m,ny] = size(Y);
  T 	= zeros(m, dim);
  P	= zeros(nx,dim);
  Q	= zeros(ny,dim);
  W 	= zeros(nx,dim);
  U	= zeros(m, dim);
  for i = 1:dim;
      C	     = Y'*X;
      if svd==0
          [A,D]  = pca2(C,1);
      else
          [A,D]  = pca(C);
      end
      w	     = D(:,1);
      t	     = X*w;
      q      = Y'*t/(t'*t);
      u      = Y*q/(q'*q);
      T(:,i) = t;
      Q(:,i) = q;
      W(:,i) = w;
      U(:,i) = u;
      p	     = X'*t/(t'*t);
      P(:,i) = p;
      X	     = X-t*p';
      Y	     = Y-t*q';
%     disp(i);
  end
%end

