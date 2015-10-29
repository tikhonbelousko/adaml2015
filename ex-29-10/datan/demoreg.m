 clc
 echo on
% keywords: demo
% This demonstration illustrates the use of the functions reg,
% regstat  and regpred.
%
% The data is from Weisberg (1985), table 2.1, pp. 35-36.
% Type 'type demoreg' to see the commands and comments and
% execute it simply by typing 'demoreg'. Remember to 
% initialize the graphics.

% The data is given in the matrix 'x'

pause, clc %strike any key to continue ...

x = [ 1029   9.00   540  3.571   1.976   557
       771   9.00   441  4.092   1.250   404
       462   9.00   268  3.865   1.586   259
      5787   7.50  3060  4.870   2.351  2396
       968   8.00   527  4.399   0.431   397
      3082  10.00  1760  5.342   1.333  1408
     18366   8.00  8278  5.319  11.868  6312
      7367   8.00  4074  5.126   2.138  3439
     11926   8.00  6312  4.447   8.577  5528
     10783   7.00  5948  4.512   8.507  5375
      5291   8.00  2804  4.391   5.939  3068
     11251   7.50  5903  5.126  14.186  5301
      9082   7.00  5213  4.817   6.930  4768
      4520   7.00  2465  4.207   6.580  2294
      3896   7.00  2368  4.332   8.159  2204
      2883   7.00  1689  4.318  10.340  1830
      4753   7.00  2719  4.206   8.508  2865
       632   7.00   341  3.718   4.725   451
       579   7.00   419  4.716   5.915   501
      1525   8.50  1033  4.341   6.010   976
      2258   7.00  1496  4.593   7.834  1466
       565   8.00   340  4.983   0.602   305
      4056   9.00  2073  4.897   2.449  1883
      4764   9.00  2463  4.258   4.686  2604
      1781   8.50   982  4.574   2.619   819
      5214   9.00  2835  3.721   4.746  2953
      2665   8.00  1460  3.448   5.399  1537
      4720   7.50  2731  3.846   9.061  2979
      7529   8.00  4084  4.188   5.975  4169
      3299   9.00  1626  3.601   4.650  1761
      4031   7.00  2088  3.640   6.905  2301
      3510   7.00  1801  3.333   6.594  1946
      2263   8.00  1309  3.063   6.524  1306
      1978   7.50  1081  3.357   4.121  1242
      3720   8.00  1813  3.528   3.495  1812
      2634   6.58  1657  3.802   7.834  1695
     11649   5.00  6595  4.045  17.782  7451
       719   7.00   421  3.897   6.385   506
       756   8.50   501  3.635   3.274   490
       345   7.00   232  4.345   3.905   334
      2357   7.00  1475  4.449   4.639  1384
      1065   7.00   600  3.656   3.985   744
      1945   7.00  1173  4.300   3.635  1230
      1126   7.00   572  3.745   2.611   666
       527   6.00   354  5.215   2.302   412
      3443   9.00  1966  4.476   3.942  1757
      2182   7.00  1360  4.296   4.083  1331
     20468   7.00 12130  5.002   9.794 10730];

states=['ME';'NH';'VT';'NA';'RI';'CN';'NY';'NJ';'PA';'OH';
        'IN';'IL';'MI';'WI';'MN';'IA';'MO';'ND';'SD';'NE';
        'KS';'DE';'MD';'VA';'WV';'NC';'SC';'GA';'FL';'KY';
        'TN';'AL';'MS';'AR';'LA';'OK';'TX';'MT';'ID';'WY';
        'CO';'NM';'AZ';'UT';'NV';'WN';'OR';'CA'];

vars  =['TAX  ';'DLIC ';'INC  ';'ROAD '];

pause, clc % strike any key to continue ...

% Transformations according to Weisberg

y       = 1000*x(:,6)./x(:,1);
cases   = 1:length(y); cases = cases';
x(:,3)  = 100*x(:,3)./x(:,1);
x       = x(:,2:5);

% The basic statistics (mean,std,min and max)
echo off
disp(' ')
disp('    TAX       DLIC      INC       ROAD      FUEL')
disp(' ')
disp([mean([x y]); std([x y]); min([x y]); max([x y])])

echo on
% The regression analysis, computed by REG:
%


[b,yest,stp,res,s1,R21,yi1,e1,h1,D1] = regres(x,y);   % wait

pause, clc, % strike any key to continue ..


%    the results for the coefficients of the regressors:
%
%        coeff    std        t-value    p-value
%         b         s         t          p
%

disp([b stp])

%     the regressors are

 disp(vars)

pause, clc  % strike any key to continue

echo off
plot(cases,res),title('unstandardized residuals')
pause
clc
echo on

% The statistics for outlier detection and evaluation of
% predictive value of the model.
%
% If you would want to crossvalidate (predict) with more casess left
% out use CROSREG.

[s,R,yi,e,h,D] = regstat(x,y);
%
%    estimated standard error, R^2 and prediction R^2

disp([s R])

pause, clc, % strike any key to continue

echo off
plot(cases,yi,cases,y,'*'),title('predicted y vs. measured y (*)')
pause
clc
echo on

% Just to show you how PLOTPCA can be used to visualize
% regression results:

echo off
plotpca([cases D],1,2,states,cases), title('influence plot')
pause
clc
echo on

% The function REGPRED is intended for prediction. It also gives
% an estimate for standard the error of the predicted y-value.
% An large standard error is a warning of extrapolating too far
% of the original data set. Here the usage is illustrated only
% by predicting the original data.

[ypred,sy] = regpred(x,b,1,1:4,x,s);

pause, clc %strike any key to continue ...

echo off
[m,n] = size(x);
ybounds = [(ypred - 3*sy), (ypred + 3*sy)];
plot(1:m,y,'*',1:m,yest,'-',1:m,ybounds,'--')
title(' data (*) prediction (-), bounds (ca. 99 %) for prediction (--)');
clc

