  function xtransf = constrai(x,ibound,bounds,inv)
% keywords: simplex, constrained optimization, Nelder-Mead algorithm
% call: xtransf = constrai(x,ibound,bounds,inv)
% If inv equals to 1 this routine transforms the free variables
% to bounded ones according to ibound & bounds.  If inv equals to -1
% an inverse transformation is done. This is needed for calculation
% of the initial values of the free variables - the user gives
% initial values in units that have physical meaning i.e. initial
% values for the bounded variables.
%
% INPUT:
%      n                              n of parameters and
%      x(1:n)                         parameters to be optimized
%      ibound(1:n)
%      bounds(1:2,1:n)                parameters to be optimized
%      inv                            see text above
      
      ibound = ibound(:);
      [n,colx] = size(x);

      if inv == 1

          ilb     = find(ibound == -1);
          iub     = find(ibound ==  1);
          bb      = zeros(length(ibound),1);
          bb(ilb) = bounds(1,ilb)';
          bb(iub) = bounds(1,iub)';

          k = find(abs(ibound) == 1);

          if length(k) >0;
              j = ones(1,colx);
              xtransf(k,:) = bb(k,j) - ibound(k,j).*x(k,:).^2;
          end

          k = find(abs(ibound) == 2);

          if length(k) >0;
              a       = bounds(1,k)';
              b       = bounds(2,k)';
              aplusb  = (a+b)/2;
              bminusa = b-a;
              j       = ones(1,colx);
              xtransf(k,:) = aplusb(:,j) + bminusa(:,j).*sin(x(k,:))/2;
          end

          k = find(abs(ibound) == 0);

          if length(k) >0;
              xtransf(k,:) = x(k,:);
          end

      elseif inv == -1

          ilb     = find(ibound == -1);
          iub     = find(ibound ==  1);
          bb      = zeros(length(ibound),1);
          bb(ilb) = bounds(1,ilb)';
          bb(iub) = bounds(1,iub)';

          k = find(abs(ibound) == 1);

          if length(k) >0;
              j = ones(1,colx);
              xtransf(k,:) = sqrt(ibound(k,j).*bb(k,j) - x(k,:));
          end

          k = find(abs(ibound) == 2);

          if length(k) >0;
              a       = bounds(1,k)';
              b       = bounds(2,k)';
              aplusb  = (a+b)/2;
              bminusa = b-a;
              j       = ones(1,colx);
              a       = (2*(x(k,:)-aplusb))./bminusa;
              a       = a.*(abs(a)<=1) + (abs(a)>1);
              xtransf(k,:) = asin(a);
          end

          k = find(abs(ibound) == 0);

          if length(k) >0;
              xtransf(k,:) = x(k,:);
          end

      end
