  function [sorta,ordv1,ordv2] = sortmat(a,v1,v2);
% keywords: sorting
% call: [sorta,ordv1,ordv2] = sortmat(a,v1,v2);
% The function sorts the rows and columns of the matrix 'a'
% according to the increasing order of the components of the
% vectors 'v1' and 'v2', respectively. Useful, e.g., together
% with PLOTMAT in CA analysis.
%
% INPUT
%                a      the matrix to be sorted
%                v1     the rows of 'a' are sorted with 'v1'
%                v2     the columns of 'a' are sorted with 'v2'
% OUTPUT
%                sorta  the sorted version of 'a'
%                ordv1  the order of the original rows in 'sorta'
%                ordv2  the order of the original columns in
%                       'sorta'

  [vv,ordv1] = sort(v1);
  [vv,ordv2] = sort(v2);

  v1     = v1(:);
  va     = [v1 a];
 [m,n]   = size(va);
  va     = sortrow(va,1,1);
  a1     = va(1:m,2:n);

  v2     = v2(:)';
  va     = [v2;a1]; [m,n] = size(va);
  va     = sortcol(va,1,1);
  a2     = va(2:m,:);

  sorta  = a2;
