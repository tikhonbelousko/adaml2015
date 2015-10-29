  clc
  echo on
% keywords: demo
% This demonstration deals with the analysis of ecological data. As
% the data we have macrophyte (aquatic plants) results of 59 small
% forest lakes situated mainly in southern and central Finland. The
% data has been sampled in 1984-87 as a part of the biological lake
% survey of the HAPRO project (the Finnish Acidification Research
% Programme) (the results are published in [Kauppi, P., Anttila, P &
% Kenttamies, K. 1990 (eds.). Acidification in Finland. Springer-Verlag,
% Heidelberg. 1237 p.]) The main objective of the macrophyte study is
% to find out if airborne acidification has any effects on macrophytes
% with a special interest of indicator species (species either gaining
% or suffering from airborne acidification).

% At each lake, a rough estimate of the abundance of the taxa was
% recorded on  a scale of 1 to 5 (1=rare, 2=occasional, 3=frequent,
% 4=common, 5=abundant). Also water chemistry was analyzed for several
% parameters of which lake water colour 'COLO', conductivity
% 'CONDUC', acidity 'PH', total nitrogen 'TOTP' and phosphorus 'TOTP',
% calcium 'CA' and reactive aluminium 'ALR' were selected for this
% demonstration.

 pause, clc % strike any key to continue ...


  load x5                   % load the data (in the lakes/species form)
                            % chemical data and the names of macrophyte
                            % taxa are written in acidvar.m

  echo off; acidvar; echo on
% Let us assume that we like to analyze only a part of the data matrix.
% In this case lakes situated in southern Finland (lakes (rows) 1-36,
% 38-47,69-81) would be interesting, because acidic deposition is
% strongest in this region. So the rest of the lakes have to be removed.

  i = [37,48:68,82:97];      % the lakes to be removed
  X = remove(x5,i);
  clear x5;

% After this removal some macrophyte taxa may not be present any more
% (some columns consist only of zeros). These taxa (columns) have to be
% found and removed.


  ii = find(max(X)==0);      X = remove(X,[],ii);

pause, clc % strike any key to continue ...



% Also chemical data of the removed lakes and the names of removed
% macrophytes have to be deleted:


 names    = remove(names,ii);
 chemvar  = remove(chemvar,i);

 X = X';                   % transpose the data: species/lakes

% Now we are ready to start the analysis. As a first step, we study only the
% species/cites data in the 36 x 59 abundance matrix using the Correspondence
% Analysis, CA:

 pause, clc % strike any key to continue ...

% The idea of CA is to correlate the species and lakes. A quantification
% of the correlation is done by giving each species and lake a numerical
% value, 'score'. The values are computed so that the vectors of the species
% scores 'u' and lakes scores 't' have a maximal correlation coefficient.
%
% By sorting the species and lakes in the order of the values in 'u' and
% 't' we get an 'ordination' of the observations: the lakes are in an
% order that maximally follows the abundances of different species. Vice
% versa, we hope to be able to say something about a lake by just
% observing the species in it. We may have a look at this 1-dimensional
% ordination by using the functions SORTMAT and PLOTMAT.
%
% Having found the maximal correlation, we continue by calculating the
% next best values - in independent directions, very much like in PCA
% analysis. In fact, CA is algorithmically a variation of PCA, and the
% CA 'principal scores' are computed all at once. 2-dimensional CA
% ordination figures can be plotted just like in PCA analysis, using
% the functions PLOTPCA, PLOTBI.

 pause, clc % strike any key to continue ...

 pack                    % save memory (of small machines!)
 [u,t,l,m,n] = ca(X);    % compute the species/sites scores u/t,  wait ...

% Consider first the 1-dimensional ordination. We re-order the rows
% (species) of 'X' according to the values in u(:,1), and similarly
% the columns (lakes) with t(:,1):

 [Xsort,irow,icol] = sortmat(X,u(:,1),t(:,1));

% Let us see the difference. First, the original matrix, with positive
% entries marked with a '*' (see the function PLOTMAT), and then (strike
% return) the sorted one:

 pause, clc % strike any key to continue ...
 echo off
 plotmat(X);
 title(' *: the species is present')
 xlabel(' lakes '), ylabel('  species ')
 pause
 plotmat(Xsort);
 title(' *: the species is present')
 xlabel(' lakes '), ylabel('  species ')
 pause
 clc
 echo on
%
% The order in which the rows and columns appear in the last picture are
% given in the vectors 'irow', 'icol'.
%
% Clearly the sorting already gives some idea of the correlations. However,
% a more illuminating picture is obtained by 2-dimensional ordination.
% We make a biplot where the species are represented as points (u(:,1),
% u(:,2)) and lakes as points (t(:,1), t(:,2)). The pairs u(:,1), t(:,1)
% were chosen so as to be maximally correlated, the pairs u(:,2), t(:,2)
% have the 'second best' correlations. This means that in the plot the
% points representing species and lakes are also correlated, i.e., in
% the same directions. So we may see how the species and lakes go
% together. Use the function BIPLOT.

 echo off
 plotbi(t,u,1,2,1:59,1:59,names,1:36);
 pause

 clc
 echo on

