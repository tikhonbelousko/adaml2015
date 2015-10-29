  function [yhat,b,that] = plspred(Xpred,P,Q,W,dim,meany,meanx)
% keywords: PLS, multivariate analysis, chenometrics, prediction
% function [yhat,b,that] = plspred(Xpred,P,Q,W,dim,meany,meanx)
% Calculates a pls-prediction for y when the respective x is given. 
%
% INPUT  :	Xpred	datamatrix containing x
%		P,Q,W	matrixes from operation PLS
%		dim	dimension to be used
%               meany   mean(Y) for Y of the training set
%                       (if Y is centered my can be omitted)
%               meanx   mean(X) for X of the training set
%                       (if X is centered my can be omitted)
%
% OUTPUT :	yhat	prediction for y
%               b       regression coefficients:
%                           yhat=[ones(Xpred(:,1)) Xpred]*b
%               that    prediction for t

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

[mp,np] = size(P); if dim>np error('the dimension dim too large');end
[mq,nq] = size(Q);
[mx,nx] = size(Xpred);
P = P(:,1:dim);
W = W(:,1:dim);
Q = Q(:,1:dim);

if nargin < 5  
    error('not enough input');
elseif nargin==5
    meany = zeros(1,mq);
    meanx = zeros(1,nx);
elseif nargin==6
    meanx = zeros(1,nx);
end

yhat    = zeros(mx,mq);
that    = zeros(mx,dim);

x       = Xpred;

if nargout == 3
   for i = 1:dim  
       w         = W(:,i);
       p         = P(:,i);   
       q         = Q(:,i);
       t         = x*w; 
       that(:,i) = t;
       x         = x-t*p';   
   end
end

b           = zeros(nx+1,mq);
b(2:nx+1,:) = W*inv(P'*W)*Q';
b(1,:)      = meany-(meanx*b(2:nx+1,:));

yhat        = [ones(mx,1) Xpred]*b;

