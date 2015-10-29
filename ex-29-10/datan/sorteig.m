  function [d,v] = sorteig(x);
% keywords: sorting
% call: [d,v] = sorteig(x);
% In case the eigenvalues of a matrix are real, the function returns
% the eigenvalues of it together with the respective eigenvectors in
% a descending order
%
% INPUT
%               x        the matrix
%
% OUTPUT
%               v        the matrix whose columns contain the eigenvectors
%               d        the eigenvalues in descending order

 [v,d] = eig(x);
 d     = diag(d)';

 if sum(abs(imag(d))) > 0
    disp('the eigenvalues not real');
    break
 end

 vv = [d; v];
 vv = sortcol(vv,1,2);
 d  = vv(1,:);

 if nargout == 2
    v  = vv(2:length(d)+1,:);
 end

