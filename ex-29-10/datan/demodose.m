echo on
clc
% keywords: demo
% In this example we study a dose-response data, taken from A.J.
% Dobson: An Introduction to Statistical Modeling, Chapman & Hall, -83.
%
% In fact, this problem belongs to the realm of nonlinear parameter
% estimation. However, we are able to study the case using only linear
% and graphical tools. Also, the example points out some pitfalls of
% traditional ways of considering nonlinear estimation.


pause, clc % strike any key to continue ...

% In a series of experiments, beetles were exposed to different doses
% of gaseous carbon disulphide. Below is the mortality data,

beetle = [1.6900   59.0000    6.0000
          1.7240   60.0000   13.0000
          1.7550   62.0000   18.0000
          1.7840   56.0000   28.0000
          1.8110   63.0000   52.0000
          1.8370   59.0000   53.0000
          1.8610   62.0000   61.0000
          1.8840   60.0000   60.0000];
%
% The first column gives the dosage 'd', the second the number 'no' of
% beetles in each experiment, the third the number 'r' of killed insects,

 d  = beetle(:,1);  no = beetle(:,2);  r  = beetle(:,3);

% The outcome of each experiment is a binary variable: either there is
% a response to the dose (i.e., death), or not. The aim is to model the
% probability of response at each level of the dose. To get an idea of the
% effect of the dose, let us plot the proportions 'r/n' against 'd':

pause, clc % strike any key to continue ...

echo off; clc

p = r./no;
plot(d,p,'*');
title('Beetle mortality proportions');
xlabel('Dose (on log scale)'): ylabel('probab.of response');
pause

echo on
%
% The points seem to obey a S-shaped behaviour. To model such data, the
% logistic function f(x) = 1/(1 + exp(-x)) is often used, cf the plot

pause, clc % strike any key to continue ...
 echo off
 x = -6:.2:6;
 plot(x,oneg(x)./(1 + exp(-x)));
 title(' the logistic function 1/(1 + exp(-x)) ')
 pause

 echo on

