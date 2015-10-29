  function [w1,w2,v,ys,ynet] = initlay2(x,y,dim,beta);
% keywords: neural networks
% call: [w1,w2,v,ys,ynet] = initlay2(x,y,dim,beta);
% The function computes initial weight matrixes for a neural network with
% logistic link functions. The network has 'dim' hidden neurons in one
% hidden layer. The weights are computed for an initialization of the
% network so as to make the output approximate the data 'y'.
%
% INPUT       x      the input training matrix.
%             y      the output training data.
%             dim    the n of hidden layer neurons
%             beta   a linearization parameter.
%
% OUTPUT
%             w1     the weight matrix for the 1. layer. The last row
%                    contains the offset
%             w2     the weight matrix for the 2. layer. The last row
%                    contains the offset
%             v      a scaling matrix. Used to get the output
%                    back to the scale of original 'y', cf PREDN2
%             ys     the data 'y' scaled to be between 0 and 1 by the
%                    parameter 'beta'. Used as the training data, cf.
%                    BACKPRO2
%             ynet   the output computed by the network

 [m,n] = size(x);  [mm,nn] = size(y);
 x1    = [x ones(m,1)];

 if m < n
    [p,s,u] = svd(x',0);   
 else
    [u,s,p] = svd(x,0);
 end

 a        = 1/(1 + exp(beta)); b = 1/(1 + exp(-beta));
 [ys,c,v] = scaleab(y,a,b);
 col  = 1:dim;
 w10  = p(:,col);
 w20  = diag(ones(col)'./diag(s(col,col))) * u(:,col)';
 w20  = w20 * y;

 y1     = x*w10;           
 [y1,c] = scaleab(y1,-beta,beta);
 w1     = [w10*diag(c(1,:)); c(2,:)];
 y1     = ones(y1)./(1 + exp(-y1));

 y2     = y1*w20;
 [y2,c] = scaleab(y2,-beta,beta);
 y2     = ones(y2)./(1 + exp(-y2));
 w2     = [w20*diag(c(1,:)); c(2,:)];

 ww1=w1; ww2 = w2; xx=x;
 ynet   = predn2(w1,w2,x);


