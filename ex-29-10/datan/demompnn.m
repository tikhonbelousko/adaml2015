  clc
  echo on
% keywords: demo
% Here we demonstrate the function MPNN (see also DEMOMPN0). The aim
% is to estimate the density of microbes in a given sample. Using the
% observed numbers of microbes in a series of dilutions, the function
% estimates the probabilities of different densities of microbes in the
% first dilution level. The amount with highest probability is taken as
% the most likely solution - thus the name, Most Probable Number, of the
% method.
%
% MPNN plots the likelihood curve on an interval estimated by the
% function itself. Alternatively, you may give the lower and upper
% bounds of the interval in a vector 'minmax'.
%
% MPNN will now compute the likelihood for a number of values between
% the bounds, and plot the curve so created. From this plot the most
% likely value - the maximum of the curve - is computed, as well as
% numerical values for the confidence limits with a given level of
% significance.
%

  pause, clc, % strike any key to continue ...

% A series of dilution experiments is performed by diluting the 
% original sample by factors 'a' (with a = 2 or a = 10 we make 
% dilutions 1:2 or 1:10, etc. Note that MPNN may take 'a' as a vector,
% so the factors may even differ in one series of dilutions). The matrix
% 'no' contains the observed numbers of microbes in each dilution. As an
% example, the result of  an experiment might look as follows:
%
%           1    2    3         the replicates
%
%  d   1    30   28   23
%  i   2     3    2    0
%  l   3     0    0    0
%  u
%  t
%  i
%  o
%  n
%
% So, we have 3 dilutions with 3 replicates in each, with a constant dilution
% factor a = 10 in all dilutions. In reality, the first level is already
% a dilution of the original sample, the dilution factor being 10**-5.
% In order to get the density in the original sample, you have to
% multiply the result obtained below by 10**5.
  pause, clc, % strike any key to continue ...

% Let us now compute what the density of microbes in the original sample
% might be ...

 no = [ 30  28  23
         3   2   0
         0   0   0];           % the results
 a  = 10;                      % dilution factors
 vol= 0.08;                    % the volume of the dilutions

% The call in the basic form reads:
%
% [mpn,confint] = mpnn(a,no,vol);

 pause, clc  % strike any key to continue (and wait ...)

  echo off
 [mpn,confint] = mpnn(a,no,vol);
  pause
  clc

  echo on
%
% The most likely value seems to be 323, and in any case the
% correct answer should be somewhere between 200 450 - with 95%
% certainty it should be in the interval

 confint

% You may compute other confidence intervals as well, for instance
% the 99% by
%
% [p,mpn,confint] = mpnn(a,no,vol,.99,[200 460]);

 pause, clc % strike any key to continue ....

  echo off
 [p,mpn,confint] = mpnn(a,no,vol,.99,[200, 460]);



