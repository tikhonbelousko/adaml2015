  function plotcont(F,limits,zlevels,ltype,vecopt)
% keywords: contour plot
% call: plotcont(F,limits,zlevels,ltype,vecopt)
% The function plots a contourplot of F(x,y) on a given square.
% If F is vectorized vecopt must be 1
%
% INPUT:
%
%      F        a string that gives the name of the function to be plotted
%      limits   a vector of length 4 with [xmin, xmax, ymin, ymax]
%      zlevels  number of contour lines or a vector of contour levels
%      ltype    line type  and color
%               OPTIONAL, DEFAULT = 'g-'
%      vecopt   1 for vectorized functions
%               2 computes the grid column by column
%               0 otherwise
%               (OPTIONAL, DEFAULT = 1)

if nargin < 5, vecopt = 1; end
if nargin < 4, vecopt = 1; ltype = 'g-'; end
if length(ltype) == 0; ltype = 'g-'; end 

xmin = limits(1);
xmax = limits(2);
ymin = limits(3);
ymax = limits(4);

xstep = (xmax-xmin)/50;
ystep = (ymax-ymin)/50;

xaxis = xmin:xstep:xmax;
yaxis = ymin:ystep:ymax;

[x y] = meshgrid(xaxis,yaxis);
[n,m ]= size(x);

if vecopt==1

    z=feval(F, x, y);

elseif vecopt==2

    for j=1:m
        z(:,j)=feval(F, x(:,j), y(:,j));
    end

else

    for i=1:n
       for j=1:m

          z(i,j)=feval(F, x(i,j), y(i,j));

       end
    end

 end
 %keyboard

cs=contour(xaxis,yaxis,z,zlevels,ltype); clabel(cs)

