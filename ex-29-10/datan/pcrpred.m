  function [yhat,b] = pcrpred(Xpred,P,Q,dim,meany,meanx)
% keywords: principal components, regression, multivariate analysis, prediction
% call: [yhat,b] = pcrpred(Xpred,P,Q,dim,meany,meanx)
% Calculates a pcr-prediction for y when the respective x is given.
%
% INPUT  :	Xpred	datamatrix containing x
%               P,Q     matrixes from PCR
%		dim	dimension to be used
%               meany   mean(Y) for Y of the training set
%                       (if Y is centered my can be omitted)
%               meanx   mean(X) for X of the training set
%                       (if X is centered my can be omitted)
%
% OUTPUT :	yhat	prediction for y
%               b       regression coefficients:
%                           yhat=[ones(Xpred(:,1)) Xpred]*b

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

P = P(:,1:dim);
Q = Q(1:dim,:);
[mp,np] = size(P); if dim>np error('the dimension dim too large');end
[mq,nq] = size(Q);
[mx,nx] = size(Xpred);

if nargin < 4
    error('not enough input');
elseif nargin==4
    meany = zeros(1,nq);
    meanx = zeros(1,nx);
elseif nargin==5
    meanx = zeros(1,nx);
end

b           = zeros(nx+1,nq);
b(2:nx+1,:) = P*Q;
b(1,:)      = meany-(meanx*b(2:nx+1,:));

yhat        = [ones(mx,1) Xpred]*b;
