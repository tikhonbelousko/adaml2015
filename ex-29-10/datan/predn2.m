  function y = predn2(w1,w2,x,v)
% keywords: neural networks
% call: y = predn2(w1,w2,x,v)
% The function computes the output of a neural network with one
% hidden neuron layer and an output layer, both with the logistic
% link function.
%
% INPUT      w1    the weight matrix for the first layer. The last
%                  column of 'w1' gives the bias.
%            w2    the weight matrix for the second layer. The last
%                  column of 'w2' gives the bias.
%            x     the input matrix
%            v     a scaling matrix. 'v' scales the output from
%                  the layer to the size wanted. 'v' is obtained, e.g.,
%                  as 'cinv' by SCALEAB. OPTIONAL, default: scaling not
%                  performed
%
% OUTPUT     y     the output from the network

   [m,n] = size(x); [m1,n1] = size(w1);[m2,n2] = size(w2);onem1 = ones(m,1);
   x1    = [x ones(m,1)];
   y1    = x1*w1;
   y1    = ones(m,n1)./(1 + exp(-y1));
   y1    = [y1 ones(m,1)];
   y2    = y1*w2;
   y2    = ones(m,n2)./(1 + exp(-y2));
   y     = y2;
   if nargin == 4
       y = y .* [onem1*v(1,:)] + onem1*v(2,:);
   end
