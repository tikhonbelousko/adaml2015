  function ir = irand(a,b,no);
% keywords: random numbers
% function ir = irand(a,b,no)
% The function generates 'no' number of random integer numbers
% in the range [a,b].
% INPUT		a,b	the range in which numbers are to be generated
%               no      the number of random numbers to be generated
% OUTPUT        ir      vector of lenght 'no' containing random numbers

vers=abs(version); vers = vers(1);
if vers<53
  rand('uniform')
end

r  = rand(1,no);
ir = ceil((b-a+1)*r) + a -1  ;
