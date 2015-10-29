function [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,minmax,signif)
% keywords: most probable number, biometrics
% call: [p,lam0,confint,r0,sp] = mpn0(a,n,r,vol,minmax,signif)
% Using the observed numbers of sterile plates in a series of dilutions,
% the function estimates the probabilities of different amounts of microbes
% in the original sample.
%
% INPUT
%      a        the dilution factors (may be a vector)
%      n        n of replicates in each dilution (may be a vector)
%      r        the vector whose i'th component is the n of sterile
%               plates in the i'th dilution
%      vol      the volume of the dilution
%      minmax   the end points of the interval where 'p' is computed
%      signif   the level of significance for 'confint'
%               OPTIONAL, default signif = 0.95
% OUTPUT
%      p        the probabilities of each component of 'lam0'
%      lam0     the points where 'p' is computed
%      confint  the confidence interval with the level 'signif'
%      r0       the expected n of sterile in each dilution, each 'lam0'
%      sp       the cumulative sum of 'p'

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

 if nargin < 6
    signif = 0.95;
 elseif nargin < 5
    error(' too few input arguments ! ');
 end

 lmin = minmax(1); lmax = minmax(2);
 r    = r(:);      lam0 = vol*(lmin:(lmax-lmin)/80:lmax); lm   = length(lam0);
 m    = length(r); r    = r*ones(1,lm); i  = [1:m]';
 if length(n)==1,  n    = n*ones(1,m); end  % same n of replicates in dilutions
 if length(a)==1,  a    = a*ones(1,m); end  % same dilution factors
 n    = n(:);      n    = n*ones(1,lm);
 a    = exp(cumsum(log(a)))/a(1); a = a(:); a = oneg(a)./a;

 lteta = - a*lam0;
 teta  = exp(lteta);

 for i = 1:m
    ii    = find(teta(i,:)==1); iii = remove(1:lm,[],ii);
    l1teta(i,iii) = log(1-teta(i,iii));
    if length(ii) > 0, l1teta(i,ii)  = -1000*ones(1,length(ii));end
 end

 r0      = n.*teta;
 p       = exp(sum(r.*lteta + (n-r).*l1teta));
 sp      = cumsum(diff(lam0).*means(p));
 p       = p/sp(length(sp));
 sp      = [0 sp]/sp(length(sp));
 signif2 = (1-signif)/2;
 confint = [lam0(max(find(sp<=signif2))) lam0(min(find(sp>=1-signif2)))];

 confint = confint/vol;
 lam0    = lam0/vol;
 [pm,mpn]= max(p);
 mpn     = lam0(mpn);

 xsignif = kron(confint,[1 1]);
 y1      = [1.1*max(p) 0]; x1u = xsignif(1:2); x1l = xsignif(3:4);
 plot(lam0,p,x1u,y1,'-',x1l,y1,'-');
 sn      = strvec(100*signif);
 str     = ['the mpn curve with ', sn ,' % confidence limits'];
 mpns    = strvec(round(mpn));
 xlab    = ['the most probable value: ', mpns ];
 title(str);
 xlabel(xlab);

           
