clc
echo off
% keywords: demo
% the peak times:
data = [
60 10 30 7.015 7.015 7.287 7.444 8.405 8.953 10.188 5.297
50 15 20 6.413 6.413 6.772 7.089 7.985 8.647 10.174 4.480
70 15 20 7.443 7.443 7.794 8.002 9.226 9.917 11.457 5.149
50 15 40 6.769 6.769 7.082 7.264 8.310 8.882 10.095 4.721
70 15 40 7.252 7.252 7.604 7.810 9.015 9.687 11.161 4.966 
60 25 10 6.299 6.299 6.662 7.024 7.818 8.487 10.756 4.684
45 25 30 8.143 8.143 8.715 9.212 10.440 11.283 13.143 4.748
60 25 30 9.427 9.427 10.134 10.770 12.471 13.633 16.433 5.380
60 25 30 9.454 9.454 10.163 10.794 12.500 13.676 16.479 5.393
60 25 30 8.789 8.789 9.439 10.016 11.574 12.650 15.174 4.928
60 25 30 8.595 8.595 9.249 9.830 11.386 12.448 14.976 4.937
60 25 30 8.100 8.100 8.690 9.219 10.622 11.597 13.855 4.653
75 25 30 9.716 9.716 10.470 11.153 13.030 14.363 17.531 5.598
60 25 45 9.749 9.749 10.397 10.899 12.843 13.996 16.638 5.662
50 30 20 8.661 8.902 9.406 10.082 11.103 11.958 13.846 4.422
70 30 20 10.723 11.044 11.800 12.754 14.304 15.633 19.014 5.294
50 30 40 9.102 9.102 9.776 10.354 12.012 13.080 15.407 4.896
70 30 40 10.216 10.216 11.011 11.718 13.834 15.203 18.438 5.397
60 40 30 10.793 11.069 11.849 12.773 14.431 15.633 18.676 4.735];

echo on
%
% DEMOSTEP: a demonstration for stepwise regression by
%           crossvalidation
%
% In stepwise regression the significance of different explanatory
% factors in a regression model is tested by studying how well the
% model performs with a given factor and without it. The stepping
% may be done forwards or backwards.
%
% In the forward mode one starts with models containing only one
% factor (variable). All the one-factor models are tested and the
% best selected. Keeping this selected one fixed in the model, one
% then proceeds to test the remaining factors, select the 'second best'
% factor, test the remaining ones again, etc.
%
% In the backward mode we start with a model containing all the
% potential factors which might be taken in the model. One by one
% the factors are then tested and dropped.
%
pause, clc % Press any key to continue ... %

%
% In this example we study the selection of regression models
% using crossvalidation as the significance test instead of the more
% usual criterion to choose significant factors on the basis of the t-
% or p-values of the coefficients (see REGBACK)
%
% The idea of crossvalidation is to simulate the prediction of new
% observations using the data which is available: we throw away part
% of the data, make a model with the remaining data, and use that
% model to see how well it can predict the observations which were
% left out.
%
% In the routines CROSFORW and CROSBACK the ideas of stepwise regression
% and crossvalidation are combined. At each step of the model validation
% a crossvalidation is performed. The model (factor) with best/worst
% performance is then selected/dropped.
%
% Since we have to iterate with respect to both observations and
% variables the procedure often is somewhat time consuming. For this
% reason, only a 'leave-one-out' crossvalidation is done. At each stage,
% the routines also echo the coefficients of determination (Q2-values)
% of the predictions.

pause, clc % Press any key to continue ... %

% The data for this demonstration comes from electrophoresis, a
% separation technique in analytical chemistry. An electric field is
% applied to the substance to be studied. Different components, ions,
% have different mobilities and thus move with varying velocities.
% The goodness of the separation is determined, among other things,
% by the velocity differences between the analyte pairs.
%
% Here the aim is to separate 7 different components. There are 3
% experimental variables, called MOPS, SDS and SC, and we try to
% find the experimental conditions where all the pairs would be clearly
% separated. As the response variable we use the centralized velocities
% of the components.
%
% Let us first form the data matrices:

 x      = data(:,1:3);            % the experimental variables: MOPS, SDS, SC
 tt     = data(:,4:11);           % arrival times of analyte peaks
 vtot   = 0.5*oneg(tt)./tt/60;    % transform units from time to velocity
 vnor   = vtot(:,1:7) - vtot(:,8)*ones(1,7);
                                  % centralize the data by substracting
                                  % a reference velocity
 yvel   = vnor;                   % the velocities used as responses

 pause, clc % Press any key to continue ...

