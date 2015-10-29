  function plotF(xl,xu,m,n,xtest,labels)
% keywords: F-distribution plot
% call: plotF(xl,xu,m,n,xtest,labels)
% the function plots the density function of the F-distribution F_{m,n}
% on the interval [xl,xu]. The  user may also plot the points in the
% vector 'xtest' in the plot
%
% INPUT
%           xl       the lower end of the interval
%           xu       the upper end of the interval
%           m,n      the n. of degrees of freedom of F
%           xtest    a vector of additional points in the picture
%                    OPTIONAL
%           labels   label printing option for deg. of freedom
%                    (1/0, yes/no). OPTIONAL. default: labels = 1

 if nargin < 6
      labels = 1;
 end
 step     = (xu - xl)/100;
 x        = xl:step:xu;
 y        = densf(x,m,n);
 ymax     = max(y);
 if isinf(ymax)
      k = find(isinf(y));
      yy = remove(y,[],k);
      ymax = max(yy);
 end
 sm       = strvec(m);
 sn       = strvec(n);
 str      = ['the F-distribution F_{m,n}, m = ',sm,',  n = ',sn];
 if nargin < 5
      xtest = [];
 end

 xx       = xl:(xu-xl)/99:xu;
 p        = distf(xx,m,n);
 i95      = min(find(p >= .95)) +1;
 i99      = min(find(p >= .99)) +1;

 xsignif = [xx(i95) xx(i99)];
 xsignif = kron(xsignif,[1 1]);

 if length(i99) > 0
     x1u  = xsignif(1:2);
     x2u  = xsignif(3:4);
     y1   = [1.1*ymax 0];
     y2   = y1;
     str1 = ['the 95% (-) and 99% (--) percentile points'];
 elseif length(i95) > 0
     x1u  = xsignif(1:2);
     x2u  = [];
     y1   = [1.1*ymax 0];
     y2   = [];
     str1 = ['the 95% (-) percentile point'];
 else
     x1u  = []; y1 = [];
     x2u  = []; y2 = [];
     str1 = [' '];
 end

% keyboard

 if length(xtest) > 0
     y0   = zeros(1,length(xtest)) + 0.1*ymax;
     plot(x,y,'-',x1u,y1,'-',x2u,y2,'--',xtest, y0,'*');
     if labels == 1
          title(str); xlabel(str1)
     end
 else
     plot(x,y,x1u,y1,'-',x2u,y2,'--');
     if labels == 1
          title(str); xlabel(str1)
     end
 end
