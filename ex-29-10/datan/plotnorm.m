
  function plotnorm(x,labelvar)
% function plotnorm(x,labelvar)
% The function draws a normal plot of the vector 'x'. If the elements of
% 'x' are normally distributed, the points in the plot should approximatively
% lay on a straight line.
% INPUT
%             x         the vector to be plotted
%             labelvar  a variable for point labels
%

 x     = x(:);
 [r2,j] = sort(x);
 l1     = length(x);
 u      = ones(l1,1);
 for k=1:l1,
    p  = (k-0.5)/l1;       % Probability values  F(u) for normal plot
    a1 = 2.30753;a2=0.27061;a3=0.99229;a4=0.04481;
    p1 = 0.5+abs(p-0.5);
    t  = sqrt(-2*log(1-p1));
    w  = a1+a2*t;
    w  = w/(1+t*(a3+a4*t));
    w  = t-w;
    if p>=0.5,
        u(k)=w;    % u = normal score for the plot
    else
        u(k)=-w;
    end
 end
 r3(:,[1])=r2(1:l1,1);
 axis('square')
 if nargin == 1
     plot(r3,u,'*')
 elseif nargin == 2
     plot(r3,u,'.')
     text(r3,u,strvec(labelvar(j)))
 end
 title('Normal probability plot');
 xlabel('Argument values');
 ylabel('Normal score u');
 grid;
 axis('normal')

