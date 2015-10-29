
clc
echo on
% keywords: demo
% This demo illustrates how to use fractional factorial designs
% in looking for most important variables and/or in preliminary
% empirical optimization. The next step would be to use quadratic
% models, which is illustrated in DEMOQUAD.
%
% In cases where we have more than 4 variables, it is seldom
% reasonable to make a full factorial design. On the other
% hand, choosing the right fractional design is not quite
% easy. Hopefully this demo will help you a little.
% NOTE: for simplicity blocking effects have been neglected.
%
% We have 7 variables possibly affecting to the yield of
% a process (SIMU2). The user can use his/hers imagination
% giving physical interpretations to the variables that are used
% in coded units only! (Thus in a real life problem you would
% have to code and decode variables; see CODE)
%

pause % strike any key to continue
clc

% The traditional way to approach the problem is to change
% one variable at time i.e. to use a diagonal or screening
% design. This sounds intuitively good since then we are
% sure to estimate the main effects only. But is it?
% Let us see:

pause % strike any key to continue
clc

% a diagonal design with 5 replicates:

x1 = [eye(7);zeros(5,7)]; % we use step size 1 for each variable change

pause % strike any key to continue
clc

% and then the results

y1=fsimu(x1);

err1=std(y1(8:12)) % we estimate the experimental error from the 5 replicates
 
pause % strike any key to continue
clc

% Let us make linear model with main effects only

[b1,yest1,stp1,e1]=regres(x1,y1,[err1 4]); n1=length(y1);

% and let's see how the model fits the data; remember that if the model
% is valid s (s^2 = SSE/(n-p)) estimates the experimental error.

s1 = sqrt(sum(e1.^2)/(n1-8));
disp([r2(y1,yest1) s1])

pause % strike any key to continue
clc

% Now everything looks perfectly all right: the fit is qood and
% standard error of residuals compared to experimental error, i.e.
disp([err1 s1])
% does not show lack of fit. But remember, we changed
% only one variable at time! Can we be sure that all the
% effects are additive (i.e. changing e.g. variables 1 and 2
% together would yield an effect that is sum of the effects
% 1 and 2)?

pause % strike any key to continue
clc

% Then there is another point. How accurately did we estimate
% the main effects? Let's see

