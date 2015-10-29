  function y=logistic(x,b)
% keywords: logistic function, growth curve
% call: y=logistic(x,b)
% The function computes values for the logistic functions
%
%                     b(2,:) - b(1,:)
%    y = b(1,:) +  -------------------------
%                  1 + exp(-(x - b(3,:))./b(4,:))
%
% INPUT
%          x     the argument values, a matrix with one *column* for
%                each column in 'b' (a single column vector is
%                used as a copy for all columns in 'b')
%          b     the logistic function parameters as given above
%                (a 4 x n matrix)
% OUTPUT
%          y     the values of the functions at the points 'x'
%                (given in the columns)

 [nb,n]=size(b);
 [nx,nn] = size(x);
 if nn==1 x=x*ones(1,n);  end  %copy the same x for all b
 y  = zeros(nx,n);

 b3 = ones(nx,1)*b(3,:);
 b4 = ones(nx,1)*b(4,:);

 z = (x-b3)./b4;

 for k=1:n

  i = find(abs(z(:,k)) <  20);
  j = find(abs(z(:,k)) >= 20);

  if length(i) > 0
    b1 = ones(length(i),1)*b(1,k);
    b2 = ones(length(i),1)*b(2,k);
    b3 = ones(length(i),1)*b(3,k);
    b4 = ones(length(i),1)*b(4,k);
    y(i,k) = b1 + (b2-b1).*(ones(length(i),1)./(1+exp(-z(i,k))));
  end

  if length(j) > 0
    b1 = ones(length(j),1)*b(1,k);
    b2 = ones(length(j),1)*b(2,k);
    b3 = ones(length(j),1)*b(3,k);
    b4 = ones(length(j),1)*b(4,k);
    y(j,k) = b1.*(z(j,k) < 0) + b2.*(z(j,k) >= 0);
  end

 end
