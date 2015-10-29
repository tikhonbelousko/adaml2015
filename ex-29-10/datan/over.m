  function k = over(n,m,opt)
% keywords: binormal coefficients
% call: k = over(n,m,opt)
% The function calculates the expression (n over m) = n!/(m!(n-m)!)
%
% INPUT:        n    integer
%               m    integer
%               opt  opt = 1   =>  calculate n!/(m!(n-m)!)
%                    opt = 2   =>  calculate log of n!/(m!(n-m)!)
%                    OPTIONAL, DEFAULT: opt = 1
%
% OUTPUT:       k    integer k = (n over m) = n!/(m!(n-m)!)
%
% see FACT for opt

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/09 15:16:12 $

if nargin == 2
    opt = 1;
elseif nargin <2
    error('too few inputs')
end

nnn = n(:);
mmm = m(:);

if min(nnn) < 0 | min(mmm) < 0 | min(nnn-mmm) < 0
   error('m and n must be positive and n => m')
end

nf  = fact(n,2);
mf  = fact(m,2);

nmf = fact(n-m,2);

k   = nf-(mf+nmf);

if opt == 1
    k = round(exp(k));
end 
    
