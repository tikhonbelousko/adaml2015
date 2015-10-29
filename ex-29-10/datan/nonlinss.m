 function [ss,yest] = nonlinss(b,x,y,bfix,model,weights,opt)
%function [ss,yest] = nonlinss(b,x,y,bfix,model,weights,opt)

 if nargin < 7, opt = 1; end

 if opt == 0
    eval(['yest = ' model ';'])
 else
    if length(bfix) > 0
        yest = feval(model,x,b,bfix);
    else
        yest = feval(model,x,b);
    end
 end

 ss = sum(sum(weights.*(y-yest).^2));
