  function y=gaussian(x,b)
% keywords: gaussian density
% call: y=gaussian(x,b)
% The function computes a family of Gaussian-like 'densities'
%
% INPUT:    x     abscissa values
%           b     the vector giving the profile
%
%                    y = exp(-(abs(x-mean)/std)^flat),
%
%                  with
%                        mean = b(1)
%                        std  = b(2)
%                        flat = b(3)
%
% OUTPUT:   y     the 'density'
%

 mean = b(1);
 sd   = b(2);
 flat = b(3);

 y = exp(-(abs(x-mean)/sd).^flat);

