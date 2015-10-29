  function str = strvecf(x,fmt)
% keywords: number to string
% call: str = strvecf(x,fmt)
% the function transforms the numbers in the vector  'x' into a string
% vector 'str' using the format given in the string 'fmt' (e.g. fmt='%6.2f').
% Useful for adding text in plots.

if nargin < 2; fmt = '%8.2e'; end

[i1,i2] = size(x);

s  = sprintf(fmt,x(1));

if x(1) >= 0
    ns = length(s)+1;
else
    ns = length(s);
end

bl = ' ';
str = bl(ones(i1,1),ones(1,ns));

for i = 1:i1,
    s = sprintf(fmt,x(i));
    str(i,ns-length(s)+1:ns) = s;
end;


