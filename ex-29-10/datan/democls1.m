clc
echo on
% keywords: demo
% Here we demonstrate some basic 'pattern recognition' problems:
%
%  - the identifation of subgroups or 'patterns' in a data set
%  - how to give a computational representation for a subgroup
%  - the classification of observations: do they belong to a certain
%    subgroup ?
%
% In this demonstration we use the classical 'Iris' data set. The
% data consists of measurements of three species of Iris flowers.
% There are three classes, 50 sample vectors in each. Each observation
% is 4-dimensional, the variables being the sepal length, sepal width,
% petal length and petal width of the flowers.
%
% The aim is to be able to give the right species of an Iris flower
% by measuring the values of these four variables.
%
% We first load the data

  load iris

pause, clc %strike any key to continue ...
echo on
%
% Next we have a look at our data by the principal component analysis,
% PCA. Using the function PCA we compute the scores 't' ,loadings
% 'p' and the coefficient of determination 'r2' by the command
%
% [t,p,r2] = pca(center(x));
%
% and plot the scores, the 2-dimensional projections on the 1. and 2.
% principal components of the originally 4-dimensional observations,
% by
%
% plotpca(t,1,2,1:150)
%

pause, clc %strike any key to continue ...
echo off

  [t,p,r2] = pca(center(x));
  nobs = 1:150;
  plotpca(t,1,2,nobs);
  title('a PCA score plot of the observations')
  pause
 
echo on
% there seems to be three different subgroups in the data, two of them
% close to each other or overlapping. Does the 2-dimensional plot of
% 4-dimensional observations contain enough information for such a
% conclusion ? One way of judgning this is to check the vector 'r2',
% which tells which part of the total variation of the data the principal
% components (cumulatively) explain. In this case

 r2'

% i.e., the first two components give over 99 procent of the variation
% of the data.
%
% So a small number of principal components should reveal enough
% information for the classification.

  pause, clc %strike any key to continue ...
%
% We skip further details on how to select the points which belong to
% each of the groups and take it for granted that the first 50 of the
% data set belongs to the first, the 51 to 100 to the second and the rest to
% the third class.
%
% In any case, the 2-dimensional projections give overlapping point sets
% in the score plot for the 2. and 3. group. For the representation and
% classification of the observations we thus take more dimensions.
%
% Let us  compute 3-dimensional representations for the two subsets.
% That is, we compute the center points and 3 largest semiaxes for
% the 'cigars' (ellipsoids) which approximate the 'swarm' of observations.
%
% The function REPRES computes the center point and the required number
% of principal axes for a given data set. We use it for all the three
% classes
%

 pause, clc % strike any key to continue ...

 ndim = 3;        % the number of dimensions used in the classification
 i = 1:50; ii = 51:100; iii = 101:150;
 x1 = x(i,:); x2 = x(ii,:); x3 = x(iii,:);
 [xe1,p1,s1] = repres(x1,ndim);
 [xe2,p2,s2] = repres(x2,ndim);
 [xe3,p3,s3] = repres(x3,ndim);

% Next, compute the classification of all the observations.
%
% We first check which of the observations would belong to the first group.
% Since the first group seems to be well separated from the others, we
% use the 99% confidence region for it:

 [ind1,xp1,level1] = classi(x,xe1,p1,s1,99);  % wait ...

  echo off
  plotpca(xp1,1,2,ind1);
  title('the points classified to be (1) and not to be (0) in group 1')
  pause
               
  echo on
% The same for the second group. Now we use the 95% (default) confidence
% region, since the groups 2 ans 3 seem to be overlapping.

 [ind2,xp2,level2] = classi(x,xe2,p2,s2);

  echo off
  plotpca(xp2,1,2,ind2);
  title('the points classified to be (1) and not to be (0) in group 2')
  pause, clc



  echo on
% and the same for the third group:

 [ind3,xp3,level3] = classi(x,xe3,p3,s3);

  echo off
  plotpca(xp3,1,2,ind3);
  title('the points classified to be (1) and not to be (0) in group 3')
  pause, clc

  i1(1) = length(find(ind1(i)==1));
  i2(1) = length(find(ind1(ii)==0));
  i3(1) = length(find(ind1(iii)==0));


  i1(2) = length(find(ind2(i)==0));
  i2(2) = length(find(ind2(ii)==1));
  i3(2) = length(find(ind2(iii)==0));


  i1(3) = length(find(ind3(i)==0));
  i2(3) = length(find(ind3(ii)==0));
  i3(3) = length(find(ind3(iii)==1));


  i1 = i1/50*100;  i2 = i2/50*100; i3 = i3/50*100;

 clc
 echo on
