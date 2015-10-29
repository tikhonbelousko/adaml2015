 function [B,nB] = smoothb(nr,tailweight,order)
%keywords: smoothing
%call:    [B,nB] = smoothb(nr,tailweight,order)
%The function creates matrices that calculate numerical derivatives
%of vectors with length 'nr'. Used by, e.g., RIDGEREG.
%
%INPUT     nr           length of vector
%          tailweight   suppress tails of solution
%          order        order of the derivatives calculated
%
%OUTPUT    B            the derivative matrix, in sparse form.
%          nB           n of rows of B

if nargin == 2, order = 2; end
if nargin == 1, order = 2; tailweight = 0; end

if length(tailweight) == 0,tailweight = 0; end 
if length(order) == 0,order = 2; end 

nB = nr-order;
i  = [];
j  = [];
k  = [];

for ii = 1:nB

    i = [i;ii*ones(order+1,1)];
    j = [j;(ii-1)+(1:order+1)'];
    k = [k;(-1).^(0:order)'.*over(order,(0:order)')];

end

B = sparse(i,j,k);

if nB > 1,
    B = -B/normest(B);
else
    B = -B/norm(B);
end
  
if tailweight > 0
    B  = [[tailweight zeros(1,nr-1)];B;
          [zeros(1,nr-1)] tailweight]; % Tail constraint !
    nB = nB+2;
end
