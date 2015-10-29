function [C,Ye,E] = ridge(X,Y,lambda,B1,B2,nnls,intcep,tol)
%function [C,Ye,E] = ridge(X,Y,lambda,B1,B2,nnls,intcep,tol)
%
% solve  min ||X*C-Y||^2 + lambda(1)*||B1*C||^2 + lambda(2)*||C*B2||^2
%        C>0 (optionally i.e. nnls = 1)             
%
%NOTE: lambda(1) or lambda(2) can be 0
%INPUT:  X           the 'design' matrix
%        Y           the response matrix
%        lambda      weights for B1 and B2 (typically smoothing operators)
%        B1,B2       constraining matrices for rows and columns of C
%                    (typically smoothing operators) (DEFAULT: B2 = [])
%        nnls        nnls = 1 => C > 0 (DEFAULT: nnls = 0)
%        intcep      intcep = 1 => the model has an intercept (DEFAULT: intcep = 1)
%        tol         tolerance for positivity constraint (DEFAULT: tol = 1e-6)
%OUTPUT: C           the solution matrix
%        Yfit        the fitted Y
%        E           the residuals

% Changed:
% 25-Aug-1999 ML
if nargin < 4, error('Not enough arguments for ridgereg'), end
if nargin < 5, B2 = []; end
if nargin < 6 | isempty(nnls), nnls = 0; end
if nargin < 7 | isempty(intcep), intcep = 1; end
if nargin < 8 | isempty(tol), tol = 1e-6; end

if length(tol==1), tol = [tol, 20]; end
 
if length(B1) == 0
   if length(lambda == 1)
      lambda = [0 lambda];
   else
      lambda(1) = 0;
   end
end
if length(B2) == 0
   if length(lambda == 1)
      lambda = [lambda 0];
   else
      lambda(2) = 0;
   end
end

[n,q]  = size(Y);
[qq,m] = size(B2);
if qq ~= q & lambda(2)>0,
   disp(sprintf('B2 should have %g rows\n',q))
   error('something wrong in dimensions of Y and B2')
end
if intcep == 1
   X = [ones(size(X,1),1) X];
end
[nn,p] = size(X);
if nn ~= n, 
   error('something wrong in dimensions of X and Y')
end

B1 = sparse(B1);
B2 = sparse(B2);
X  = sparse(X);
Y  = sparse(Y);

A = X'*X; 
c = (X'*Y)';
c = c(:);

if lambda(2) == 0 & lambda(1) > 0   
   if intcep == 1
      B1 = [zeros(size(B1,1),1) B1];
   end
   B1 = B1'*B1;
   Iq = spdiags(ones(q,1),0,q,q);
   G  = kron((A+lambda(1)*B1),Iq);
elseif lambda(1) == 0 & lambda(2) > 0 
   B2 = B2*B2';
   Ip = spdiags(ones(p,1),0,p,p);
   Iq = spdiags(ones(q,1),0,q,q);
   G  = kron(A,Iq) + lambda(2)*kron(Ip,B2);
elseif lambda(1) > 0 & lambda(2) > 0
   if intcep == 1
      B1 = [zeros(size(B1,1),1) B1];
   end
   B1 = B1'*B1;
   B2 = B2*B2';
   Ip = spdiags(ones(p,1),0,p,p);
   Iq = spdiags(ones(q,1),0,q,q);
   G  = kron((A+lambda(1)*B1),Iq) + lambda(2)*kron(Ip,B2);
else 
   G  = kron(A,eye(q));
end

minC = tol(1)-1;
beta = 1;

ncount = 0;
while minC < -tol(1) & ncount < tol(2)
   ncount = ncount+1;   
   beta = 100*beta;
   if nnls == 1 & beta > (100)
      [i,j]        = find(C < 0); % i = i(:);
      D            = zeros(p*q,1);
      D((i-1)*q+j) = beta*ones(size(i));
      D            = spdiags(D,0,p*q,p*q);
      G            = G + D;  % general case:  (Lancaster p. 239)
   end
   C = G\c;
   C = reshape(C,q,p)';
   C = full(C);
   if nnls == 1
      minC = min(min(C));
   else
      minC = 0;
   end
end

if nnls == 1
   i = find(C<0);
   if length(i) > 0, C(i) = zeros(size(i)); end
end

if nargout>1, Ye = X*C; end
if nargout>2, E  = Y-Ye; end
