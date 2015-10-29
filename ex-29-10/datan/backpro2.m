  function [w1,w2,res,ssr,ress,iii] = backpro2(x,y,niter,w1,w2,tol,muu,alfa)
% keywords: neural networks, backpropagation
% call: [w1,w2,res,ssr] = backpro2(x,y,niter,w1,w2,tol,muu,alfa)
% The function computes, using the backpropagation algorithm, the weight
% matrixes for a neural network with one hidden layer and the output layer
% INPUT      x      the input training matrix
%           y      the output training matrix
%                  NOTE: 'y' must be scaled to be between 0 and 1, cf
%                  INITLAY2
%           niter  the maximum n of iterations.OPTIONAL, default niter=3000
%           w1     1) a matrix: initial guess of the weight matrix for the
%                     hidden layer. The last row of 'w1' gives the bias.
%                  2) scalar: the n of hidden layers. The weights
%                     initialized as random numbers.
%           w2     initial guess of the weight matrix for the second
%                  layer. The last row of 'w2' gives the bias. OPTIONAL,
%                  not needed if 'w1' given as in case 2).
%           tol    the stopping criteria parameter.OPTIONAL,default tol = .001
%           muu    the 'learning rate' parameter. OPTIONAL, default muu =.25
%           alfa   the 'momentum' parameter. OPTIONAL, default alfa =.9
% OUTPUT     w1     the weight matrix for the 1. network
%            w2     the weight matrix for the 2. network
%            res    the residuals at each iteration
%            ssr    the squared sum of residuals

 [m,n]   = size(x);
 [my,ny] = size(y); if ny==1, y = y(:); end
 [mw,nw] = size(w1); maxw = max(mw,nw);
 if maxw==1,
    dim = w1;
 else
    dim = nw;
 end

 if nargin < 8, alfa = 0.9;  end
 if nargin < 7, alfa = 0.9; muu = 0.25; end
 if nargin < 6, alfa = 0.9; muu = 0.25; tol = 0.001; end
 if nargin < 5, alfa = 0.9; muu = 0.25; tol = 0.001;
                rand('uniform'); w2=(rand(dim+1,ny)-0.5)/10;
                   if maxw==1
                                w1=(rand(n+1,dim)-0.5)/10;
                   end
 end
 if length(muu)==0, muu=0.25; end
 if length(tol)==0, tol=0.001;end
 if length(w2) ==0, rand('uniform'); w2=(rand(dim+1,ny)-0.5)/10; end
 if length(niter)==0, niter = 3000; end

 w2old = w2; w1old = w1;
 yy = predn2(w1,w2,x); res = y - yy;
% plot(res), pause
% i = 1:150; plot(i,y,i,yy,'-'), pause

 rand('uniform');
 for ii=1:niter
    i  = rem(ii-1,m)+1;
    xx = x(i,:);  xx1 = [xx 1];
    d  = y(i,:);
    z  = xx1 * w1;
    z  = ones(1:dim)./(1 + exp(-z)); z1 = [z 1];
    z2 = z1 * w2;
    yy = ones(1:ny)./ (1 + exp(-z2));

%    yyy=predn2(w1,w2,xx); [yy yyy] , pause

    e  = d - yy;                    %the residual 'y - y_est'
    e2      = sum(e.^2);
%    disp('normres, resi')
    res(i)  = e2;
    ress(ii)= e2;
    iii(ii) = i;
    ssr(ii) = sum(res);
% [sum(res.^2), e2] ,pause

    if ssr(ii) < tol
       fprintf('\n %6.0f iterations,ssr= %6.4f \n',ii,ssr(ii));
       return;
    end

    edlogit2 = e.*yy.*(1-yy);
    ee       = edlogit2*w2(1:dim,1:ny)';  % backpropagation !
    edlogit1 = ee.*z.*(1-z);

    w2new    = w2 + muu * z1' * edlogit2 + alfa * (w2 - w2old);
    w2old    = w2;
    w2       = w2new;

    w1new    = w1 + muu * xx1' * edlogit1 + alfa * (w1 - w1old);
    w1old    = w1;
    w1       = w1new;

  %disp('i e2 normres_iuusi')
%   yy = predn2(w1,w2,xx); ress = d - yy;[i e2 norm(ress)^2], pause
 end



