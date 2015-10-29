  function [w,v,ys,ynet] = initlay1(x,y,beta,w0);
% keywords: neural nteworks
% call: [w,v,ys,ynet] = initlay1(x,y,beta,w0);
% The function computes an initial weight matrix for a neural network with
% one logistic output layer. The weights are computed for an initialization
% of the network so as to make the output approximate the data 'y'.
%
% INPUT       x      the input training matrix.
%             y      the output training data.
%             beta   a linearization parameter.
%             w0     a preliminary weight and bias matrix. OPTIONAL
%                    Default:  obtained from a linear model, computed
%                    by this function.
% OUTPUT
%             w      the weight and bias matrix. The last row contains the
%                    bias.
%             v      a scaling matrix. Used to get the output
%                    back to the scale of original 'y', cf PREDN1
%             ys     the data 'y' scaled to be between 0 and 1 by the
%                    parameter 'beta'. Used as the training data, cf.
%                    BACKPRO1
%             ynet   the output computed by the network

 [m,n]  = size(x);  [mm,nn] = size(y);
 x1     = [x ones(m,1)];
 a      = 1/(1 + exp(beta)); b = 1/(1 + exp(-beta));
 [ys,cab,v] = scaleab(y,a,b);              % scale 'y' to the
                                           % linearization range
 if nargin < 4
    w   = x1\ys;                        %in case 'w0' not given, compute
    y0  = x1*w;                         %it from a linear model. the training
    w0  = w;                            % y, 'y0', is given by the model
 else
    y0  = ys;                           %user gives 'w0'
 end

 [xs,c] = scaleab(y0,-beta,beta);
  w     = [w0(1:n,:)*diag(c(1,:)); (w0(n+1,:).*c(1,:) + c(2,:))];
  ynet  = predn1(w,x,v);