% Often a plot is too crowded. We might be more interested in the extreme
% cases and willing to skip the points in the centre, supposed to be
% less important for ordination. We can easily do this, using the
% function NORMVEC and the subset indexing possibility of BIPLOT
% (points nearest the origin of the plot have the smallest norms) :
%

 tn = normvec(t,1:2);
 un = normvec(u,1:2);
 [tnsort,it]=sort(tn);    % 'it' contains the increasing order of 'tn'
 [unsort,iu]=sort(un);    % 'iu' contains the increasing order of 'un'

% Take only the last 35:59 and 20:36 points with

% plotbi(t,u,1,2,1:97,it(35:59),names,iu(20:36))

  pause, clc % strike any key to continue ...

  echo off
  plotbi(t,u,1,2,1:97,it(35:59),names,iu(20:36))
  pause

  clc
  echo on
% More conveniently, you might just say:
%   'plotbi(t,u,1,2,1:97,-25,names,-17)'.
% The lefthand side of the biplot is still too crowded and it would need
% a further separation, but let us concentrate in this demonstration on
% the four taxa lying separately on the right hand side.
% POLYAMPH and GLYCFLUI seem to correlate well with a few lakes (7 and
% 6,41 respectively), which suggests that these species serve as 'outliers',
% they are found in these lakes only. This can be checked ??? (joku
% rutiini, onko tarpeen).
% HIPPVULG and especially SPHASPEC seem to correlate with a larger group
% of lakes. A simple way of testing some preliminary hypotheses is to
% label the sites in the biplot with some measured chemical varibles.
% SPHASPEC is a well-known taxa of acidic habitats, so it is most probable
% that sites near SPHASPEC have a low ph. Let us select lakes with pH
% below 5.0, and label them with the pH values. pH is the second of
% the variables in the matrix 'chemvar', so the plot is done with
%
% ph = chemvar(:,2);
% plotbi(t,u,1,2,ph,find(ph < 5),names,iu(20:37))
 axis;   % use the axis of the previous plot, to facilitate comparison
 pause, clc % strike any key to continue ...

 echo off
 ph = chemvar(:,2);
 plotbi(t,u,1,2,ph,find(ph < 5),names,iu(20:36))
 pause
 axis      % self-scaled, free axis back again
 clc
 echo on

%
% The lakes with abundant SPHASPEC and low pH seem to have a good
% correlation: SPHASPEC might be taken as an indicator for acidic
% lakes. Species suffering from acidification might be found on the
% opposite, lefthand side of the biplot and this could be analyzed
% in a similar way.

% You may also label the lakes with the SAGISAGI values (x5(:,35))
% to check other hypotheses - and continue with similar
% suggestions. 
%
  pause, clc % strike any key to continue ...
% The PLS algorithm is especially suitable for correlating an 'X' matrix
% with multiresponse data. PLS is a principal component method, where
% principal components are computed on both 'X' and 'Y' data, and
% correlated with each other. So loading values are obtained for variables 
% on both 'X' and 'Y' sides, and both types of variables can then be 
% studied in a single biplot.
%
% Let us apply PLS to our data. Now we take each lake as an observation with
% the species abundances as the variables. The chemical variables are 
% regarded as the multidimensional 'responses'.
%
% Before embarking in the calculations, we should give a thought to 
% possible manipulations of the data. Often a data matrix is unbalanced,
% different variables being measured at widely different scales. A variable
% expressed in 'large' numerical values will then unjustly dominate the 
% results. In our case, the variable NTOT assumes maximal values 1000, while
% the other variables are of size 1. So we better use, e.g., the function
% SCALE for 'y'. All the variables in 'x' are between 0 and 5, so we may 
% take 'x' as such     

 x = X';
 x = center(x);  y = scale(chemvar);

pause, clc % strike any key to continue ...

% Now, compute the PLS matrixes, with maximally 5 principal dimensions:

 [t,p,q,w] = pls(x,y,5);

% Next have a biplot look at the variables on 'x' and 'y' sides. The
% 'x' variables are represented by the loadings 'p', the 'y' variables
% by 'q'. So, to plot the two principal loadings, give the command

% plotbi(p,q,1,2,names,1:36,chemname,1:7)

 pause, clc % strike any key to continue ...

  echo off
  plotbi(p,q,1,2,names,1:36,chemname,1:7)
  pause
  clc 
  echo on
% In the biplot the connection of SPHASPEC with lake water acidity is
% clear: high ph-values (label ph in the righthand side) and high
% SPHASPEC abundances on the opposite site show a very strong negative
% correlation. Acidic lakes have high concentrations of labile
% aluminium, which can be clearly seen in the biplot.

% A very interesting result is the location of ISOESPEC and LOBEDORT.
% (opposite direction of COLO, so the correlation with water colour is negative).
% These taxa are typical of clearwater lakes sensitive to acidification.
% The biplot suggests two interesting hypotheses. First, SPHASPEC are
% not found in clearwater lakes, but only in slightly coloured lakes,
% which are usually naturally acidic because of humic acids. This could
% mean that lake water acidification has not been very serious in Finland.
% In Sweden, for example, acidification has resulted in a mass invasion
% of SPHASPEC of many clearwater lakes with LOBEDORT and ISOESPEC. Second
% hypotheses would suggest the opposite: SPHASPEC invasion has been so
% massive that it has suppressed the growth of LOBEDORT and ISOESPEC.
% These hypotheses can now be analyzed in more detailed.

