% keywords: demo
% This is an example of experimental design using Taguchi's orthogonal
% array L8. The data is from tile manufacturing and the factors.
% Type 'demotagu' to excute the demo and 'type demotagu' to see its contents.
clc
echo on
% This is an example of experimental design using Taguchi's orthogonal
% array L8. The data is from tile manufacturing and the factors (variables)
% and ther upper and lower values are given in the table below
% See Taguchi Introduction to quality engineering, 1986 p. 80
%
%  CONTROL FACTORS                  LEVEL 1    LEVEL 2
%  A  lime additive content            5 %        1 %
%  B  additive particle size        coarse       fine
%  C  agalmatolite content            43 %       53 %
%  D  type of agalmatolite          current    less expensive
%  E  charge quantity               1300 kg    1200 kg
%  F  waste return content             0 %        4 %
%  G  feldspar content                 0 %        5 %
%
% The measured response is number of tiles out of spefications and its
% experimental error was determined by 5 replicate runs (i.e. with 4
% degrees of freedom

pause, clc  % press any key to continue

%  Let's make taguchi L8-design

factors = ['     A     B     C     D     E     F     G'];
x = taguchi(8);
y = [16    17    12     6     6    68    42    26]';

%  yieding
echo off

disp(['   No.' factors ' No. out of spec']);
disp([(1:8)' x y]);

echo on
pause, clc,  % press any key to continue


%  We analyse the results by regression analysis which is more convenient
%  than the conventional calculator methods. Actually we are doing an 
%  analysis of variance due to the qualitative factors B and D. But
%  analysis of variance can always be calculated by regression using
%  so called dummy variables (0/1-variables), see Draper & Smith:
%  Applied Regression Analysis, Wiley 1966 for more details. In the
%  special case of two levels for each variable we have no problems,
%  we just scale variables to have values 0 and 1 (i.e. x-1). Only
%  we have to remember not to use the model for other values of B and D
%  than 0 and 1.

[b,yest,stp,e]=regres(x-1,y,[8 4]); % err=8 with df=4 !

pause, clc  % press any key to continue
echo off

disp('coefficients and their t- and p-values');
disp([b stp])
disp('order of coefficients is')
disp(['constant' factors])

echo on
pause, clc  % press any key to continue

%  Now we make a full factorial design in order to see which combination
%  of all possible 2^7 would be best according to the simple linear main
%  effect model that we just achieved

z = (twon(7)+1)/2;  % scale -1 to 0 and +1 to +1

%  Extrapolation with a linear regression model is done by regpred

[ypred spred] = regpred(z,b,1,1:7,x-1,8);

[ymin,imin]=min(ypred);

%  yieding
echo off

disp('the optimal combination out of all possible 2^7 = 128 combinations');
disp(factors);
disp(z(imin,:)); 
disp('prediction and standard error of prediction');
disp([ypred(imin) spred(imin)]);

echo on
pause, clc  % press any key to continue

%  It is quite natural that extrapolation with a linear model gives
%  impossible (negative here) results though 99% confidence limit,
%  approximately 3*8, contains a possible result, zero. In practice
%  this factory reported that its 'no. out of spec' decreased to
%  below 1 after applying the optimal combination!

echo off