% Two kind of classification errors may occur here:
%
% - A point belongs to a group, but is classified not to belong,
%   an error of the first kind
% - A point does not belong to a group, but is classified to belong,
%   an error of the second kind
%
% Errors of the second kind are inevitable, if the 'swarms' of observations
% overlap. You may decrease errors of second kind by shrinking the size
% of the classifying ellipsoid - and simultaneously increase the risk of
% error of the first kind.
%
% Below is a statistics for the classification just computed.
%
 pause, clc % strike any key to continue ...
echo off
disp(' Statistics of the misclassifications in each case:')
disp(' ')
disp(' procent of succes for calibration data, classification to group 1:')

        [i1(1)  i2(1)  i3(1)]
disp('group1    group2     group3  ')
disp(' ')
disp(' procent of succes for calibration data, classification to group 2:')
        [i1(2)  i2(2)  i3(2)]
disp('group1    group2     group3')


disp(' ')
disp(' procent of succes for calibration data, classification to group 3:')
        [i1(3)  i2(3)  i3(3)]
disp('group1    group2     group3')


 pause, clc % strike any key to continue ...
 echo on

% Next, compute the classifications for test sets. We randomly take
% 25 observations from each class for calibration, and classify the
% rest. Compute the PCA representations ...

 echo off
 x1 = x(1:50,:);    x2 = x(51:100,:);  x3 = x(101:150,:);
 x1 = randomiz(x1); x2 = randomiz(x2); x3 = randomiz(x3);
 i  = 1:25; ii = 26:50;  jj=[];
 xx1 = x1(i,:); xx2 = x2(i,:); xx3 = x3(i,:);
 xtest = [x1(ii,:); x2(ii,:); x3(ii,:)];

 echo on
 [xe1,p1,s1] = repres(xx1,ndim);
 [xe2,p2,s2] = repres(xx2,ndim);
 [xe3,p3,s3] = repres(xx3,ndim);

 pause, clc % strike any key to continue ...
%
% We first check which of the new observations would belong to the
% first group. Since the first group is well separated from the others,
% we can use a level larger than that computed by CLASSI for the 99%
% confidence region:


 [ind1,xp1,level1] = classi(xtest,xe1,p1,s1,50);  % wait ...

% Classification for the classes 2 and 3 is based on the default
% 95 % confidence region:

 [ind2,xp2,level2] = classi(xtest,xe2,p2,s2);
 [ind3,xp3,level3] = classi(xtest,xe3,p3,s3);

% The next figure shows a 2-dimensional plot of all the observations
% projected on the principal axes of the calibration set of the 1.
% class.

 pause, clc % strike any key to continue ...

  echo off
  plotpca(xp1,1,2,ind1);
  title('the points classified to be (1) and not to be (0) in group 1')
  pause, clc

  echo on
% The same for the second group. Now we use a smaller, the 95% (default)
% confidence region, since the groups 2 ans 3 seem to be overlapping.



 [ind2,xp2,level2] = classi(xtest,xe2,p2,s2);

  pause, clc % strike any key to continue ...

  echo off
  plotpca(xp2,1,2,ind2);
  title('the points classified to be (1) and not to be (0) in group 2')
  pause, clc

  echo on
% and the same for the third group:

 [ind3,xp3,level3] = classi(xtest,xe3,p3,s3);

  pause, clc % strike any key to continue ...
  echo off
  plotpca(xp3,1,2,ind3);
  title('the points classified to be (1) and not to be (0) in group 3')
  pause, clc

  i = 1:25; ii=26:50; iii=51:75;

  i1(1) = length(find(ind1(i)==1));
  i2(1) = length(find(ind1(ii)==0));
  i3(1) = length(find(ind1(iii)==0));

  i1(2) = length(find(ind2(i)==0));
  i2(2) = length(find(ind2(ii)==1));
  i3(2) = length(find(ind2(iii)==0));

  i1(3) = length(find(ind3(i)==0));
  i2(3) = length(find(ind3(ii)==0));
  i3(3) = length(find(ind3(iii)==1));


  i1 = i1(:)/25*100;  i2 = i2(:)/25*100; i3 = i3(:)/25*100;

 clc
echo off
disp(' Statistics of the misclassifications in each case:')
disp(' ')
disp(' procent of succes for calibration data, classification to group 1:')

        [i1(1)  i2(1)  i3(1)]
disp('group1    group2     group3  ')
disp(' ')
disp(' procent of succes for calibration data, classification to group 2:')
        [i1(2)  i2(2)  i3(2)]
disp('group1    group2     group3')


disp(' ')
disp(' procent of succes for calibration data, classification to group 3:')
        [i1(3)  i2(3)  i3(3)]
disp('group1    group2     group3')

pause, clc
echo on

%
% We note that the above method of computing the principal components
% of the training sets is not a final answer to the classification
% problem. One may, for instance, use the PCA representation as a
% starting point for an iterative fine-tuning of the classification. For
% more details, see, e.g., [E. Oja: Subspace methods of Pattern Recognition,
% Research Studies Press, J. Wiley & Sons, 1983].
