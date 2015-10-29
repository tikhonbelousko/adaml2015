  function y = denslogn(x,mu,sigma,x0)
% keywords: lognormal distribution, lognormal density
% call: y = denslogn(x,mu,sigma,x0)
%
% The function computes the log-normal distribution density
% function values 'y' for arguments 'x'(see e.g. Johnson & Kotz,
% Continuous Univariate distributions-1, 112 and demologn).
%
% INPUT:    x            the input argument vector
%           mu,sigma,x0  parameters of the log-normal distribution,
%                        log(x - x0) ~ N(mu,sigma), x > x0
%           mu           OPTIONAL, default: mu = 0
%           sigma        OPTIONAL, default: sigma = 1
%           x0           OPTIONAL, default: x0 = 0
%
% OUTPUT:   y            the values of the density function

if nargin < 4, x0 = 0; end
if nargin < 3, x0 = 0; sigma = 1; end
if nargin < 2, x0 = 0; sigma = 1; mu = 0; end


[n,m] = size(x);
x    = x-x0;
i    = find(x>0);
y    = zeros(n,m);

y(i) = exp(-.5*((log(x(i))-mu)./sigma).^2)./(sqrt(2*pi)*sigma.*x(i));

