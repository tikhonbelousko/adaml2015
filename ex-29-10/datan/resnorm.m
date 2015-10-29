  function [a3,a4,tau] = resnorm(res,plot);
% keywords: regression
% call: [a3,a4,tau] = resnorm(res,plot);
% The function calculates, for the residuals in the matrix 'res', the test
% criterion against the null hypothesis  H0 : residuals are normal. The
% skewness and kurtosis measures are also calculated. Normal paper plots
% may be drawn for each residual column vector in the matrix 'res'.
%
% INPUT  :      res     the residual matrix
%               plot    the plotting option. 1: draw the normal plots
%                       OPTIONAL
%
% OUTPUT :      a3      the skewness
%               a4      the kurtosis
%               tau     the test for residuals being observations from
%                       a normal distribution       tau ~ CHI^2(df = 2)

[mr,nr] =       size(res);
res2	=	res.^2;     smres2 = 1/mr * sum(res2);
res3	=	res.^3;     smres3 = 1/mr * sum(res3);
res4	=	res.^4;     smres4 = 1/mr * sum(res4);
a3	=	smres3./(smres2.^(3/2));
a4	=	smres4./(smres2.^2);
tau	=	(mr/6)*a3.^2 + (mr/24)*(a4 - 3).^2;

if nargin > 1
   if plot==1
      for i   = 1:nr
        r1 = res(:,i);
        plotnorm(r1); pause
      end;
   end
end
