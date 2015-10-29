  function plotmat(a);
% keywords: sparsity plot
% call: plotmat(a)
% The function plots as '*' the non-negative components of the
% matrix 'a'. Useful for checking sparsity, band structure etc.
% NOTE: Edit the file for marks other than '*'.

 [m,n] = size(a);

 indmat = [m:-1:1]'*ones(1,n);
 aa     = a(:);
 i      = find(aa~=0);
 x      = kron(1:n,ones(1,m));

 plot(x(i),indmat(i),'*')

