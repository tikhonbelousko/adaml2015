  function y=csum(t,x,mx)
% keywords: cumulative sum, statisticl process control
% call: y=csum(t,x,mx)
% The function calculates and plots the cumulative sum of deviations of
% 'x' with respect to 'mx'. The length of the vector 't' (typically time)
% must be the same as the number of rows of 'x'. The length of 'mx'
% must be the same as number of columns of 'x'.
%
% INPUT
%              t      x-axis of the plot
%              x      the vector whose cusum is plotted
%              mx     the target value of 'x'
% OUTPUT
%              y      the cumulative sum of 'x - mx'

if min(size(x))==1 x = x(:); end

mx     = mx(:)';
meansx = kron(ones(x(:,1)),mx);
x      = x-meansx;
y      = cumsum(x);
plot(t,y);
