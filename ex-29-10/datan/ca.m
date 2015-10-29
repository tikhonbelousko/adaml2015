  function [u,t,l,M,N] = ca(X);
% keywords: correspondence analysis, biometrics, multivariate analysis
% call: [u,t,l,M,N] = ca(X);
% The function computes the CA (Correspondence Analysis) for a data
% matrix.
% INPUT
%          X    the data matrix (e.g. species/sites frequency data)
% OUTPUT
%          u    the scores (for species)
%          t    the scores (for sites )
%          l    the dispersions (correlations)
%          M    the row sums
%          N    the column sums
%
% NOTE:  - CA is typically used for abundance,frequency, presence/absence
%          etc data: the elements of 'X' have to be non-negative.
%        - the order of rows/columns in 'X': each row gives the abundance
%          etc for one (e.g.) species
%        - Depending on application, CA appears in slightly different
%          forms (either 't' or 'u' is multiplied by 'l', or both are
%          multiplied by 'sqrt(l)', etc.)

 [mm,nn] = size(X);

  N  = sum(X);            % the columns sums
  NN = oneg(N)./sqrt(N);

  M  = sum(X')';          % the row sums
  MM=  oneg(M) ./sqrt(M);

  MXN = (MM*ones(1,nn)).*X.*(ones(mm,1)*NN);    % the scaling of X

  if mm > nn
    [p,l,q] = svd(MXN,0);
  else
    [q,l,p] = svd(MXN',0);
  end

  nn = min(mm,nn);
  t  = (NN'* ones(1,nn)).* q;       [m,n] = size(t);   t = t(:,2:n);
  u  = (MM * ones(1,nn)).*(p*l);    [m,n] = size(u);   u = u(:,2:n);

  l  = diag(l).^2;

