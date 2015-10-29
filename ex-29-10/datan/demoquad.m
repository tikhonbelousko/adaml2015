clc
echo on
% keywords: demo
% This demo shows how to use the experimental design function COMPOSIT
% and the response surface functions INTERA, REG, CODE, GRADPATH, PLOTQUAD
% and QUADCANA (see also QUADMAT and QUADEVAL). The problem is to design
% experiments to optimize the yield of chemical reactor with respect
% reaction time (x1) and reactor temperature (x2). The results for
% the experiments are given by reactor model OSIMU.

% First we shall make a central composite design for two variables
% with 5 replicate points at the center of the design

X = composit(2,5);

pause, clc % strike any key to continue!

% and then code it to physical units (minutes and degrees of Celsius)

minmax = [200 100;250 120];
x      = code(X,minmax,-1)

pause, clc % strike any key to continue!

% the order of the experiments should be randomized! For later
% regression let us also code the reordered x (i.e. reorder X).

x = randomiz(x); X = code(x,minmax,1);

pause, clc % strike any key to continue!

% and then the results of the experiments

y = osimu(x)

pause, clc % strike any key to continue!

% Let's calculate the experimental error from the replicates
% ( the center points [0 0])

i = find(X(:,1)==0 & X(:,2)==0); err=std(y(i)) % err has 4 degrees of freedom!

% and then a second degree response surface model by REG.  Remember
% always to use coded variables with second degree models! INTERA takes
% care for the interactions and quadratic terms. If you want see the
% order of the terms (and coefficients) type

% [XX,terms] = intera(X); disp(terms)

pause, clc % strike any key to continue!

[bcoef,yest,stp,res]=regres(intera(X),y,[err 4]); % PLEASE WAIT!

% the coefficients and their standard deviations, t- and p-values

[bcoef stp]

pause, clc % strike any key to continue!

% and the standard error of the residuals (calculated by the
% formula s^2 = SSE/(n-p)) vs. experimental error & r-squared

n = length(y); s = sqrt(sum(res.^2)/(n-6));
disp([s err r2(y,yest)])

% Since 's' is clearly larger than 'err', lack of fit is evident
% even if the coefficient of determination, r-squared, is high.
% We can try if log tranforms gives any improvement

logy = log(y);

pause, clc % strike any key to continue!

% Let's calculate the experimental error for log(y) from the replicates
% ( the center points [0 0])

i = find(X(:,1)==0 & X(:,2)==0); err=std(log(y(i)))

% and then a second degree response for log(y) surface model by REG.

pause, clc % strike any key to continue!

[bcoef,logyest,stp,res]=regres(intera(X),logy,[err 4],[],[],[],1,1); % PLEASE WAIT!

% the coefficients and their standard deviations, t- and p-values

[bcoef stp]

pause, clc % strike any key to continue!

% and the standard error of the residuals vs. experimental error
% & r-squared

n = length(y); s = sqrt(sum(res.^2)/(n-6));
disp([s err r2(logy,logyest)])

% now in most run the standard error of the residuals does not show
% significiant lack of fit! In some cases the log transform might
% not be necessary

pause, clc % strike any key to continue!

% so we are ready to predict a path to the optimum; it will take some
% time, PLEASE WAIT! (Note that we code the Path back to physical units
% which may cause the path not look like gradient path. This is due to
% the fact that gradients are not scale invariant)

[Path,ypath,sy]=gradpath(bcoef,[0 0],.2,20); path = code(Path,minmax,-1);

% let's plot the path with the estimated surface
% there will two overlayed plots, PLEASE WAIT!

pause(9), echo off
plot(path(:,1),path(:,2),'*',x(:,1),x(:,2),'o')
hold on
limits = axis;
t='exp. design (o), grad. path (*) and the est. surface (lines)';
plotq(bcoef,minmax,[],[],[],[142 105;112 104],10:10:70,[],1);
title(t),xlabel('time [min]'), ylabel('temperature [C]')
pause
clc
hold off, echo on

% If we have more than two variables it is not possible to utilize the
% graphical interpretations anymore. What we can always do, is the so
% called canonical analysis of the response surface which tells us
% the most important features of the response surface at hand. See
% 'Box, Hunter, Hunter: Statistics for Experimenters, Wiley 1978'
% for more details.

[b0can,bcan,Bcan,T,Xs,ys] = quadcana(bcoef);

pause, clc % strike any key to continue!

% coefficients of canonical equation
% y=b0can + b1can*X1can + b2can*X2can + B1can*X1can^2 + B2can*X2can^2

[b0can bcan' Bcan']

% As we can see, the first Bcan is small related to the first one, yet both
% bcan are quite large; these are symptoms of a ridge! Some runs of this
% demo produce surfaces with a saddle point and some surfaces with a maximum.
% The true surface has a maximum and the described phenomenon is quite
% natural even with a small experimental error when the design center is
% far from the maximum point. The user is suggested to try to find the
% maximum by doing some of the experiments along the gradient path
% and then with a new composite design using the best point of the
% gradient path as a new design center

pause, clc % strike any key to continue!

% The stationary point is quite far from the center of design; this
% means that after climbing few steps along the gradient path we
% have to make a new composite design for a more accurate location
% of the optimum. In some runs 'xs' is a saddle point and thus in
% direction opposite to maximum!

[Xs exp(ys)]  %  Rememember that our model was for log(y)!

pause, clc % strike any key to continue!

% Now let us make an experiment at the best point of the gradient
% path

[ymax imax] = max(ypath);
y1          = osimu(path(imax,:));
disp([exp(ymax) y1])

% Since we made quite an improvement let us extrapolate still further
% along the ridge. The gradient along the ridge is approximately
% constant so that  we can check the ridge points by differencing
% the path. For the constant part the second derivative is zero
% and thus the second differences are approximately zero.

pause % strike any key to continue
clc

dp   = diff(Path); ddp = diff(dp); i = find(sum(abs(ddp')) < 1.0e-4);
grad = mean(dp(i,:))

% Due to the random variation in this demo the above procedure
% may need other tolerance than 1.0e-4 above. Just to make sure
% that the subsequent code works we take

grad = mean(dp(11:15,:)) % which by experience are on the ridge.

pause % strike any key to continue
clc

%    Let us make six more experiments along the ridge with step size 1

X1 = Path(imax,:) + 1*grad/norm(grad);
X2 = Path(imax,:) + 2*grad/norm(grad);
X3 = Path(imax,:) + 3*grad/norm(grad);
X4 = Path(imax,:) + 4*grad/norm(grad);
X5 = Path(imax,:) + 5*grad/norm(grad);
X6 = Path(imax,:) + 6*grad/norm(grad);

pause % strike any key to continue
clc

Xnew = [X1;X2;X3;X4;X5;X6];
xnew = code(Xnew,minmax,-1);
ynew = osimu(xnew);
disp([xnew ynew])

%   Now we have found the maximum point on the (estimated!) ridge.
%   This actually very near the true optimum, but the user may wish
%   verify this by making a new composite design with the best point
%   as the center of this design.


