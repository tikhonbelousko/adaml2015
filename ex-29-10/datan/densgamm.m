  function y = densgamma(x,alfa,beta,x0)
% keywords: gamma-distribution, gamma density
% call: y = densgamma(x,alfa,beta,x0)
% The function computes the gamma-distribution density function
% values 'y' for arguments 'x' (see e.g. Johnson & Kotz, Continuous
% Univariate distributions-1, 166 and demogam).
%
% INPUT:    x             the input argument vector
%           alfa,beta,x0  parameters of the gamma-distribution,
%                         alfa > 0, beta > 0 and x > x0
%
% OUTPUT:   y             the values of the density function
x = x-x0;

y = x.^(alfa-1).*exp(-x/beta)/(gamma(alfa)*beta^alfa);
