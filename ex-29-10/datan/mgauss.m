function y = mgauss(x0,no,x,d)
% keywords: Gaussian samples
% call: y = mgauss(x0,no,x,d)
% The function computes random vectors from a multidimensional Gaussian
% distribution with given mean. The covariance matrix is EITHER given
% directly OR computed by the function, when the eigenvalues and the
% first eigenvector are given.
%
% INPUT
%            x0         the mean of the distribution
%            no         the number of output vectors
%            x          nargin = 3:  the covariance matrix
%                       nargin = 4:  the direction of the eigenvector
%                                    of the 1. eigenvalue
%            d          the eigenvalues of the covariance matrix
% OUTPUT
%            y          the matrix containing the random vectors
%                       in a 'observation matrix form', as the rows


% by H.Haario 10.10.1989
% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

x0   = x0(:);           %make sure x0 is a column vector

if nargin == 3
  a = x;
   [m,nn] = size(a);
else
  if nargin == 4
    x    = x(:);
    m    = length(x);
    x(1) = x(1) + sign(x(1)) * norm(x);
    u    = eye(m) - 2.0/norm(x)^2 * x*x';  % the Householder trick
    a    = u * diag(d) * u' ;
  else
    error('nargin must 3 or 4 !')
  end
end

g    = chol(a);

xr   = randng(m,no);
y    = g' * xr + x0 * ones(1,no);
y    = y';
