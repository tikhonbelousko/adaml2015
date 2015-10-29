function [xmin,fmin,iter,evs] = polrib(fun,x,dfun,tol,iters,flim,print,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10);
% keywords: optimization, gradient based, conjugate gradients
% call: [xmin,fmin,iter,evs] = polrib(fun,x,dfun,tol,iters,flim,print,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)
% minimizes a function of several variables; uses the Polak-Ribiere algorithm
% INPUT:
%        fun       the function to be minimized; to be given as a string
%        x         the starting value
%        dfun      the function computing the gradient vector of the function
%                  to be minimized; to be given as a string
%        tol       the absolute convergence tolerance
%                  OPTIONAL, default: tol = 1e-8;
%        iters     the maximum number of evaluations/iterations
%                  usage: iter = [itmax]: the max.number of both
%                         function evaluations and iterations in the minimizer
%                         iter = [itmax, evmax]: separate values for
%                         iterations and evaluations
%                  OPTIONAL, default: flim = 1000;
%        flim      lower bound on the function to be minimized
%                  OPTIONAL, default: flim = 0;
%        print     the printing option (0 = no printing, 1 = printing on)
%                  OPTIONAL, default: print = 1.
%        P1...P10  additional parameters for the function;
%                  there can up to ten of these
%
% OUTPUT:
%        xmin      the point where the minimum is reached
%        fmin      the minimum value of the objective function
%        iter      the number of iterations done
%        evs       the number of function evaluations done

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

xmin   = x(:);

if nargin == 6
     print = 1;
elseif nargin == 5
     print = 1; flim = 0;
elseif nargin == 4
     print = 1; flim = 0; iters = 1000;
elseif nargin == 3
     print = 1; flim = 0; iters = 1000; tol = 1e-8;
elseif nargin < 3
     error(' not enough input arguments!!');
end

if length(print) == 0, print = 1; end
if length(flim) == 0, flim = 0; end
if length(iters) == 0, iters = 1000; end
if length(tol) == 0, tol = 1e-8; end

toli    = tol;
if length(iters) == 2
     itmax = iters(1);
     evmax = iters(2);
else
     evmax  = iters;
     itmax  = iters;
end

phi    = 0.01; sigma = 0.1; tau1= 9; tau2 = 0.01; tau3 = 0.5;

if nargin > 7
    evalstr = [fun '(x'];
    for i = 8:nargin
         evalstr = [evalstr ',P' int2str(i-7)];
    end
    evalstr = [evalstr ')'];
else
    evalstr = [fun '(x)'];
end

f = eval(evalstr);
f0 = f;

if nargin > 7
    evalstr2 = [dfun '(x'];
    for i = 8:nargin
         evalstr2 = [evalstr2 ',P' int2str(i-7)];
    end
    evalstr2 = [evalstr2 ')'];
else
    evalstr2 = [dfun '(x)'];
end

grad = eval(evalstr2);

if print == 1
    disp(' ');
    disp('ITERS EVALS        FUNCTION');
end

g = -grad;
h = g; % initial search direction
df0 = grad'*h;
oldslope = df0;
myy = (flim-f0)/(phi*df0);

status = 0;
evs    = 1;
iter   = 0;
lam    = 1;

while (status ~=1) & (evs <= evmax) & (iter <= itmax)
     iter = iter +1;
     if print == 1
         disp([sprintf('% 5.0f % 5.0f %15.6g',iter,evs,f)]);
     end
% ---------- LINE SEARCH BEGINS -------------------------------
     fold = f0;
     prelam = 0;
     if iter > 1
          diff = max(f00-f0,10*toli);
          lam = -2*diff/df0;
     end
     vali = zeros(2,1); stat1=0; stat2= 0;
     while stat1 ~= 1
          x = xmin+lam*h;
          f = eval(evalstr); evs = evs +1;
          grad = eval(evalstr2);
          slope = grad'*h;
          if f <= flim
               stat1=1; stat2 = 1;
          elseif (f > f0+lam*phi*df0) | (f >= fold)
               a = prelam; b= lam; stat1=1;
          else
               if abs(slope) <= -sigma*df0
                    stat1=1; stat2= 1;
               elseif slope >= 0
                    a = lam; b=prelam;
                    apu = fold; fold= f; f= apu;
                    apu = oldslope; oldslope = slope; slope = apu;
                    stat1 = 1;
               else
                    if myy <= 2*lam - prelam
                         prelam = lam;
                         lam = myy;
                    else
                         step = lam - prelam;
                         vali(1) = 2*lam-prelam;
                         vali(1)= (vali(1)-prelam)/step;
                         vali(2) = min(myy,lam+tau1*(lam-prelam));
                         vali(2) = (vali(2)-prelam)/step;
                         lmin = cubmin(f,fold,slope,oldslope,step,vali(1),vali(2));
                         lamnew = prelam+lmin*step;
                         prelam = lam; lam = lamnew;
                    end
                    fold = f; oldslope = slope;
               end
          end
     end % of while stat1
     % at this point we should have a bracket [a,b]
     if abs(b-a)<= toli
          stat2 = 1;
     end
     
     while stat2 ~= 1
          step = b-a;
          vali(1) = a + tau2*step;
          vali(1) = (vali(1)-a)/step;
          vali(2) = b - tau3*step;
          vali(2) = (vali(2)-a)/step;
          lamin = cubmin(f,fold,slope,oldslope,step,vali(1),vali(2));
          lam = a+lamin*step;
          fb = f; slob = slope;
          x = xmin + lam*h; f = eval(evalstr); evs = evs+1;
          grad = eval(evalstr2); slope = grad'*h;
          if abs((a-lam)*oldslope) <= toli
               stat2 = 1;
          elseif (f > f0+phi*lam*df0) | (f >= fold)
               b = lam;
          else
               if abs(slope) <= -sigma*df0
                    stat2 = 1;
               else
                    aold = a;
                    a = lam;
                    if (b-aold)*slope < 0
                         fold = f; oldslope = slope;
                         f = fb; slope = slob;
                    else
                         b = aold;
                         apu = fold; fold = f; f = apu;
                         apu = oldslope; oldslope = slope; slope = apu;
                    end
               end
          end
     end % of while stat2
% ------------ LINE SEARCH COMPLETED --------------------------


     delta = f0-f;
     xmin = x;
     if abs(delta) <= toli
         status = 1;
     end
     if status ~= 1
          f00 = f0;
          f0 = f;
          gnew = -grad;
          gam1 = (gnew-g)'*gnew;
          gam2 = g'*g;
          gam = gam1/gam2;
          hnew = gnew + gam*h;
          g = gnew; h = hnew;
          df0 = grad'*h;
     end
end  % of main while

if evs > evmax
     disp('maximum number of evaluations exceeded');
end

if iter > itmax
     disp('maximum number of iterations exceeded');
end

x    = xmin;
fmin = eval(evalstr);

