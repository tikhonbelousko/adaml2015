  function plotpca(t,i,j,label,ind,line);
% keywords: principle components, multivariate analysis, plot
% function plotpca(t,i,j,label,ind,line);
% the function plots  a 'score' or 'loading' principal component
% (PCA, PLS) picture of observations.
%
% INPUT
%         t      a matrix whose columns give the scores/loadings
%                to be plotted
%         i,j    the indexes of the principal components (columns of 't')
%                plotted
%         label  the text for each point in the plot
%                OPTIONAL, default: no label 
%                (example: give 'label = 1:n' to label with the 
%                          n.of observations or variables)
%         ind    the indexes of the observations/variables labelled
%                OPTIONAL, default: all labelled
%                (Example: to choose and label the points according to the
%                 values of variable 'v' set "label = v;
%                                             ind = find(v>=lower & v<=upper)")
%         line   linetype '-' draws lines between the points (DEFAULT line='.')
%  REMARK  If you only want to plot n observations with largest
%          score norms, give 'ind = - n'.

 n = length(t(:,i));
 if nargin == 5, line = '.'; end
 if nargin < 5 
    ind = 1:n; line = '.';
 end
 if length(ind) == 0, ind = 1:n; end

 if ind  < 0
    tnorm = normvec(t,[i j]);
    [maxt,maxind] = sortrow(tnorm,1,2);
    ind = maxind(1:-ind);
 end

 t1 = t(:,i);
 t2 = t(:,j);

 plot(t1,t2,line);

 if nargin >= 4
  if max(size(label)) > 0
    if isstr(label)==0
       label = strvec(label(ind));
    else
       [ml,nl] = size(label);
       label   = label(ind,1:nl);
    end
    text(t1(ind),t2(ind),label)
  end
 end

