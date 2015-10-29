 function yest = nonljac(x,b,bfix,model,weights)
%function yest = nonljac(x,b,bfix,model,weights)

if length(bfix) > 0
    yest = feval(model,x,b,bfix).*weights;
else
    yest = feval(model,x,b);
    yest = yest.*weights;
end
