 function y = zeronega(y);
% keywords: data manipulation
% call: y = zeronega(y);
% the function replaces negative values in the matrix
% 'y' by zeros.

y = y.*(y>=0);
