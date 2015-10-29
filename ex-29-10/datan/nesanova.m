  function [mse,df,f,var] = nesanova(x,y,labelf,plotit)
% keywords: anova
% call: [mse,df,f,var] = nesanova(x,y,labelf)
% The function calculates the nested analysis of variance for
% balanced data. The effects are assumed to be fixed and interactions
% are not expected. Uses the Toolbox function POOL.
%
% INPUT:           x      the design  matrix in coded form
%                         OR a (1 x nfactor) vector containing the number
%                         of levels for each factor in the nested design
%                  y      the data vector
%                  labelf df-labels (1/0, yes/no) for the F-plots.OPTIONAL,
%                         default labelf=0
% OUTPUT:          mse    the (nfactor x 1) vector of the mean squares
%                         for each factor
%                  df     the respective degrees of freedom
%                  f      the F-test values (only when 1 < nfactor < 8,
%                         otherwise a vector of zeros)
%                  var    the pure variances for each factor

% Copyright (c) 1994,2003 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2003/06/10 12:14:37 $

if nargin<4
   plotit=1;
end

[nobs,nfac] = size(x);

if nobs == 1 % x not given explicitly, must be formed here
   lev = (1:x(nfac))';
   for j = nfac-1:-1:1
      lev = kron(ones(x(j),1), lev);
      lev = [kron((1:x(j))',ones(prod(x(j+1:nfac)),1)) lev];
   end
   x = lev;
else
   nfac = nfac+1;
end

mse  = zeros(nfac,1);
nl   = zeros(nfac,1);
df   = zeros(nfac,1);
var  = zeros(nfac,1);
f    = zeros(nfac-1,1);

fac = nfac;
while fac > 0
   if fac == 1
      [err,mse1,means,comb,irep] = pool(oneg(x),y);
   else
      [err,mse1,means,comb,irep] = pool(x,y,1:fac-1);
   end
   [m1,n1] = size(irep);
   nl(fac) = n1;
   var(fac) = err(1)^2; df(fac) = err(2);
   for i = nfac:-1:fac+1
      var(fac) = var(fac)-var(i)/prod(nl(fac+1:i));
   end
   for j = fac+1:nfac
      mse(fac) = mse(fac)+var(j-1)*prod(nl(nfac:-1:j));
   end
   fac = fac-1; x = comb; y = means;
end

mse = mse + var(nfac);

if nfac > 1 & nfac < 8
   for j = 2:nfac
      f(j-1) = mse(j-1)/mse(j);
      if nfac == 2
         if plotit
            plotf(0,f(j-1)+10,df(j-1),df(j),f(j-1),1);
            str =['factors ',strvec(j-1),' vs. ',strvec(j)];
            xlabel(str);
            title(' F-tests with the 95(-)/99(--)% percentile points');
         end
      else
         if plotit
            subplot(2,floor(nfac/2),j-1);
            plotf(0,f(j-1)+10,df(j-1),df(j),f(j-1),1);
            str =['factors ',strvec(j-1),' vs. ',strvec(j)];
            xlabel(str);
            if j == 2
               title(' F-tests with the 95(-)/99(--)% percentile points');               
            end
         end
      end
   end
else
   disp('Too many levels, the F-tests/plots must be done manually');
end
