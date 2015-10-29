  function dg = drosen(x)
% keywords: demo
% call: dg = drosen(x);
% The derivative of the Rosenbrock objective function.

dg1 =  -(400*x(1)*(x(2)-x(1)^2)+2*(1-x(1)));
dg2 =  200*(x(2)-x(1)^2);
dg  =  [dg1;dg2];
