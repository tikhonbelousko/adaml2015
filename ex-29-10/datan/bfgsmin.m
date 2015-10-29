function [xmin,fmin,iter,evs] = bfgsmin(fun,x,dfun,tol,dstep,iters,flim,print,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10);
% keywords: optimization, gradient based, BFGS-algorithm
% call [xmin,fmin,iter,evs] = bfgsmin(fun,x,dfun,tol,dstep,iters,flim,print,P1,P2,P3,P4,P5,P6,P7,P8,P9,P10)
% minimizes a function of several variables; uses the BFGS-algorithm
% INPUT:
%        fun       the function to be minimized; to be given as a string
%        x         the starting value
%        dfun      the function computing the gradient vector of the function
%                  to be minimized; to be given as a string. Set
%                  dfun = [] if numerical derivatives are to be used.
%                  OPTIONAL, default dfun = [].
%        tol       the absolute convergence tolerance
%                  OPTIONAL, default tol = 1e-8.
%        dstep     the step length for numerical derivation
%                  OPTIONAL, default: step = 1e-6
%        iters     the maximum number of evaluations/iterations
%                  usage: iter = [itmax]: the max.number for both
%                         the function evaluations and iterations.
%                         iter = [itmax, evmax]: separate max values
%                         for iterations and evaluations
%                  OPTIONAL, default: iters = 1000
%        flim      lower bound on the function to be minimized
%                  OPTIONAL, default: flim = 0;
%        print     the printing option (0 = no printing, 1 = printing on)
%                  OPTIONAL, default: print = 1.
%        P1...P10  additional parameters for the function;
%                  there can be up to 10 of these.
%
% OUTPUT:
%        xmin      the point where the minimum is reached
%        fmin      the minimum value of the objective function
%        iter      the number of iterations done
%        evs       the number of function evaluations done

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

xmin   = x(:);        % let's take the current minimum

if nargin == 7
     print = 1;
elseif nargin == 6
     print = 1; flim = 0;
elseif nargin == 5
     print = 1; flim = 0; iters = 1000;
elseif nargin == 4
     print = 1; flim = 0; iters = 1000; dstep = 1e-6;
elseif nargin == 3
     print = 1; flim = 0; iters = 1000; dstep = 1e-6; tol = 1e-8;
elseif nargin == 2
     print = 1; flim = 0; iters = 1000; dstep = 1e-6; tol = 1e-8; dfun = [];
elseif nargin < 2
     error('not enough input arguments!!');
end

if length(print) == 0, print = 1;    end
if length(flim)  == 0, flim  = 0;    end
if length(iters) == 0, iters = 1000; end
if length(dstep)  == 0, dstep  = 1e-6; end
if length(tol)   == 0, tol   = 1e-8; end

n      = length(x);
toli   = tol;         % convergence tolrance

if length(iters) == 2
     itmax = iters(1);
     evmax = iters(2);
else
     itmax = iters;
     evmax = iters;
end

phi = 0.01; sigma = 0.9; tau1 = 9; tau2 = 0.05; tau3 = 0.5;
% parameters for line search

if nargin > 8
    evalstr = [fun '(x'];
    for i = 9:nargin
         evalstr = [evalstr ',P' int2str(i-8)];
    end
    evalstr = [evalstr ')'];
else
    evalstr = [fun '(x)'];
end

f = eval(evalstr); f0 = f;

if nargin > 8 & length(dfun) > 0
    evalstr2 = [dfun '(x'];
    for i = 9:nargin
         evalstr2 = [evalstr2 ',P' int2str(i-8)];
    end
    evalstr2 = [evalstr2 ')'];
else
    evalstr2 = [dfun '(x)'];
end

evs = 0;
if length(dfun) > 0
     grad = eval(evalstr2);
else
     grad = zeros(n,1);
     oldx = x(:);
     for i = 1:n
          ddstep = zeros(n,1); ddstep(i) = dstep;
          x = oldx + ddstep; f1 = eval(evalstr);
          grad(i) = (f1-f)/ddstep(i);
          evs = evs+1;
     end
     x = oldx;
end

grad  = grad(:);
grad0 = grad;

if print == 1
    disp(' ');
    disp('ITERS EVALS       FUNCTION');
end

hess     = eye(n);      % the initial hessian matrix
h        = -hess*grad;  % the initial search direction
df0      = grad'*h;
oldslope = df0;
myy      = (flim-f0)/(phi*df0);

status = 0;
%evs    = 1;
iter   = 0;
lam    = 1;
a = []; b = [];

