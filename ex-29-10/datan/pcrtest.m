  function [gcv,sbic,cmd,ry2,cse,crmd] = pcrtest(X,Y,P,Q,dim);
% keywords: principal components, regression, multivariate analysis
% call: [gcv,sbic,cmd,ry2,cse,crmd] = pcrtest(X,Y,P,Q,dim);
% The function calculates several validation criteria to find the right
% dimension for a PCR model.
%
% INPUT :       X,Y       the data matrices
%               P,Q       the matrices from operation PCR
%               dim       the maximal dimension
% OUTPUT:       gcv       generalized crossvalidation criterion
%               sbic      Schwarz's Bayesian information criterion
%               cmd       mean absolute deviation
%               ry2       r-squared
%               cse       standard deviation for error
%               crmd      mean relative absolute deviation

[mx,nx]	=	size(X);
[my,ny]	=	size(Y);
gcv     =       zeros(dim,1);
sbic    =       zeros(dim,1);
cmd     = 	zeros(dim,1);
crmd	=	zeros(dim,1);
cse     =       zeros(dim,1);
ry2	=	zeros(dim,1);	
totvary = 	(norm(Y,'fro'))^2;	
%totvary	=	trace(Y'*Y);
I	=	find(Y == 0);
[mi,ni] =	size(I);
if mi > ny
    disp('Take care with crmd, the matrix "Y" contains zeros!');
end;
	for i = 1:dim
	  pcry	      = pcrpred(X,P,Q,i);
	  errory      = Y - pcry;
	  varei       = (norm(errory,'fro'))^2;
	  var         =	varei/(my*ny);
	  cse(i,:)    = sqrt(var);
	  cmd(i,:)    = sum(sum(abs(errory)))/(my*ny);
	  if mi == ny
		crmd(i,:) = sum(sum(abs(errory./Y)))/(my*ny);
	  else
		crmd(i,:) = sum(sum(abs(errory./(Y+eps))))/(my*ny);
	  end;  	 
          ry2(i,:)    = 100 * (1 - varei/totvary);	
    	  con2        = (i/my)*log(ny*my);	
   	  sbic(i,:)   =	con2 + log(var);
	  if i ~= my
		con1  	= 1 + i*(2 - i/my)/(my*(1 - i/my)^2);
		gcv(i,:)= con1*var;
	  end;	
        end;

