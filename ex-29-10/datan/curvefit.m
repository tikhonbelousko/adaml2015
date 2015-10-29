 function [yfit,b] = curvefit(model,x,y,b0,xtitle,ytitle,gtitle)
%Keywords: curve fitting, nonlinear regression
%
%call: [yfit,b] = curvefit(model,x,y,b0,xtitle,ytitle,gtitle)
%
%INPUT:  model           a string containing the function describing the curve
%                        the parameters must be named b(1),b(2),... and the 
%                        independent variable must be named x
%        x               x-coordinates
%        y               y-coordinates
%        b0              initial guess for the unknown parameter values
%        xtitle          x-axis title
%        ytitle          y-axis title
%        gtitle          general title
%                        NOTE: titles can be omitted
%OUTPUT: yfit            fitted values
%        b               parameters of the fitted curve
%
%EXAMPLE:
%
%    x = [1 2.1 3.3 4.7];
%    y = [1 1.9 2.6 2.7];
%    model = 'b(1)+b(2)*x.^b(4)./(b(3)+x.^b(4))';
%    b0 = [0.5 3 1 1];
%    [yfit,b] = curvefit(model,x,y,b0);

if nargin == 4         % asetetaan oletusarvot otsikoille
    xtitle    = 'x';
    ytitle    = 'y';
    gtitle    = 'x vs. y';
end

if min(size(x)) == 1, x = x(:); end

y     = y(:);              
[n,m] = size(x);
nb    = length(b0);
yest  = zeros(size(y));

tol     = [1.0e-6 1.0e-6 1000]; 
bounds  = zeros(2,nb); ibound = zeros(1,nb);
print   = 0; 
weights = ones(n,1);
bfix    = []; 

[b,ss,ierr] = simflex('nonlinss',b0,tol,bounds,ibound,0.1,print,...
                      x,y,bfix,model,weights,0);

[ss,yfit] = nonlinss(b,x,y,bfix,model,weights,0);

xdata = x;
ydata = y;

xmin = min(x);
xmax = max(x);
x    = linspace(xmin,xmax); % tehdään pisteikkö käyrää varten 
eval(['y = ' model ';'])

 plot(xdata,ydata,'o',x,y)
 legend('observed','fitted curve')
 grid
 xlabel(xtitle)
 ylabel(ytitle)
 title(gtitle)