%
% Let us then start the regression analysis. First we transform the
% explanatory variables into coded units X and form the matrix X2
% containing all the quadratic interactions. Use the routines CODE
% and INTERA:

 minmax0    = [min(x);max(x)];      % min/max values in x-data
 X          = code(x,minmax0,1);    % transform to coded variables
 [X2,names] = intera(X);           % all quadratic interactions
                                    % and squares
%
% Then see how the regression looks like for purely linear and full
% quadratic models. Use the routine REG:
%

[b1,yest1,stp1,e1] = regres(X,yvel);   % fits for linear models
[b2,yest2,stp2,e2] = regres(X2,yvel);  % fits for full quadratic models

pause, clc % Press any key to continue ...

%
% To evaluate the fits compute the coefficients of determination,
% R2- values, for both model types:
%

rr1  = r2(yvel,yest1);     % R2 values, linear models
rr2  = r2(yvel,yest2);     % R2 values, quadratic models

[rr1;rr2]

pause, clc % Press any key to continue ...

%
% Also plot the data versus the fitted values from the full
% quadratic models, in four parts for clarity:
%
 pause, clc % Press any key to continue ...
 echo off

i=1:19;
subplot(221);
plot(i,yvel(:,1),'*',i,yvel(:,2),'o',i,yest2(:,1:2));
title('RESPONSES 1(*),2(o)'); xlabel('NO OF EXPERIMENT');
                        ylabel(' DATA (*,o) vs MODEL (-)')
subplot(222);
plot(i,yvel(:,3),'*',i,yvel(:,4),'o',i,yest2(:,3:4));
title('RESPONSES 3(*),4(o)')

subplot(223);
plot(i,yvel(:,5),'*',i,yvel(:,6),'o',i,yest2(:,5:6));
title('RESPONSES 5(*),6(o)')

subplot(224);
plot(i,yvel(:,7),'*',i,yest2(:,7));
title('RESPONSE 7(*)')

pause, clc % Press any key to continue ...
echo on
%
% We can see that the fits are quite good in most cases. Note that the
% responses 1 and 2 - velocities of the respective components - are
% almost overlapping. So the separation is not sufficient. We should use
% regression models to find experimental conditions with good separation
% for all pairs. For prediction purposes, however, the models should be
% validated not only by goodness of fit. The selection of relevant model
% factors is now performed by the 'simulated prediction', crossvalidation.
%
% First, start with the full quadratic models for all responses,
% dropping factors one by one on the basis of improving the prediction.
% For the routine CROSBACK we have to specify 'maxvar', the maximum number
% of variables to be left out. Since the X2 matrix has 9 columns, we
% might take maxvar = 8.
%
% So, stepwise regression by leave one out crossvalidation, backwards,
% separately for each of the 7 response variables (the routine will
% echo the Q2-values, the 'R2 values for prediction', at each step):

%  maxvar = 8;
%  for i = 1:7;
%    [ivarb(:,i),iremo(:,i),Rb(:,i)]=crosback(X2,yvel(:,i),maxvar);
%  end
%
pause, clc % Press any key to continue ...

 echo off
 maxvar = 8;
 for i = 1:7;
   [ivarb(:,i),iremo(:,i),Rb(:,i)]=crosback(X2,yvel(:,i),maxvar);
 end
 echo on

% The goodness of prediction, the Q2 values, for the respective models
% is given in the matrix 'Rb', one column for each response variable:
 Rb
 pause, clc % Press any key to continue ...

%
% The indexes of the factors removed are given in the columns of the
% matrix 'iremo', starting with the least predictive ones. Since 'ivarb'
% in this case only contains the one variable left in the model, the
% order of importance of the factors are given the matrix [iremo;ivarb],
% one column for each response:
%
 [iremo;ivarb]

 pause, clc % Press any key to continue ...
% By this analysis, the most relevant variables would be those with
% indeces 2,9,and 1. Remember that the experimental variables were
% called MOPS,SDS and SC (indeces 1,2,and 3). The order of the
% interaction factors is given in the matrix 'names' computed by the
% routine 'INTERA'. So above indeces correspond to the factors

 names(:,[2 9 1])
