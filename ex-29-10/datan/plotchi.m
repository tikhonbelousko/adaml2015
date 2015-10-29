function plotchi(xl,xu,n,xtest)
% keywords: chi-distribution plot
% call: plotchi(xl,xu,n,xtest)
% the function plots the density function of the chi-distribution
% on the interval [xl,xu], together with the 5%-95% and 1%-99% percentile
% points. The  user may also plot the points in the vector 'xtest'
% in the plot.
%
% INPUT
%        xl      the lower end of the interval
%        xu      the upper end of the interval
%        n       the n. of degrees of freedom
%        xtest   a vector of additional points in the picture
%                OPTIONAL

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

if (xl >= xu) error('you must have xl < xu !'); end
 if nargin < 4 xtest = []; end

 step     = (xu - xl)/100;
 x        = xl:step:xu;
 y        = denschi(x,n);
 ymax     = max(y);
 sn       = strvec(n);
 str      = ['the chi-distribution with ',sn,' degrees of freedom'];

 [x05, x01, x95, x99] = signichi(n);

 xsignif  = [x95 x05 x99 x01 ];  xsignif = kron(xsignif,[1 1]);

 if xu >= x01
     x1u = xsignif(7:8);
     x2u = xsignif(3:4);
     y2  = [1.1*ymax 0];
     y1  = y2;
 elseif xu >= x05 & xu < x01
     x2u = xsignif(3:4);
     x1u = [];
     y2  = [1.1*ymax 0];
     y1  = [];
 else
     x1u = []; y1 = [];
     x2u = []; y2 = [];
 end

 if xl <= x99
     x1l = xsignif(5:6);
     x2l = xsignif(1:2);
     y3  = [1.1*ymax 0];
     y4  = y3;
 elseif xl> x99 & xl <= x95
     x1l = [];
     x2l = xsignif(1:2);
     y3  = [1.1*ymax 0];
     y4  = [];
 else
     x1l = []; y3 = [];
     x2l = []; y4 = [];
 end


 if length(xtest) > 0
     y0   = zeros(1,length(xtest)) + 0.1*ymax;
     plot(x,y,'-',x1u,y1,'--',x1l,y4,'--',x2u,y2,'-',x2l,y3,'-',xtest, y0,'*');
     title(str); xlabel('the 95%/5% (-) and 99%/1% percentile points')
 else
     plot(x,y,x1u,y1,'--',x1l,y4,'--',x2u,y2,'-',x2l,y3,'-');
     title(str); xlabel('the 95%/5% (-) and 99%/1% percentile points');
 end

