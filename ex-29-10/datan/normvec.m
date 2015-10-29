  function np = normvec(p,no);
% keywords: norms of vectors
% call: np = normvec(p,no);
% The function computes the 2-norms of vectors given as the rows
% of the matrix 'p'. A subset of columns may be given by the index
% vector 'no'
%
% INPUT     p    the input matrix
%           no   the norms of p(i,no) are computed.
%                OPTIONAL. Default: all columns
%
% OUTPUT    np   the respective norms
 
 [r,c] = size(p);
 if nargin ==1 
    no = 1:c;
 end

 pp = p(:,no)';
 np = sqrt(sum(pp.^2))';

