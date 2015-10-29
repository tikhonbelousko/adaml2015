function [mpn,confint,p,lam0,lmax,lstd,sp] = mpnn(a,no,vol,signif,minmax)
% keywords: most probable number, biometrics
% call: [mpn,confint,p,lam0,lmax,lstd,sp] = mpnn(a,no,vol,signif,minmax)
% Using the observed numbers of microbes in a series of dilutions, the
% function estimates and plots the probabilities for different densities
% of microbes in the first dilution level used.
% INPUT a        the dilution factor (may be a vector)
%       no       the matrix whose ij'th component is the number of
%                microbes in the i'th dilution and j'th replicate
%       vol      the volume of the dilution samples used
%       signif   the level of significance for 'confint'
%                OPTIONAL, default  signif = 0.95
%       minmax   lower & upper bound for the population density 'lam0'.
%                OPTIONAL, default  lmax +/- 4*lstd, see below.
% OUTPUT mpn      the most probable number
%        confint  the confidence interval with the level 'signif'
%        p        the probabilities of each component of 'lam0*vol'
%        lam0     the density points where 'p' is computed
%        lmax     approximative mpn
%        lstd     approximative std of 'p'
%        sp       the cumulative sum of 'p'
% NOTE: elements of 'no' may be given as negative integers. This means
% that the respective sample has AT LEAST 'abs(no)' microbes.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:44:19 $

if nargin < 4
  signif = 0.95;
elseif nargin < 3
  error(' too few input arguments ! ');
end
if length(signif)==0, signif = 0.95; end

[ndil,nrepl] = size(no);
i = 1:ndil; i = i(:); j = 1:nrepl;
if length(a)==1, a = a*ones(1,ndil); end    % constant dilution
a = exp(cumsum(log(a)))/a(1);

a = a(:);
a = ones(ndil,1)./a;            % dilution factor to dilution vector

ntot = sum(sum(abs(no))); asum = sum(a)*nrepl*vol;
lmax = ntot/asum;
lstd = sqrt(ntot)/asum;
if nargin < 5
  minmax(1) = max(1,lmax - 4*lstd);
  minmax(2) = lmax + 4*lstd;
end

step = (minmax(2) - minmax(1))/80;
lam0 =  vol*(minmax(1):step:minmax(2));

logp = 0;
for ii = 1:ndil
  lam = lam0*a(ii);
  for jj = 1:nrepl
    if no(ii,jj) >= 0
      loggamm = sum(log(1:no(ii,jj)));
      logp = logp - lam + no(ii,jj)*log(lam) - loggamm;
    elseif no(ii,jj) < 0
      n = abs(no(ii,jj)); s = [];
      for k = 0:n-1
        s(k+1,:) = exp(- lam + k*log(lam) - sum(log(1:k)));
      end
      if n > 1 s = sum(s); end
      logp = logp + log(1 - s);
    end
  end
end
p = exp(logp);

sp      = cumsum(diff(lam0).*means(p));
p       = p/sp(length(sp));
sp      = [0 sp]/sp(length(sp));
signif2 = (1 - signif)/2;
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
