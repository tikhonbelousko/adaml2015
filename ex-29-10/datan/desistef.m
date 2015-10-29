  function [D,Dij] = desistef(X,b);
% keywords: demo
% function [D,Dij] = desistef(X,b);
%
% desirability subroutine for stero demo optimization by 'simflex'
%

 sel  = [];
 X    = X(:)';
 X2   = intera(X);
 vnor = [1 X2]*b;
 
 for i=1:6;
     j=i+1:7;
     sel = [sel vnor(i)*oneg(j)./vnor(j)];
 end
 nsel = length(sel);

 x0   = 1; sig = 0.00006; nexp = 4;

 Dij  = 1-exp(-(sel-x0).^nexp/sig);
 D    = -prod(Dij).^(1/nsel);
