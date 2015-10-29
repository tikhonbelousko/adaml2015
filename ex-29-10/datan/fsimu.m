  function y = fsimu(x)
% keywords: demo
% call: y = fsimu(x)
% a demonstration function for 'demofrac'

 [m,n] = size(x);
 if n ~= 7
     disp('you must give values for 7 variables')
     break
 end

 inter = [1 1 1 2;1 2 3 3];

 x     = products(x,inter);
 
 b     = [5 -4 4 .1 0 -3 3 -2 6 -6 4]';

 y     = x*b*1.5;
 if length(y) > 1
     y = 50 + y + randng(y);
 else
     y = 50 + y + randng;
 end

% y     = round(y);
 i     = find(y<0);
 if length(i) > 1 
     y(i)  = zerog(i);
 elseif length(i) == 1
     y(i)  = 0;
 end
 i     = find(y>100);
 if length(i) > 1 
     y(i)  = 100*oneg(i);
 elseif length(i) == 1
     y(i)  = 100;
 end
