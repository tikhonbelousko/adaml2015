  function cor=corrcov(cov)
% keywords: covariance matrix
% call: cor=corrcov(cov)
% The function computes the correlation matrix
%
% INPUT:  cov          a covariance matrix, cf MATLAB function COV
%
% OUTPUT: cor          the correlation matrix corresponding to 'cov'

cor = cov./sqrt(diag(cov)*diag(cov)');

