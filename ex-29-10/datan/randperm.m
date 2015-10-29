  function y=randperm(n)
% keywords: data manipulation
% call: y=randperm(n)
% The function computes a random permutation the sequence 1:n into
% the  vector 'y'

vers=abs(version); vers = vers(1);
if vers<53
  rand('uniform')
end

ind=1:n; ind=ind'; y=ind;

for i=n:-1:2
    j=max(1,ceil(rand*i));
    y(i)=ind(j); ind=remove(ind,[j],[]);
end

y(1)=ind(1); y = y(:)';
