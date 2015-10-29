function plotn(xl,xu,muu,sigma,xtest)
% keywords: normal distribution plot
% call: plotn(xl,xu,muu,sigma,xtest)
% The function plots the density function of the normal distribution
% on the interval [xl,xu], together with the symmetric 95% and 99%
% percentile points. The  user may also plot the points in the vector
% 'xtest' in the plot.
%
% INPUT
%          xl          the lower end of the interval
%          xu          the upper end of the interval
%          muu         the mean point of the distribution
%                      OPTIONAL,  default:  muu = 0
%          sigma       the mean deviation of the distribution
%                      OPTIONAL,  default:  sigma = 1
%          xtest       a vector of additional points in the plot
%                      OPTIONAL

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

 if (xl >= xu) error('you must have xl < xu !'); end
 step     = (xu - xl)/100;
 x        = xl:step:xu;
 if nargin < 3 | nargin < 5 xtest = []; end
 if nargin < 3  muu   = 0;  end
 if nargin < 4  sigma = 1;  end
 if length(muu)==0,   muu = 0;   end
 if length(sigma)==0, sigma = 1; end

 y        = 1/sqrt(2*pi)/sigma * exp(-0.5*(x - muu).^2/sigma^2);
 ymax     = max(y);
 smuu     = strvec(muu);
 ssigma   = strvec(sigma);
 str = ['Normal distribution with mean ', smuu,' and mean deviation ',ssigma ];

 xsignif  = [1.96,-1.96 2.576 -2.576]; xsignif = kron(xsignif,[1 1]);
 xsignif  = sigma*xsignif + muu;

 if xu >= 2.576
     x1u = xsignif(5:6);
     x2u = xsignif(1:2);
     y2  = [1.1*ymax 0];
     y1  = y2;
 elseif xu >= 1.96 & xu < 2.576
     x2u = xsignif(1:2);
     x1u = [];
     y2  = [1.1*ymax 0];
     y1  = [];
 else
     x1u = []; y1 = [];
     x2u = []; y2 = [];
 end

 if xl <= -2.576
     x1l = xsignif(7:8);
     x2l = xsignif(3:4);
     y3  = [1.1*ymax 0];
     y4  = y3;
 elseif xl> -2.576 & xl <= -1.96
     x1l = [];
     x2l = xsignif(3:4);
     y3  = [1.1*ymax 0];
     y4  = [];
 else
     x1l = []; y3 = [];
     x2l = []; y4 = [];
 end


 if length(xtest) > 0
     y0   = zeros(1,length(xtest)) + 0.1*ymax;
     plot(x,y,'-',x1u,y1,'--',x1l,y4,'--',x2u,y2,'-',x2l,y3,'-',xtest, y0,'*');
     title(str); xlabel('the 95% (-) and 99% (--) symmetric percentile points')
 else
     plot(x,y,x1u,y1,'--',x1l,y4,'--',x2u,y2,'-',x2l,y3,'-');
     title(str); xlabel('the 95% (-) and 99% (--) symmetric percentile points')
 end

