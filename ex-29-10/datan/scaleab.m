  function  [yscaled,c,cinv] = scaleab(y,a,b);
% keywords: scaling data
% call:  [yscaled,c,cinv] = scaleab(y,a,b);
% The function scales the input matrix 'y' so that each scaled element
% is in the interval [a,b].
% Useful, e.g., in connection of neural networks.
%
% INPUT
%          x        the input matrix
%          a,b      the lower and upper bounds for the interval
% OUTPUT
%          yscaled  the scaled version of 'y'
%          c        the coefficients of the linear maps y --> yscaled
%          cinv     the coefficients of the inverse maps yscaled --> y

 [m,n] = size(y); onem1 = ones(m,1);
 ymin  = min(y);  ymax  = max(y);
 ab    = [a;b];

 for i = 1:n;
     c(:,i)    = [ymin(:,i) 1; ymax(:,i) 1]\ab;
     cinv(:,i) = [a 1; b 1] \[ymin(:,i); ymax(:,i)];
 end

 yscaled = y .* [onem1*c(1,:)] + onem1*c(2,:);


