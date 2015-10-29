  function y = screen(n,nrepl)
% keywords: screening design, experimental design
% call: y = screen(n,nrepl)
%
% This function constructs a screening design for 'n' variables with
% 'nrepl' replicate points (DEFAULT: nrepl = 1)

if nargin == 1
    nrepl = 1;
elseif nargin < 1
    disp('too few inputs')
    break
end

y = diag(ones(n,1));

if nrepl > 0
   y = [y;zeros(nrepl,n)];
end
