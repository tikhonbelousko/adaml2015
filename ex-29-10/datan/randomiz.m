  function randx = randomize(x);
% keywords: data manipulation
% call: randx = randomize(x);
% The function reorders the rows of x in a random order
%

  [m,nx] = size(x);
  ir     = irand(1,m,m); [sir,si]  = sort(ir);
  randx  = sortrow([si',x],1,1); 
  randx  = randx(:,2:nx+1); 