while (status ~=1) & (evs <= evmax) & (iter <= itmax)
% -------------  START OF THE MAIN LOOP ------------------------------
     iter = iter+1;
     if print == 1
         disp([sprintf('% 5.0f %5.0f %12.6g',iter,evs,f)]);
     end
     fold = f0;
     prelam = 0;
     if iter > 1
          diff = max(f00 -f0,10*toli);
          lam = min(1,-2*diff/df0);
     end
     vali = zeros(2,1); stat1 = 0; stat2 = 0;
     % -------  LINE SEARCH BEGINS ------------------
     while stat1 ~= 1
          x = xmin+lam*h;
          f = eval(evalstr); evs = evs +1;
          if length(dfun) > 0
              grad = eval(evalstr2);
          else
              grad = zeros(n,1);
              oldx = x;
              for i = 1:n
                   ddstep = zeros(n,1); ddstep(i) = dstep;
                   x = oldx + ddstep; f1 = eval(evalstr);
                   grad(i) = (f1-f)/ddstep(i);
                   evs = evs+1;
              end
              x = oldx;
          end

          grad  = grad(:);
          slope = grad'*h;
          if f <= flim
               stat1=1; stat2 = 1;
          elseif (f > f0+lam*phi*df0) | (f >= fold)
               a = prelam; b= lam; stat1=1;
          else
               if slope >= sigma*df0
                    stat1=1; stat2= 1;
               elseif slope >= 0
                    a     = lam; b=prelam;
                    apu   = fold; fold= f; f= apu;
                    apu   = oldslope; oldslope = slope; slope = apu;
                    stat1 = 1;
               else
                    if myy <= 2*lam - prelam
                         prelam = lam;
                         lam    = myy;
                    else
                         step    = lam - prelam;
                         vali(1) = 2*lam-prelam;
                         vali(1) = (vali(1)-prelam)/step;
                         vali(2) = min(myy,lam+tau1*(lam-prelam));
                         vali(2) = (vali(2)-prelam)/step;
                         lmin    = cubmin(f,fold,slope,oldslope,step,vali(1),vali(2));
                         lamnew  = prelam+lmin*step;
                         prelam  = lam; lam = lamnew;
                    end
                    fold = f; oldslope = slope;
               end
          end
     end % of while stat1
     % at this point we should have a bracket [a,b]

     if abs(b-a) <= toli
          stat2 = 1;
     end

     disp('stat2')
    
     while stat2 ~= 1
          step    = b-a;
          vali(1) = a + tau2*step;
          vali(1) = (vali(1)-a)/step;
          vali(2) = b - tau3*step;
          vali(2) = (vali(2)-a)/step;
          lamin   = cubmin(f,fold,slope,oldslope,step,vali(1),vali(2));
          lam     = a+lamin*step;
          fb      = f; slob = slope;
          x       = xmin + lam*h; f = eval(evalstr); evs = evs+1;
          if length(dfun) > 0
              grad = eval(evalstr2);
          else
              grad = zeros(n,1);
              oldx = x;
              for i = 1:n
                   ddstep = zeros(n,1); ddstep(i) = dstep;
                   x = oldx + ddstep; f1 = eval(evalstr);
                   grad(i) = (f1-f)/ddstep(i);
                   evs = evs+1;
              end
              x = oldx;
          end

          grad  = grad(:);
          slope = grad'*h;
          if abs((a-lam)*oldslope) <= toli
               stat2 = 1;
          elseif (f > f0+phi*lam*df0) | (f >= fold)
               b = lam;
          else
               if slope >= sigma*df0
                    stat2 = 1;
               else
                    aold = a;
                    a    = lam;
                    if (b-aold)*slope < 0
                         fold = f; oldslope = slope;
                         f    = fb; slope = slob;
                    else
                         b   = aold;
                         apu = fold; fold = f; f = apu;
                         apu = oldslope; oldslope = slope; slope = apu;
                    end
               end
          end
     disp('end stat2');

     end % of while stat2

     % -------- LINE SEARCH COMPLETED -------------------------

     dix = x - xmin;
     xmin = x;
     if (abs(f0-f) <= toli)
          status = 1;
     end
     if status ~= 1
          f00 = f0;
          f0 = f;
          dg = grad0;
          dg = grad -dg;
          hdg = hess*dg;
          fac = dg'*dix;
          fae = dg'*hdg;
          fac = 1/fac; fad = 1/fae;
          dg = fac*dix - fad*hdg;
          hess = hess + fac*dix*dix' - fad*hdg*hdg' + fae*dg*dg';
          h = -hess*grad;
          df0 = grad'*h;
          grad0 = grad;
     end
end % ------------- THE END OF THE MAIN LOOP ----------------------------

if print == 1
     disp([sprintf('% 5.0f %5.0f %12.6g',iter,evs,f)]);
end

if evs > evmax
     disp('maximum number of evaluations exceeded');
end

if iter > itmax
     disp('maximum number of iterations exceeded')
end
 
x = xmin;
fmin = eval(evalstr);

