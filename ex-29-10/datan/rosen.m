function y = rosen(x)
% keywords: demo
% call: y = rosen(x);
% The Rosenbrock objective function for optimization.

y = (100*(x(2)-x(1)^2)^2+(1-x(1))^2);
