  function iwhich = pick(ifrom,iwhat)
% keywords: set operation
% call: iwhich = pick(ifrom,iwhat)
% The function picks the indexes of the values given
% in the vector 'iwhat' from the vector 'ifrom'.
%
% INPUT:      ifrom     the original vector
%             iwhat     the values whose indexes are retrieved
%
% OUTPUT:     iwhich    vector of picked indexes

 n = length(iwhat);
 k = 0;
 iwhich = [];
 for i = 1:n
    j = find(iwhat(i) == ifrom);
    if length(j) > 0, 
         iwhich =[iwhich j];
    end
  end