% We fit the logistic function to the data, using two different
% parametrizations.  We first try the model
%
%     p = 1 / (1 + exp(-alfa - beta * d)).
%
% Here 'd' denotes the dose, 'p' the probability of response. We have
% to find 'alfa' and 'beta' for which 'p' follows the observed values
% of 'r/n'.
%
% An easy calculation shows that log(p/(1-p) = alfa + beta*d. Here we
% have a linear equation for 'alfa' and 'beta'. Values for 'alfa' and
% 'beta' are now obtained by a least squares fit

pause, clc % strike any key to continue ...

 pp = p(1:7); dd = d(1:7);
 yy = log(pp./(1-pp));

%(we omit the last data point where p = 1)

 ab = [ones(7,1) dd] \ yy

% Let us next plot the data and the fitted curve on the interval [1.5, 2]
 pause, clc % strike any key to continue ...


 echo off
 x = 1.5:.025:2;
 plot(x,oneg(x)./(1 + exp(-ab(1) - ab(2)*x)), d,p,'*')
 title(' the data points (*) versus values given by the model (-)')
 pause

 echo on

% The fit seems not too bad. However, some questions remain: is it OK to
% compute a fit only, or should we do some more analysis ? How good is the
% fit so obtained? In fact, the parameter values found are not the 'correct'
% maximum likelihood points, and there might be other points which also
% give a good fit. To see this, we compute the likelihood function (for more
% details about likelihood functions of binary response models, see e.g.
% the reference given at the beginning of this demo) for 'alfa' and 'beta'
% in a grid of points, using the function DOSELOG.
%
% Below are the corner points of the grid. The grid itself is computed
% by dividing the 'alfa' and 'beta' intervals in 40 parts:

 alfa  = [-71, -51];
 beta  = [28 41];
 ido = 1;
 pack;

% wait ...

 [F,Fmax,vmax,aaxis,baxis] = doselog(no,r,d,alfa,beta,ido,50);
 F = F/Fmax;


 pause, clc % strike any key to continue ...

 echo off, clc
 vers=abs(version); vers = vers(1);
 if vers<53
  c = contour(F,5,aaxis,baxis);
 else
  c = contour(aaxis,baxis,F,5);
 end

 title(' the contour plot of possible parameter values')
 xlabel('alfa'); ylabel(' beta')
 pause,% clc % strike any key to continue ...
 pack

 echo on
%
%We can see that the values of the parameters are strongly correlated:
%all values in a long and narrow region give a fit roughly as good as
%the 'optimal' one (note that the isolated parts of the plot are only
%graphical artifacts caused by the function CONTOUR & the coarse grid
%of data points).
%
%We may pick up all pairs (alfa,beta) where the value of the likelihood
%function is between 1/10, 1/5 of the maximum value, and plot the response
%curve 'p versus d' for such pairs (for details, see this demo file)
%

 pause, clc % strike any key to continue ...

  echo off
  ii = find(c(1,:)>0.09 & c(1,:)<0.2);
  teta = [];
  for i = 1:length(ii)
      teta = [teta c(:,ii(i)+1 :15: ii(i) + c(2,ii(i)))];
  end

  clear pp
  n = max(size(teta));
  for i = 1:n
     pp(i,:) = oneg(x)./(1 + exp(-teta(1,i) - x*teta(2,i)));
  end

 plot(x,pp,'-',d,p,'*')
 title(' data vs response curves for some possible parameter values')
% plot(x,oneg(x)./(1 + exp(-ab(1) - ab(2)*x)),'--', d,p,'*')


% plot(x,oneg(x)./(1 + exp(-ab(1) - ab(2)*x)),'--', d,p,'*')

 pause
 pack

 echo on
%We may relate the 'confidence region' given by the contours of the
%likelihood function, and the more traditionally used 'confidence
%intervals' for individual parameters.
%
%The standard errors of 'alfa' and 'beta', given by the variance-
%covariance matrix of the model (see Dobson: An Introduction to
%Statistical Modelling, p. 79) have values 5.19 and
%2.91, respectively. The 95% confidence intervals, roughly
%[-61 - 1.96*5.18 -61 + 1.96*5.18], [34 - 1.96*2.91,34 + 1.96*2.91],
%are plotted below together with the contours of the likelihood function

 pause, clc % strike any key to continue ...
 echo off

 ab2 = [-63 -59; 32 36];
 x1  = [-71.15 -50.85];
 yy  = [28.3  28.3; 39.7 39.7];
 xx1 = [x1(1) x1(1)]; xx2 = [x1(2) x1(2)]; y1 = [28.3 39.7];
 plot(x1,yy(1,:),x1,yy(2,:),'-',xx1,y1,xx2,y1,'-',ab2(1,:),ab2(2,:),'*')
 hold

 if vers<53
    contour(F,5,aaxis,baxis);
 else
    contour(aaxis,baxis,F,5);
 end

 title('the contours of likelihood function & the 95% confidence box')
 xlabel(' *: Example points inside the confidence box, outside the contours')
 pause, hold off
 echo on

%Most of the points inside the box determined by the confidence
%intervals are in fact outside the region given by the contours of
%the likelihood function, and so incorrect for the model.
%
%As an example, let us plot the models given by the parameter values
%demoted as '*' in the previous picture:
%

pause, clc % strike any key to continue ...

 echo off
 y = [oneg(x)./(1 + exp(-ab2(1,1) - ab2(2,1)*x))
      oneg(x)./(1 + exp(-ab2(1,2) - ab2(2,2)*x))];

 plot(x,y,'-',d,p,'*');

 pause, clc
 echo on
%Even if the points are not far from the center of the confidence box,
%the models are fatally incorrect.
%
%Next we employ another formulation for the problem. The model is stated
%using parameters which have a natural interpretation  - and nice
%likelihood contours.
%
%The ED50 (Effective Dose) value is defined as the amount of the dose
%which gives a 'positive' (here: death) response in half of the
%experiments. In other words, the ED50 value, demoted by 'muu', is the
%dose for which p(muu) = 0.5. The parameters 'alfa' and 'beta' are
%are replaced by the new ones as
%
%                        d - muu
%     alfa + beta*d ---> -------   (i.e., alfa = -muu/sigma, beta = 1/sigma)
%                         sigma
%
%The parameter 'sigma' might be interpreted as the standard error of
%'muu'.

pause, clc % strike any key to continue ...
%
%Let us now plot the likelihood contours, using the new parametrization:
%
 ido = 2;
 muu   = [1.75 1.79];
 sigma = [0.020 0.04];

% wait ....
 [F,Fmax,vmax,maxis,saxis] = doselog(no,r,d,muu,sigma,ido);
 F = F/Fmax;

 echo off
 if vers<53
   c = contour(F,5,maxis,saxis); clabel(c);
 else
   c = contour(maxis,saxis,F,5); clabel(c);
 end

 title(' Likelihood contours with the ED50 parametrization')
 xlabel(' muu (the ED50 parameter)')
 ylabel(' sigma ')
 pause, clc
 pack
 echo on

%Again, we may find (for instance, every fifth of) the contour points
%at some of the levels labeled, e.g., by the value 0.1667:

  ii = find(c(1,:) > 0.1 & c(1,:) < 0.2);
  teta = [];
  for i = 1:length(ii)
      teta = [teta c(:,ii(i)+1 :8: ii(i) + c(2,ii(i)))];
  end

% ... and plot the models corresponding to these values:

 echo off
 pack , clear pp
 n = max(size(teta));
 for i = 1:n
     pp(i,:) = oneg(x)./(1 + exp((teta(1,i) - x)/teta(2,i)));
 end
 plot(x,pp,'-',d,p,'*');
