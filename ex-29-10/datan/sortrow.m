  function [sx,sind] = sortrow(x,i,ido);
% keywords: sorting
% call: [sx,sind] = sortrow(x,i,ido);
% The function sorts the rows of matrix 'x' according the column i.
%
% INPUT :       x       the matrix to be sorted
%               i       the column according to which the matrix is to
%                       be sorted
%               ido     1:  increasing order
%                       2:  descending order
% OUTPUT:       sx      the sorted matrix
%               sind    sorting key

[is,sind] = sort(x(:,i));

 if ido==2 
    mind = max(size(sind)); i = [mind:-1:1]'; sind = sind(i,:);
 end;

 sx = x(sind,:);

