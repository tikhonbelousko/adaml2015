  function y = predn1(w,x,v)
% keywords: neural networks
% call: y = predn1(w,x,v)
% The function computes the output of a neural network with one
% neuron layer with the logistic link function.
%
% INPUT      w     the weight matrix. the last row of 'w'
%                  gives the bias
%            x     the input matrix
%            v     a scaling matrix. 'v' scales the output from
%                  the layer to the size wanted. 'v' is obtained, e.g.,
%                  as 'cinv' by SCALEAB. OPTIONAL, default: scaling
%                  not performed.
%
% OUTPUT     y     the output

   [m,n] = size(x); [mm,nn] = size(w); onem1 = ones(m,1); oney = ones(m,nn);
   x1    = [x ones(m,1)];
   y     = x1*w;         
   y     = oney./(1 + exp(-y));   
   if nargin == 3
       y = y .* [onem1*v(1,:)] + onem1*v(2,:);
   end


