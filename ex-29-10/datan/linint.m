 function y=linint(xd,yd,x)
% keywords: interpolation, extrapolation
% call: y=linint(xd,yd,x)
% INPUT:        xd   abscissae of the data points
%               yd   ordinates of the data points
%               x    abscissae of the evaluation points
% OUTPUT        y    interpolated values at x

nd   = length(xd); [n,m] = size(x); k11 = [];
y    = zeros(n,m);
imax = find(xd==max(xd));
imin = find(xd==min(xd));

if imax < imin
    xd = fliplr(xd);
    yd = fliplr(yd);
    x  = fliplr(x);
end

j  = find(x<=xd(1));
if length(j)>0
   y(j)=yd(1)+(yd(2)-yd(1))/(xd(2)-xd(1))*(x(j)-xd(1));
end

k1 = find(xd <= min(x));
k2 = find(xd >= max(x));

if length(k1) == 0
  k1 = 1;
else
  k1 = k1(length(k1));
end

if length(k2) == 0
  k2 = nd;
else
  k2 = k2(1);
end

if k1<k2
   k11=k1+1;
elseif k1==k2
   k11=k1;
end
if k11==1, k11=k11+1; end

for i=k11:k2
   if xd(i)>xd(i-1)
       j=find(x>=xd(i-1) & x<=xd(i));
       y(j)=yd(i-1)+(yd(i)-yd(i-1))/(xd(i)-xd(i-1))*(x(j)-xd(i-1));
   end
end

j=find(x>=xd(nd));

if length(j)>0
   y(j)=yd(nd-1)+(yd(nd)-yd(nd-1))/(xd(nd)-xd(nd-1))*(x(j)-xd(nd-1));
end
