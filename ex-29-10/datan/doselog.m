  function [F,Fmax,vmax,v1axis,v2axis] = doselog(n,r,d,v1,v2,ido,nstep);
% keywords:
% call: [F,Fmax,vmax,v1axis,v2axis] = doselog(n,r,d,v1,v2,ido,nstep);
% The function computes the likelihood function of a linear
% logistic model either in the form    (ido = 1)
%            ' log(pi_i/(1-pi_i) = alfa + beta*d_i '      (1)
% or with the 'ED50' -parametrization  (ido = 2)
%            ' log(pi_i/(1-pi_i) = (d_i - mu) / sigma '   (2)
% The values are computed in a grid given by 'v1' and 'v2', where
% 'v1' stands for alfa or mu, 'v2' beta or sigma, respectively.
% INPUT  n     a vector giving the n of 'trials' in each experiment
%        r     a vector giving the n of 'successes' in each experiment
%        d     'dose', the experimental variable
%        v1    a 2-component vector giving lower and upper bounds for grid
%        v2    a 2-component vector giving lower and upper bounds for grid
%        ido   the parametrization option: ido = 1,  the form (1) above
%                                          ido = 2,  the form (2) above
%        nstep n of steps in the axis grid. OPTIONAL, default 30
% OUTPUT F       the values of the likelihood function
%        Fmax    the max value of F in the grid
%        vmax    the grid point where Fmax is obtained
%        v1axis
%        v2axis  the axis values used,  for plotting the contour/mesh


 F=[]; Fmax=[]; vmax=[]; v1axis=[]; v2axis=[];
 a=[]; b=[]; x=[];
 if nargin < 7 nstep = 30; end

 k      = length(n);
 v1axis = v1(1):(v1(2)-v1(1))/(nstep-1):v1(2);
 v2axis = v2(1):(v2(2)-v2(1))/(nstep-1):v2(2);

 [a,b]  = meshgen(v1axis,v2axis);

 F  = zerog(a);

   for i=1:k
     if ido==1
        abd = a + b*d(i);
     elseif ido==2
        abd = (d(i)-a)./b;
     end
     nmr = n(i) - r(i);
     F = F + r(i)*abd - n(i)*log(1 + exp(abd)) ...
         + sum(log(2:n(i))) - sum(log(2:nmr)) - sum(log(2:r(i)));
   end

  for i = 1:nstep,
    ii=find(F(:,i)<-100); iii = length(ii);
    if iii > 0,
      F(ii,i)=-1000*ones(iii,1);
    end,
  end
  F          = exp(F);
 [FF,  ii]   = max(F);
 [Fmax,iii]  = max(FF);
  v1max      = v1axis(iii);
  v2max      = v2axis(ii(iii));
  vmax       = [v1max, v2max];

% if (vers==52) FF = flipud(FF); end



