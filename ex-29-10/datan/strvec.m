  function str = strvec(x)
% keywords: number to string
% call: str = strvec(x)
% the function transforms the numbers in the vector  'x' into a string
% vector 'str'. Useful for adding text in plots.

i1 = max(size(x));
for i = 1:i1,
    j = num2str(x(i)); str(i,1:max(size(j))) = j;
end;
str = str(1:i1,:);

