function [t,p,s,df]=ttest(a,compare,b)
% keywords: comparison of means, t-test
% call: [t,p,s,df]=ttest(a,compare,b)
%
% The function calculates one (or two) sample t-test t-value for sample(s)
% a (and b). The mean(a) (or difference mean(a)-mean(b)) is compared to compare.
% The (pooled) standard deviation s and degrees of freedom df are also calculated
%
% INPUT:  a         the first sample
%         compare   the value to which mean(a) (or mean(a)-mean(b)) is compared
%         b         the optional second sample
%
% OUTPUT: t          the test value
%         p          one and two sided probabilities of t
%         s          the (pooled for two samples) standard devieation
%         df         degrees of freedom
%
% NOTE! The paired t-test can be done by ttest(a-b,compare)

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

one=0; p = zeros(1,2);

if nargin==2
    one=1;
elseif nargin<2
    error('too few inputs!!');
end

if one==0

    na = length(a);
    nb = length(b);

    ma = mean(a);
    mb = mean(b);
 
    s = sqrt((sum((a-ma).^2)+sum((b-mb).^2))/(na+nb-2));

    t = (ma-mb-compare)/(s*sqrt(1/na+1/nb)); df=na+nb-2;

else

    na = length(a);

    ma = mean(a);
 
    s = std(a);

    t = (ma-compare)/(s/sqrt(na)); df=na-1;

end

p(1) = 1-distt(abs(t),df,1);
p(2) = 1-distt(abs(t),df,2);
