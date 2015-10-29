  function [T,P,q,b] = pcr(X,Y,dim)
% keywords: principal components, regression, multivariate analysis
% call: [T,P,q,b] = pcr(X,Y,dim)
% The function performs a PCA-decomposition for the matrix X ,X  = T*P'.
% Using the reparametrization Y = T*Q  the parameter estimates Q are
% calculated for dimension 'dim'.
%
% INPUT
%          X,Y   the data matrixes
%          dim   max dimension used
%
% OUTPUT
%          T     the scores,   for dimensions 1:dim
%          P     the loadings, for dimensions 1:dim
%          q     the model coefficients in principal coordinates
%                for dimension dim
%          b     the model coefficients in original coordinates
%                for dimension dim

  [T,P] =  pca(X);
  T     =  T(:,1:dim);
  P     =  P(:,1:dim);
  q     =  inv(T'*T)*T'*Y;
  b     =  P*q;

