  function y = contract(x,int,med);
% keywords: compression of data
% call:  y = contract(x,int,med);
% The function contracts and smooths a matrix by taking means/medians
% over a given number of rows. Useful, e.g., in dealing with spectral
% data.
% INPUT:   x      the data matrix
%          int    the smoothing integer
%          med    med=0:  smoothing by means
%                 med~=0: smoothing by medians
%                         OPTIONAL, default: med=0
% OUTPUT:  y      a matrix containing smoothed and contracted versions
%                 of the columns of 'x', obtained by replacing the rows
%                 x(i,:) ... x(i+int,:) by their mean/median. If 'x' is
%                 of size [nr,nc], the size of 'y' is [floor(nr/int),nc].
%                 NOTE: A row vector is contracted over columns.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

  m0 = [];
  if nargin<2
    error('too few input for contract');
  elseif nargin==2
    med=0;
  end
   
 [m,n]  = size(x);
  if m == 1              % the case when 'x' is a vector
    m0=m;
    x = x(:);
    [m,n] = size(x);
  else
    m0 = 0;
  end

  nstep = floor(m/int);

  if med==0
    for i = 1:nstep,
        y(i,:)= mean(x((i-1)*int+1:i*int, :));
    end
  else
    for i = 1:nstep,
        y(i,:)= median(x((i-1)*int+1:i*int, :));
    end
  end
   
  if m0==1, y=y'; end

   

