  function yy = means(y)
% keywords: numerical integration
% call: yy = means(y)
% The function replaces a vector 'y' with the
% (row) vector [(y(1)+y(2))/2 ... (y(n-1)+y(n))/2]
% Useful for a (crude) integration of a curve (x,y).

 y = y(:)';
 n = length(y);

 x1 = y(1:n-1); x2 = y(2:n);
 y  = [x1;x2];  yy = mean(y);