disp([[0;(1:7)'] b1 stp1])

pause % strike any key to continue
clc

% The standard error of the effects is of the same order as the
% experimental error! This is not very good: one observation has
% standard deviation equal to the experimental error; thus
% effectively we use only one observation per estimate of each
% effect. Yet there are more powerfull designs with 8 experiments
% as seen later in this demo.
%
% Anyway we notice that all main effects except 4 and 5 are significiant.
% But so far we know nothing about interactions lurking somewhere there!
%
% Now, let's try to predict how we could improve the yield i.e. let's
% make a couple of experiments along the gradient.

pause % strike any key to continue
clc

% normed gradient:

g = b1(2:8)/norm(b1(2:8)); disp(g')

% The point along the gradient with x1 = 1 and the result of the experiment:

p1 = g/g(1); yp1 = fsimu(p1');
disp(p1'),disp(yp1)


% We didn't make any improvement, strange!

pause % strike any key to continue
clc

% The point along the gradient with x1 = 2 and the result of the experiment:

p2 = g/g(1)*2; yp2 = fsimu(p2');
disp(p2'),disp(yp2)


% And this was a disaster, why!?

pause % strike any key to continue
clc

% You guessed right, there must be negative interactions!
% But before going in more detail into the world of interactions
% let's see if we had made any better with Placket-Burman (or
% Taguchi) type fractional factorial design. First we need
% a generator so that we know what interactions are confounded
% with the main effects and with each other

gen = [1     2     0     4     0     0     0     1
       1     0     3     0     5     0     0     1
       0     2     3     0     0     6     0     1
       1     2     3     0     0     0     7     1];

% Thus the generators are 124=I, 135=I, 236=I and 1237=I so that
% 1=24=35=67, 2=14=36=57, 3=15=26=47, 4=12=37=56, 5=13=27=46,
% 6=23=17=45, 7=16=25=34
%
% Thus the following design, equivalent to Placket-Burman or
% Taguchi L8 designs,  has possibilities for a lot of confusion!

x2 = twon(7,3,gen);
y2=fsimu(x2);

pause % strike any key to continue
clc

% We did three more replicates to get a more reliable estimate of
% the experimental error (which now has 7 degrees of freedom)

err=std([y1(8:12);y2(9:11)])
 
% Now we try to make another linear model with the new experiments only

[b2,yest2,stp2,e2]=regres(x2,y2,[err 7]); n2=length(y2);

% and let's see how the model fits the data

s2 = sqrt(sum(e2.^2)/(n2-8));
disp([r2(y2,yest2) s2])

pause % strike any key to continue
clc
 
% That looked all right. Now let's see if this design gives the same model

disp([[0;(1:7)'] b2 stp2])

pause % strike any key to continue
clc
 
% They seem different but let's look at them together

disp([[0;(1:7)'] b1 stp1(:,3) b2 stp2(:,3)])

pause % strike any key to continue
clc
 
% Now, effects 1,2,3 and 7 look rather similar but 4,5 and 6
% are quite different. We could predict along the gradient
% with the new model but the results would be almost as bad
% as previously so that we will not repeat it here. (The user
% is suggested to check it!) The difference in the results
% reveals us those main effects that are possibly confounded
% with interactions. Thus the diagonal design is, after all,
% quite useful combined with a fractional factorial design giving
% us the conclusion: 4,5 and 6 are confounded with interactions.
% Since the confounding pattern for our design is
% 4 = 12 = 37 = 56, 5 = 13 = 27 = 46, 6 = 23 = 17 = 45
% we can resolve the ambiquities with additional 9 experiments
% minimum. Unfortunately the resulting design would not be orthogonal
% and it would be difficult to interprete the results.

% It is simpler to make a 2^(7-2) design where the 6 confounding
% interactions are chosen suitably:

pause % strike any key to continue
clc
 
% If we take

gen2=[1 2 3 4 0 6 0 1
      1 2 3 0 5 0 7 1];

% we have e.g. 45 = 67, but only 45 appears in the list above.
% Thus we choose

x3 = twon(7,0,gen2);

% In practice we would not repeat those experiments that are common
% in x2 and x3!

y3 = fsimu(x3);

pause % strike any key to continue
clc

% Let's combine all previous experiments

x = [x1;x2;x3];
y = [y1;y2;y3];

pause % strike any key to continue
clc
 
% and let's form the possible interactions and make a new model
% with these.

inter = [1 3 5 1 2 4 2 1 4
         2 7 6 3 7 6 3 7 5];

[variables,inter2] = varnames(inter,7);

pause % strike any key to continue
clc
 
[b,yest,stp,e] = regres(products(x,inter),y,[err,5]);
disp([variables b stp])

pause % strike any key to continue
clc
 
% As we can see the relevant interactions are 12,13 and 23 and
% the relevant main effects 1, 2, 3, 6, and 7. Let us recalculate
% the model with the relevant effects only

inter = [1 1 2 
         2 3 3];

xx                 = products(x,inter);
[variables,inter2] = varnames(inter,7);

pause % strike any key to continue
clc
 
% Now we shall remove the nonsignificiant effects 4 and 5

xx        = remove(xx,[],[4 5]);
variables = remove(variables,[5 6]);
inter2    = remove(inter2,[],[4 5]);

[b,yest,stp,e] = regres(xx,y,[err,5]);
disp([variables b stp])

pause % strike any key to continue
clc
 
% Now we have a model where the effects are not confounded anymore and
% we can make predictions along the gradient path. Since the gradient
% is now curved (due to the interactions) we use GRADPATH. GRADPATH
% assumes a full quadratic model so we have to set zeros for the
% coefficients of the missing terms which is most easily done with
% QUADCOMP.

bf = quadcomp(b,inter2,7);

[path, ypath] = gradpath(bf,[],.5,10); %PLEASE WAIT!

x5=path(2:2:10,:); ypred=ypath(2:2:10);

pause % strike any key to continue
clc
 
% Finally we shall make 5 new experiments along the path and compare
% the results with the predictions

y5=fsimu(x5);

disp([y5 ypred])

% Notice that we have substantially improved the process!
% It is quite natural for empirical models to give 'impossible'
% results, like the last prediction, if we extrapolate too much.
% See the demo DEMOQUAD for more techniques of locating optima.
echo off
