  function k = fact(n,opt)
% keywords: factorial
% call: k = fact(n,opt)
% function calculates the factorial, 1*2*...*(n-1)*n,  of n.
%
% INPUT:        n    integer
%               opt    gamma function option: opt = 0 do not use gamma function
%                                             opt = 1 use gamma function
%                                             opt = 2 calculate log of n!
%                                             DEFAULT: opt = 0
% OUTPUT:       k    integer k = 1*2*...*(n-1)*n
%
% NOTE! use opt = 1 option with large values of and/or large dimensions of n

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2003/09/11 10:38:11 $

if nargin == 1
    opt = 0;
end

nnn = n(:);

if min(nnn) < 0 
   error('n must be positive')
end

%time1 = clock;

if opt == 1

    nn = n(:);
    in = find(nn==0); nn(in) = oneg(in);
    n(:)  = nn;
    k  = gamma(n+1);

else

    [nrow,ncol] = size(n);
    if nrow < ncol n=n'; end

    if max([nrow ncol]) > 1
        k = zeros(size(n));
    else
        k = 0;
    end

    for l = 1:min([nrow ncol])

        nn = n(:,l);

        in = find(nn==0); nn(in) = oneg(in); % replace zeros by ones

        logi    = zeros(length(nn),max(nn));

        for j = 1:length(nn)
            logi(j,:) = [log(1:nn(j)) zeros(1,max(nn)-nn(j))];
        end

        si     = sum([logi zeros(length(nn),1)]')';
        if opt < 2
           k(:,l) = round(exp(si));
        else
           k(:,l) = si;
        end
    end

    if nrow < ncol k=k'; end

end

%time2 = clock; time2(6)-time1(6)
