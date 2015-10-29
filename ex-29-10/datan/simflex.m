function [x,y,ierr] = simflex(f,x0,tol,bounds,ibound,a,iprint,varargin)
% keywords: Nelder-Mead simplex, optimization
% call: [x,y,ierr] = simflex(f,x0,tol,bounds,ibound,a,iprint,P1,...
% P2,P3,P4,P5,P6,P7,P8,P9,P10)
% The function computes the minimum of the (nonlinear) function
% given in the string 'F', within the simple bounds in 'bounds'.
% Additional parameters, useful e.g. in transmitting data in least
% squares fitting,  in 'F' may be given in the matrices P1..10.
% INPUT:  f             the objective function of the form f(x,P1)
%                      (or f(x,P1,P2) or ... f(x,P1,...,P10)
%         x0            initial guess for the arguments of f
%         tol(1)        a variance tolerance for the values of f
%         tol(2)        a relative var. tolerance for the values of f
%         tol(3)        maximum number of iterations
%         bounds        bounds(1,:) <--> lower bounds for x
%                       bounds(2,:) <--> upper bounds for x
%         ibound        types of the bounds (-1 lower, +1 upper,
%                       2 both, 0 none)
%         a             the relative size of the simplex
%         iprint        printing option. monitore progress at each iprint'th
%                       iteration (iprint = 0:  no print, )
%         P1            optional parameters (there can up to ten of these)
% OUTPUT: x             the solution of min w.r.t. x f(x)
%         y             the final value of f
%         ierr          termination codes
%         bounds        Bounds for 'constrai', in the form [lower;upper].

%         the initial values are transformed to unbounded ones

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.4 $  $Date: 2003/09/10 10:04:52 $

m = length(x0);
if nargin == 6, iprint=1; end
if nargin == 5, iprint=1; a=0.1; end
if nargin == 4, iprint=1; a=0.1; ibound=2*ones(m,1); end
if nargin == 3, 
  iprint=1; a=0.1;
  ibound=zeros(m,1);
  bounds=zeros(2,m); 
end
if nargin == 2, 
  iprint=1; a=0.1; ibound=zeros(m,1);
  bounds=zeros(2,m); tol=[.0001 .0001 100]; 
end

if length(tol) == 0, tol = [.0001 .0001 100]; end
if length(bounds) == 0, bounds = zeros(2,m) ; end
if length(ibound) == 0, ibound=zeros(m,1); end
if length(a) == 0, a = 0.1; end
if length(iprint) == 0, iprint = 1; end

itmax = tol(3);
tol   = tol(1:2);
      
x0 = x0(:);
x0 = constrai(x0,ibound,bounds,-1);
reflection=1.0; expansion=2.0; contraction=0.5;               
      
%     m‰‰ritet‰‰n aloitussimplex
s = zeros(m+1,m+1);
%     a = ?

s(1:m,1) = x0;

p  = zeros(m,1);
p1 = zeros(m,1);

if length(a) == 1
  k     = find(abs(x0)>0);
  if length(k) > 0
    p1(k) = x0(k)*a*(sqrt(m+1)+m-1)/(m*sqrt(2));
    p(k)  = x0(k)*a*(sqrt(m+1)-1)/(m*sqrt(2));
  end
  k     = find(abs(x0)==0);
  if length(k) > 0
    p1(k) = ones(length(k),1)*a*(sqrt(m+1)+m-1)/(m*sqrt(2));
    p(k)  = ones(length(k),1)*a*(sqrt(m+1)-1)/(m*sqrt(2));
  end
  s(1:m,2:m+1) = diag(p1)+p*ones(1,m)-diag(p) + x0*ones(1,m);
else
  p1=a*(sqrt(m+1)+m-1)/(m*sqrt(2));
  p =a*(sqrt(m+1)-1)/(m*sqrt(2));
  s(1:m,2:m+1) = diag(p1)+p*ones(1,m)-diag(p) + x0*ones(1,m);
end

if itmax == 0
  x0 = constrai(x0,ibound,bounds,1);
  y  = feval(f,x0,varargin{:});
  x  = x0;
  return
end

%     sijoitetaan funktion f arvot simpleksin s s‰rmiss‰
%     s:n riville m+1
for i=1:m+1
  x0       = constrai(s(1:m,i),ibound,bounds,1);
  s(m+1,i) = feval(f,x0,varargin{:});
end

%     j‰rjestet‰‰n s:n sarakkeet rivin m+1 mukaan kasvavaan j‰rjestykseen

iterations=0;

while iterations < itmax
  iterations=iterations+1;    % iterate
  [apu,ind] = sort(s(m+1,:));
  s         = s(:,ind);
  %     konvergenssitestit
  if iprint~=0
    if rem(iterations,iprint) == 0
      disp(iterations)
      disp([s(m+1,m+1),s(m+1,1)])
      x0 = constrai(s(1:m,[1 m+1]),ibound,bounds,1);
      if iprint < 0, disp(x0'); end
    end
  end
  ymean = mean(s(m+1,:));
  test1 = std(s(m+1,:));
  test2 = abs(test1/ymean);

  if test1 < tol(1) | test2 < tol(2)
    ierr = 0;
    if test2 > tol(2)
      ierr = 1;
    elseif test1 > tol(1)
      ierr = 2;
    end
    x0 = constrai(s(1:m,1),ibound,bounds,1);
    y  = feval(f,x0,varargin{:});
    x  = x0;
    return
  end
  %     lasketaan keskipiste ilman huonointa (so. m+1:nnetta)
  xcentre = mean(s(1:m,1:m)')';
  %     peilaus; huom! huonoin <-> s(.,m+1) ja paras <-> s(.,1)
  xreflection = (1+reflection)*xcentre-reflection*s(1:m,m+1);

  x0 = constrai(xreflection,ibound,bounds,1);
  yreflection = feval(f,x0,varargin{:});

  if yreflection <= s(m+1,1)          % peilaus paras
    %     jatko (=expansion)
    xexpansion = (1+expansion)*xcentre - expansion*s(1:m,m+1);
    x0 = constrai(xexpansion,ibound,bounds,1);
    yexpansion = feval(f,x0,varargin{:});

    if yexpansion <= yreflection    % jatko paras
      s(1:m,m+1) = xexpansion;
      s(m+1,m+1) = yexpansion;
    else   % peilaus parempi kuin jatko 
      s(1:m,m+1) = xreflection;
      s(m+1,m+1) = yreflection;
    end
  elseif yreflection >= s(m+1,m)        % peilaus vah. 2. huonoin
    %     valitaan parempi kahdesta huonoimmasta
    if yreflection < s(m+1,m+1)       % peilaus 2. huonoin
      s(1:m,m+1) = xreflection;
      s(m+1,m+1) = yreflection;
    end
    %         kutistus (=contraction)
    xcontraction = contraction*s(1:m,m+1) + (1-contraction)*xcentre;
    x0 = constrai(xcontraction,ibound,bounds,1);
    ycontraction = feval(f,x0,varargin{:});
    if ycontraction > s(m+1,m+1)       % kutistus huonoin 
      %         tayskutistus (= total contraction)
      disp('total contraction')
      s(1:m,2:m+1) = .5*(s(1:m,ones(1,m))-s(1:m,2:m+1))+xcentre(:,ones(1,m));
      x0 = constrai(s(1:m,:),ibound,bounds,1);
      % kutistetun simpleksin y:t:
      for i=1:m+1
        x0       = constrai(s(1:m,i),ibound,bounds,1);
        s(m+1,i) = feval(f,x0,varargin{:});
      end
    else          %  kutistus parempi kuin huonoin 
      s(1:m,m+1) = xcontraction;
      s(m+1,m+1) = ycontraction;
    end
  else      %  peilaus parhaan ja 2. huonoimman v‰liss‰
    s(1:m,m+1) = xreflection;
    s(m+1,m+1) = yreflection;
  end
end         %    while iterations

if iterations < itmax
  return
else
  ierr = 3;
  x0 = constrai(s(1:m,1),ibound,bounds,1);
  y  = feval(f,x0,varargin{:});
  x  = x0;
end
