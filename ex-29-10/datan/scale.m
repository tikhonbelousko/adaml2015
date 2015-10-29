  function [y,xmean,xstd] = scale(x,xmean,xstd)
% keywords: scaling data
% call: [y,xmean,xstd] = scale(x,xmean,xstd)
% Function centers and scales the matrix x.
% INPUT        x      matrix to be scaled
%              xmean  known means  (OPTIONAL)
%              xstd   known standard deviations (OPTIONAL)
%                     NOTE! If xmean is given without xstd
%                     only centering is done.
% OUTPUT       y      scaled matrix  
%              xmean  means of the columns in x 
%              xstd   standard deviations of the columns in x
%
% REMARK: xmean and xstd are used as input for prediction purposes!
% See also UNSCALE

[m,n] = size(x);
e     = ones(m,1);
y     = zerog(x);

if nargin == 1

    xmean = mean(x);
    xstd  = std(x);
elseif nargin == 2
    xstd  = ones(1,length(xmean));	
end

x      = x - e * xmean;
j      = find(xstd ~= 0);
y(:,j) = x(:,j)./(e * xstd(j));

