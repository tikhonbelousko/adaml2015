  function y = randng(x,y);
% keywords: version compability
% call: y = randng(x,y);
% Random numbers from Normal distribution. See RAND.
% NOTE. Only for compatibility between Matlab3.5 and Matlab4.0

vers = abs(version); vers = vers(1);

if vers==51
   rand('normal')
   if (nargin==2)
       y = rand(x,y);
   end
   if (nargin==1)
       y = rand(x);
   end
   if (nargin==0)
       y = rand;
   end
end

if vers>=52
   if nargin==2
      y = eval('randn(x,y)');
   end
   if nargin==1
      if (max(size(x))==1)
          y = eval('randn(x)');
      else
          y = eval('randn(size(x))');
      end
   end
   if nargin==0
      y = eval('randn');
   end
end

