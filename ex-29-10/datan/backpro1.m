  function [w,res,ssr] = backpro1(x,y,niter,w,tol,muu,alfa)
% keywords: neural networks, backpropagation
% call: [w,res,ssr] = backpro1(x,y,niter,w,tol,muu,alfa)
% The function computes, using the backpropagation algorithm, the weight
% matrix for a neural network with one output layer with the logistic
% link function.
% INPUT      x      the input training matrix
%            y      the output training matrix.
%                   NOTE: 'y' must be scaled to be between 0 and 1, cf
%                   INITLAY1
%            niter  the maximum n of iterations. OPTIONAL, default niter=3000
%            w      initial guess of the weight matrix. The last row of 'w'
%                   gives the bias. OPTIONAL, random numbers as default.
%            tol    the stopping criteria parameter. OPTIONAL,
%                   default tol = .001
%            muu    the 'learning rate' parameter. OPTIONAL, default muu =.25
%            alfa   the 'momentum' parameter. OPTIONAL, default alfa =.9
% OUTPUT     w      the weight matrix for the network
%            res    the residuals at each iteration
%            ssr    the squared sum of residuals

 [m,n]   = size(x);
 [mm,nn] = size(y); if nn==1, y = y(:); end

 if nargin < 7, alfa = 0.9;  end
 if nargin < 6, alfa = 0.9; muu = 0.25; end
 if nargin < 5, alfa = 0.9; muu = 0.25; tol = 0.001; end
 if nargin < 4, alfa = 0.9; muu = 0.25; tol = 0.001;
                rand('uniform'); w = (rand(n+1,nn)-0.5)/100; end
 if nargin < 3, alfa = 0.9; muu = 0.25; tol = 0.001;
                rand('uniform'); w = (rand(n+1,nn)-0.5)/100;
                niter = 3000; end
 if length(muu)==0, muu=0.25; end
 if length(tol)==0, tol=0.001;end
 if length(w)==0, rand('uniform'); w = (rand(n+1,nn)-0.5)/100; end
 if length(niter)==0, niter = 3000; end

 wold = w;
 rand('uniform');
 yy = predn1(w,x); res = y-yy; 

 for ii=1:niter
    i  = rem(ii-1,m)+1;
    xx = x(i,:);  xx1 = [xx 1];
    d  = y(i,:);
    z  = xx1 * w;
    z  = ones(1:nn)./(1 + exp(-z));
    e  = d - z;                    %the residual 'y - y_est'
    res(i)  = e;
    ssr(ii) = sum(res.^2);

    disp(ssr(ii))

    if ii > m & ssr(ii) < tol
       fprintf('\n %6.0f iterations,ssr= %6.4f \n',ii,ssr(ii));
       return;
    end

    edlogit = e.*z.*(1-z);
    wnew    = w + muu * xx1' * edlogit + alfa * (w - wold);
    wold    = w;
    w       = wnew;
 end
 
