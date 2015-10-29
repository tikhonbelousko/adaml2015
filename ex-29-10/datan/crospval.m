  function [Q2,Q2y,ypred,press,pressy]=crospval(x,y,dims,part,method,iscale,iperm);
% keywords: variable selection, regression, crossvalidation, principal components, PLS
% call: [Q2,Q2y,ypred,press,pressy]=crospval(x,y,dims,part,method,iscale,iperm);
% The function calculates crossvalidation for the two principal
% component type regression methods, PLS or PCR. The data is devided in
% 'part' parts. A scaling of 'x' is optional. 'Press' is calculated by
% dropping out each part of the data and using the rest of
% the data in calibration and the dropped part for prediction.
%
% INPUT  :      x,y       data matrixes   [m,ny] = size(y)
%               dims      criteria calculated for dimensions given in 'dims'
%		part	  data is devided in 'part' parts
%               method    1 = PLS      2 = PCR
%               iscale    perform the scaling of 'x' (0 = no   1 = yes)
%                         OPTIONAL, default iscale = 1.
%               iperm     the order of observations used in crossvalidation
%                         OPTIONAL, default: iperm randomized
%
% OUTPUT :      Q2        R2 values for each dimension (mean values for
%                         multiresponse 'y')
%               Q2y       Q2 for each response component & dimension
%               ypred     predicted 'y' for each dimension
%                         [mypred,nypred] = size(ypred)
%                         mypred=floor(m/part)*part,nypred=length(dims)*ny
%               press     predicted residual sum of squares for each
%                         dimension
%               pressy    press for each response component & dimension

   if nargin == 5
       iscale = 1;
   end;

   if method == 1
        [Q2,Q2y,ypred,press,pressy] = crosplsq(x,y,dims,part,iscale);
   else
        [Q2,Q2y,ypred,press,pressy] = crospcrq(x,y,dims,part,iscale);
   end;
