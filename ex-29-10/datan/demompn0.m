  clc
  echo on
% keywords: demo
% Here we demonstrate the function MPN0. The aim is to estimate the
% density of microbes in a given sample. Using the observed numbers
% of sterile plates in a series of dilutions, the function estimates
% the probabilities of different amounts of microbes in the original
% sample. The amount with highest probability is taken as the most
% likely solution - thus the name, Most Probable Number, of the method.
%
% To use the function, you must have some idea what the density of
% microbes might be, to be able to give a guess for the bounds 'lower'
% and 'upper' of it.
%
% MPN0 will now compute the likelihood for a number of values between
% the bounds, and plot the curve so created. From this plot you easily
% see the most likely value - the maximum of the curve - as well as
% approximate confidence limits by the width of the curve. MPN0 also
% computes numerical values for the confidence limits with a given
% level of significance.
%
% If your plot does not have a maximum, you must correct your guess
% of 'lower' or  'upper'.

  pause, clc, % strike any key to continue ...

% A series of dilution experiments is performed by diluting the 
% original sample by factors 'a' (with a = 2 or a = 10 we make 
% dilutions 1:2 or 1:10, etc. Note that MPN0 may take 'a' as a vector,
% so the factors may even differ in one series of dilutions). The number
% of components in 'r' gives the number of dilutions. In addition, each
% dilution is replicated 'n' times. As a whole, an experiment might 
% look as follows:
%
%           1   2   3   4   5      the replicates
%
%  d   1    *   *   *   *   *      0        total number of steriles
%  i   2    *   *   *   *   *      0        (0 sterile/ * not sterile)
%  l   3    *   0   *   *   *      1
%  u   4    *   *   *   *   *      0
%  t   5    *   *   0   *   0      2
%  i   6    *   0   *   0   0      3
%  o   7    0   0   *   0   *      3
%  n   8    0   0   0   0   0      5
%  s
%
% So, we have eight dilutions with n = 5 replicates in each, r = [0 0 1 0 2
% 3 3 5] sterile plates, and a constant dilution factors a = 2. The
% density of microbes in the sample is supposed to be between 1 and 100.
  pause, clc, % strike any key to continue ...

% Let us now compute what the density of microbes in the original sample
% might be ...

 r = [0 0 1 0 2 3 3 5];         % the results
 n = 5;                         % n of replicates
 a = 2;                         % dilution factors
 lmin = 1; lmax = 100;          % guessed min/max values
 vol = 1;                       % the (here normalized) volume of the
                                % dilutions

% [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,[lmin,lmax]);

 pause, clc, % strike any key to continue and wait ...

 echo off
 [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,[lmin,lmax]);
 pause
 echo on

% The most likely value computed is 13 and in any case the
% correct answer should be somewhere between 5 and 35 - with 95%
% certainty it should be in the interval

 confint

% We may now make the plot again with a more accurate interval and the
% 99 % confidence bounds:

% [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,[1,35],.99);

  pause, clc, % strike any key to continue and wait ...

 echo off
 [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,[1,35],.99);

