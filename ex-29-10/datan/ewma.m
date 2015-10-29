  function z = ewma(y,lambda,z0,option)
% keywords: moving average, smoothing, prediction
% call: z = ewma(y,lambda,z0,option)
%
% This function performs either EWMA-smoothing of a time series or
% calculates the EWMA-prediction of a process mean given the present
% observation and previous prediction (see e.g. Lucas & Sacucci,
% Technometrics, february 1990, vol. 32, no. 1.)
% (see also demoewma)
%
% INPUT:     y        input time series or a new observation (see 'option')
%            lambda   the weights for each y column
%            z0       the starting value (OPTIONAL, DEFAULT: z0 = y(1,:))
%                     or the previous prediction (see 'option')
%                     (often starting value is chosen to be the target value)
%            option   a STRING variable: 'smooth' for smoothing and
%                     'pred' for prediction (OPTIONAL, DEFAULT: option =
%                     'smooth')
%
% OUTPUT:    z        the smoothed series or the prediction (see 'option')
%

if nargin == 3
    option = 'smooth'
elseif nargin == 2
    option = 'smooth'; z0 = y(1,:);
elseif nargin < 2
    disp('too few inputs')
    break
end

if length(z0) == 0, z0 = y(:,1); end

[m,n]  = size(y);
z      = zeros(m,n);
z(1,:) = z0;

if option(1:2) == 'sm' | option(1:2) == 'SM'
 
    for i = 2:m
       z(i,:) = lambda.*y(i,:) + (1-lambda).*z(i-1,:);
    end

elseif option(1:2) == 'pr' | option(1:2) == 'PR'

    z = lambda.*y + (1-lambda).*z0;

end
