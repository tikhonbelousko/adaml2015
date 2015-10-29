  function [sx,sind] = sortcol(x,i,ido);
% keywords: sorting
% call: [sx,sind] = sortcol(x,i,ido);
% The function sorts the columns of matrix 'x' according the row i.
% INPUT :       x       the matrix to be sorted
%               i       the row according to which the matrix is to be sorted
%               ido     1:  increasing order
%                       2:  descending order
%
% OUTPUT:       sx      the sorted matrix
%               sind    the sorting key

[is,sind] = sort(x(i,:));

 if ido==2 
    mind = max(size(sind)); i = mind:-1:1; sind = sind(:,i);
 end
 sx = x(:,sind);
