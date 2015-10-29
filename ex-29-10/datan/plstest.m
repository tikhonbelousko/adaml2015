  function [gcv,sbic,cmd,ry2,cse,crmd] = plstest(X,Y,P,Q,W,dim)
% keywords: PLS, multivariate analysis, chemometrics
% function [gcv,sbic,cmd,ry2,cse,crmd] = plstest(X,Y,P,Q,W,dim)
% Calculates different validation criteries of the right dimension. 
% INPUT	:	X,Y 	  data matrixses
%		P,Q,W     matrixses from operation PLS
%		dim    	  maximal dimension
% OUTPUT:       gcv	  generalized crossvalidation criterion
%		sbic	  Schwarz's Bayesian information criterion          
%		cmd       mean absolute deviation            
%		ry2	  r-squared
%		cse	  standard deviation for error 
%		crmd      mean relative absolute deviation

[mx,nx]	=	size(X);
[my,ny]	=	size(Y);
gcv     =       zeros(dim,1);
sbic    =       zeros(dim,1);
cmd     = 	zeros(dim,1);
crmd	=	zeros(dim,1);
cse     =       zeros(dim,1);		
ry2	=	zeros(dim,1);
totvary =	(norm(Y,'fro'))^2;
I	=	find(Y == 0);
[mi,ni] = 	size(I);
if mi > ny
	disp('Suhtaudu varoen crmd:hen, silla matriisissa y on nollia !');
end;
errorx 	=	X;
	for i = 1:dim
	  plsy	      = plspred(X,P,Q,W,i);
	  errory      = Y - plsy;
	  varei	      = (norm(errory,'fro'))^2;
	  var         =	varei/(my*ny);
          cse(i,:)    = sqrt(var);
	  cmd(i,:)    = sum(sum(abs(errory)))/(my*ny);
          if mi == ny
	  	crmd(i,:)   =	sum(sum(abs(errory./Y)))/(my*ny);
	  else
		crmd(i,:)   =	sum(sum(abs(errory./(Y+eps))))/(my*ny);
	  end;
	  ry2(i,:)    = 100 * (1 - varei/totvary);	
	  t	      = errorx*W(:,i);
	  errorx      = errorx - t*P(:,i)';
	  press       =	(diag(errory'*errory))';
	  se(i,:)     =	sqrt(press/my);
    	  con2        = (i/my)*log(ny*my);	
   	  sbic(i,:)   =	con2 + log(var);
	  if i ~= my
		con1  	= 1 + i*(2 - i/my)/(my*(1 - i/my)^2);
		gcv(i,:)= con1*var;
	  end;	
end;
