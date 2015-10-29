function plotbi(t,p,i,j,labelt,indt,labelp,indp,symbolt,zoomp);
% keywords: bi-plots
% call: plotbi(t,p,i,j,labelt,indt,labelp,indp,symbolt,zoomp);
% The function plots a 'biplot' of scores and loadings of principal
% component (PCA, PLS) vectors.
% INPUT t       the score matrix, whose columns give the scores
%               to be plotted
%       p       the corresponding loading matrix
%       i,j     the indexes of the principal components (columns of 't'
%               and 'p') to be plotted
%       labelt  the labelt text for each score point in the plot
%               OPTIONAL, default: no label (example: the n. of observations)
%       indt    the indexes of the observations plotted
%               OPTIONAL, default: all plotted
%                (Example: to choose and label the points according to
%                 values of variable 'v' set "label = v;
%                                             ind = find(v>=lower & v<=upper)")
%       labelp  the labelt text for loadings
%               OPTIONAL, see 'labelt'
%       indp    the indexes of the variables plotted, see 'indt'. OPTIONAL
%               REMARK1: to get labels for 'p' only, set 'labelt = []'
%               REMARK2: to plot only n/m observations/variables with
%               largest scores or loadings, set 'indt = -n' , 'indp = -m'
%       symbolt the plot symbol for 't'. OPTIONAL, default '.' .
%       zoomp   a zooming factor for the p-vectors.
%               OPTIONAL,default zoomp=1.

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/08 17:30:28 $

[mt,nt] = size(t); [mp,np] = size(p);

 if nargin == 9
    zoomp=1;
 elseif nargin == 8
    zoomp=1;symbolt = '.';indp = indp(:);
 elseif nargin == 7
    zoomp=1;symbolt = '.';indp = [1:mp]';
 elseif nargin == 6
    zoomp=1;symbolt = '.';indp = [1:mp]';labelp = [];
    indt = indt(:);symbolt = '.';
 elseif nargin == 5
    zoomp=1;symbolt = '.';indp = [1:mp]';labelp = []; indt = [1:mt]';
 elseif nargin == 4
    zoomp=1;symbolt = '.';indp = [1:mp]';labelp = []; indt = [1:mt]'; labelt = [];
 elseif nargin < 4
    error('too few inputs !');
 end

 if length(zoomp)==0,  zoomp=1; end
 if length(symbolt)==0,symbolt='.';end
 if length(indp) == 0, indp = [1:mp]'; end
 if length(indt) == 0, indt = [1:mt]'; end

 if indp < 0
    pnorm = normvec(p,[i j]);
    [maxp,maxind] = sortrow(pnorm,1,2);
    indp = maxind(1:-indp);
 end
 if indt < 0
    tnorm = normvec(t,[i j]);
    [maxt,maxind] = sortrow(tnorm,1,2);
    indt = maxind(1:-indt);
 end

 t1 = t(indt,i); p1 = p(indp,i);
 t2 = t(indt,j); p2 = p(indp,j);
 tt = [t1 t2];   pp = [p1 p2];
 np = length(indp);
 nt = length(indt);
 for i = 1:np, normp(i) = norm(pp(i,:)); end
 for i = 1:nt, normt(i) = norm(tt(i,:)); end
 alfa  = 0.9*max(normt)/max(normp);
 alfa  = zoomp*alfa;

 if length(indp)==1, p1aux=[p1';0]; else p1aux = [p1'; zerog(indp)']; end
 p1aux = p1aux(:);
 tot1  = [p1aux;t1];

 if length(indp)==1, p2aux=[p2';0]; else p2aux = [p2'; zerog(indp)']; end
 p2aux = p2aux(:) ;
 tot2  = [p2aux;t2];

 pp = [alfa*tot1(1:2*np), alfa*tot2(1:2*np)];
 tt = [tot1(2*np+1:2*np+nt),tot2(2*np+1:2*np+nt)];

 vers=abs(version); vers = vers(1);
 if vers < 53
    plot(pp(:,1),pp(:,2),'w-', tt(:,1),tt(:,2),symbolt);
 else
    plot(pp(:,1),pp(:,2),      tt(:,1),tt(:,2),symbolt);
 end

 if nargin >= 5
   if length(labelt) > 0
      if isstr(labelt)==0
         labelt  = strvec(labelt(indt));
      else
         [ml,nl] = size(labelt);
         labelt  = labelt(indt,1:nl);
      end
      text(tt(:,1)+.02*max(normt),tt(:,2),labelt);
   end
 end

 if nargin >= 7
   if length(labelp) > 0
      if isstr(labelp)==0
         labelp  = strvec(labelp(indp));
      else
         [ml,nl] = size(labelp);
         labelp  = labelp(indp,1:nl);
      end
      text(pp(1:2:2*np-1,1),pp(1:2:2*np-1,2),labelp);
   end
 end
