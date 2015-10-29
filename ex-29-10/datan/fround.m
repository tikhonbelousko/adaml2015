  function y = fround(x,des)
% keywords: rounding numbers
% call: y = fround(x,des)
% The function rounds the elements of a matrix to a given n of
% decimals.
%
% INPUT    x    the numbers
%          des  the n of decimals
%
% OUTPUT   y    the rounded version of 'x'

y = round(10^des * x)/10^des;


