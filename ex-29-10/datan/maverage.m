  function y = maverage(x,m,med,odd)
% keywords: moving average
% call: y = maverage(x,m,med,odd)
% The function calculates the m-point moving average/median for the
% columns of 'x' by averaging over the rows
% INPUT:    x      the data matrix, size of 'x' is [nr, nc]
%           m      the n. of values averaged
%           med    med=0:  average by means
%                  med~=0: average by medians
%                          OPTIONAL, default: med=0
%           odd    odd = 0   => size of 'y' is [nr-m+1, nc]
%                  odd ~= 0  => size of 'y' is unchanged, one-sided
%                               averages for first and last rows
%                               NOTE: if odd ~= 0 then 'm' must be
%                               a positive odd integer, m= 3/5/...!
%                               OPTIONAL: default: odd = 0
%
% OUTPUT:   y      the matrix of the moving averages/medians
%                  NOTE: A row vector is averaged over columns.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

 y = []; nr0 = [];
 if nargin<2
   error('too few input for maverage'); 
 elseif nargin == 2
   med = 0; odd = 0;
 elseif nargin==3
   odd = 0;
 end
 if length(med)==0, med=0; end
 if med==0,
    txt='mean';
 else
    txt='median';
 end

 [nr,nc] = size(x);
 if nr == 1      % the case when 'x' is a row vector
    nr0=nr;
    x = x(:);
    [nr,nc] = size(x);
 else
    nr0 = 0;
 end


 if odd == 0

   y = zeros(nr-m+1,nc);

   for i=1:nr-m+1
      ind=i:i+m-1;
      y(i,:) = eval([txt '(x(ind,:))']);
   end

 end

 if odd ~= 0

   if m/2-round(m/2)==0
     error('for size preserving maverage the window length m must be odd')
   end

    y = zeros(nr,nc);

    m2 = (m-1)/2;
    for i = 1:m2;
       ind = 1:m2+i;
       y(i,:) = eval([txt '(x(ind,:))']);
    end
    for i = m2+1:nr-m2;
       ind = i-m2:i+m2;

       y(i,:) = eval([txt '(x(ind,:))']);
    end

    for i = nr-m2+1:nr
       ind = i-m2:nr;
       y(i,:) = eval([txt '(x(ind,:))']);
    end

 end

 if (nr0==1) y=y'; end

