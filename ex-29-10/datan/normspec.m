  function y = normspec(x,opt,col)
% keywords: spectra processing
% call: y = normspec(x,opt,col)
% Normalize spectra.
% INPUT:
%         x         the (typically) spectra to be manipulated
%         opt       the normalization options:
%
%           opt=1   norm the spectra (rows of x) to have a unit
%                   total integral (= column sum)
%           opt=2   norm the spectra (rows of x) by dividing with
%                   the maximum of each spectrum
%           opt=3   norm the spectra (rows of x) by dividing with
%                   the value of a given columsn col
%           opt=4   norm the spectra (rows of x) by substracting
%                   the minimum value of each spectrum
%
%         col       see above, case 3. OPTIONAL.
% OUTPUT
%         y         the normalized spectra

if nargin < 2
   opt = 1;
end

if opt == 1
    a = sum(x')';
    y = x./a(:,oneg(x(1,:)));
elseif opt == 2
    a = max(x')';
    y = x./a(:,oneg(x(1,:)));
elseif opt == 3
    a = x(:,col);
    y = x./a(:,oneg(x(1,:)));
elseif opt == 4
    a = min(x')';
    y = x-a(:,oneg(x(1,:)));
end

