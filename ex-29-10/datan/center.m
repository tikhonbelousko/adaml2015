  function [y,xmean] = center(x,xmean)
% keywords: data scaling
% call: [y,xmean] = center(x,xmean)
% Function centers  the matrix x.
% INPUT        x       the matrix to be centered
%              xmean   OPTIONAL for external centering
% OUTPUT       y       the centered matrix
%              xmean   the means of the columns in 'x'

[m,n] = size(x);
i     = ones(m,1);

if nargin == 1
    xmean = mean(x);
end

y     = x - xmean(i,:);
