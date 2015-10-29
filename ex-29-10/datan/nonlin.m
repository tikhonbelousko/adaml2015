function [yfit,b,stp,R,C,J] = nonlin(model,x,y,b0,bfix,tol,bounds,print,weights)
% keywords: nonlinear regression, modelling
% call:   [yfit,b,stp,C,R,J] = nonlin(model,x,y,b0,bfix,tol,bounds,print,weights)
% The function minimizes the (weighted) residual 'y - model' sum of squares with
% with respect to the parameters 'b' using the Toolbox version of the Nelder-Mead
% algorithm (SIMFLEX).
% 
% INPUT:  model       string containing name of the user-supplied model,
%                     given as a m-file function with the call
%                           ypred = model(x,b)
%         x           matrix of the independent experimental (control)
%                     variables, given as columns of 'x'.
%         y           the response matrix
%         b0          the initial guess for the parameters 'b' to be fitted
%         bfix        parameters/constants of the model not fitted. OPTIONAL
%
%         tol  = [reltol abstol maxiter]
%  
%                     the stopping criteria: relative tolerance, absolute tolerance,
%                     max number of iteration. OPTIONAL, default 
%                     tol = [1.0e-6 1.0e-6 1000] 
%         bounds      bounds(1,:) <--> lower bounds for b
%                     bounds(2,:) <--> upper bounds for b
%                     OPTIONAL. Default: no bounds.
%         print       printing option. monitore progress at each print'th
%                     iteration (print = 0:  no print, ). 
%                     OPTIONAL. Default print = 10
%         weights     the weight matrix of the same size as 'y'. OPTIONAL,
%                     default:  weights = ones(size(y)).
% OUTPUT  yfit        the fitted response values
%         b           the estimated parameters
%         stp         the s,t, and p values of the parameters. See REGRES.
%         R           the correlation matrix of the parameters
%         C           the covariance matrix of the parameters
%         J           the Jacobian matrix of the model

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

 [n,m]  = size(x);
 nb     = length(b0);
 yfit   = zeros(size(y));
 ibound = 2*ones(1,nb);

 if nargin == 8,
   weights = ones(size(y));
 elseif nargin == 7,
  weights = ones(size(y));  print = 10;
 elseif nargin == 6,
  weights = ones(size(y));  ibound = zeros(1,nb); print = 10;
  bounds  = zeros(2,nb);
 elseif nargin == 5,
  weights = ones(size(y));  ibound = zeros(1,nb); print = 10;
  bounds  = zeros(2,nb);    tol     = [1.0e-6 1.0e-6 100];
 elseif nargin == 4,
  weights = ones(size(y));  ibound = zeros(1,nb); print = 10;
  bounds  = zeros(2,nb);    tol     = [1.0e-6 1.0e-6 100]; bfix    = [];
 elseif nargin < 4
  error('too few input parameters for NONLIN');
 end

 if length(print)  == 0, print = 10; end
 if length(bounds) == 0, bounds = zeros(2,nb); ibound = zeros(1,nb); end
 if length(tol)    == 0, tol = [1e-6 1e-6 100]; end;
 if length(bfix)   == 0, bfix = []; end;

 sizes       =  0.1;
 [b,ss,ierr] = simflex('nonlinss',b0,tol,bounds,ibound,sizes,print,...
                        x,y,bfix,model,weights);
 [ss,yfit]   = nonlinss(b,x,y,bfix,model,weights);

 if nargout > 2

  db     = 1e-6;
  J      = jacob('nonljac',x,b,db,bfix,model,weights);
  stdres = std(y(:)-yfit(:));
  invjac = inv(J'*J);
  C      = stdres*invjac;
  R      = corrcov(C);
  s      = sqrt(diag(C));
  t      = b./s;
%  keyboard
  p      = 1 - distt(abs(t),n-nb);
  stp    = [s t p];

 end