% i.e., SDS, SC*SC and MOPS.
% Next, perform a similar computation with forward stepwise regression.
% Now 'maxvar' gives the maximum number of factors selected in the
% models, 'ivarf' gives the order of selection and 'Rf' the respective
% Q2 indicators for the goodness of prediction:
% maxvar = 8;
% for i = 1:7;
%   [ivarf(:,i),ileft(:,i),Rf(:,i)]=crosforw(X2,yvel(:,i),maxvar);
% end
 pause, clc % Press any key to continue ...
 echo off
 maxvar = 8;
 for i = 1:7;
   [ivarf(:,i),ileft(:,i),Rf(:,i)]=crosforw(X2,yvel(:,i),maxvar);
 end
 echo on
% Let us again look at the Q2 values and the proposed order of
% importance of the factors:
 [Rf;ivarf]
 pause, clc % Press any key to continue ...
% We arrive at the same factors, with indeces 1,2,9. Since the Q2
% values for models with these factors are sufficiently high - and
% for most response variables indeed the highest - the final
% selection of the relevant model factors is clear. Note that this
% is not always the case: in general, there is no reason why the
% forwards and backwards regressions should give the same result.
% In fact, one often has to perform several iterations in both
% directions.
% Let us now construct the regression models to be used in the
% search for the optimal separation conditions. Take the 3 most
% predictive factors from, e.g., the matrix 'ivarf':

  ivar = sort(ivarf(1:3,:));

% and compute the model coefficients by fitting all the data.
% For plotting purposes, save the coefficients in the matrix 'bf3'
% in the full quadratic form, substituting 0's in the places of
% the coefficients of the omitted factors:
%  for i = 1:7;
%   [b3,yest3,stp3,e3] = regres(X2(:,ivar(:,i)),yvel(:,i));
%   bf3(:,i) = quadcomp(b3,names(:,ivar(:,i)),3); % save the coefficients
%   yestf(:,i) = yest3;                           % save the fitted values
%  end
 pause, clc % Press any key to continue ...

  echo off
  for i = 1:7;
   [b3,yest3,stp3,e3] = regres(X2(:,ivar(:,i)),yvel(:,i));
   bf3(:,i) = quadcomp(b3,names(:,ivar(:,i)),3); % save the coefficients
   yestf(:,i) = yest3;                           % save the fitted values
  end
  echo on
% The practical purpose in this study was to find optimal separation
% conditions for the 7 components. No pair of them should have
% velocities close to each other. So there are altogether 21 component
% pairs whose velocity ratios should be different from 1. Using
% certain reasonable margins to quantify what 'different from 1' means
% we can construct an overall objective function to validate the
% separation (see the routine DESISTEF). We might use, for instance, the
% routine SIMFLEX to maximize the objective function.  It turns out,
% however, that there are several local optima. To get a more
% comprehensive picture of the situation we compute the values of the
% criterion function in a grid of the two variables SDS and SC, keeping
% the values of MOPS fixed. The criterion function is normalized to
% assume values between 0 and 1: the larger the values the better the
% separation.

  mops  = 75;
% form the grid, take the min/max values as in 'minmax0':
  sds = 10:(40-10)/20:40;  lsds = length(sds);
  sc  = 10:(45-10)/20:45;  lsc  = length(sc);

% the calculations for the grid take some time, wait ....

  pause, clc % Press any key to continue ...
% the calculations for the grid take some time, wait ....
  echo off

  Dgrid = [];
  for i = 1:lsds
   for j = 1:lsc
%   at each point, transform to coded units,
%   scaled by minmax0 from data in 'regsuski'
    xgrid = code([mops,sds(i), sc(j)],minmax0,1);
    Dgrid(lsc-j+1,i) = desistef(xgrid,bf3);
   end
  end
  Dgrid = -Dgrid;

%matlab4.0:
  subplot
  mesh(sds,sc,flipud(Dgrid));
  view(40,30);
  xlabel(' SDS '); ylabel(' SC '); zlabel(' DESIRABILITY ')
  title(' Desirability of selectivity at MOPS = 75 ')
  grid

%  mesh(Dgrid);
%  matlab3.5:
%   subplot
%   c=contour(Dgrid,sds,sc);clabel(c);




