clc
clear
echo on
clc
%
%
% keywords: demo
% This is a demo on using the PLS and PCR algorithm for calibration of
% NIR spectral data. The demonstration data is real, measured from
% three chemical batch reactions, each containing  the same reactants
% with different initial concentrations. Samples of the reactants are
% taken and analysed at nine time points during the reactions. At the
% same instants, the NIR spectra of the reacting liquids are measured.
%
% The practical aim is to calibrate the relationship between
% the spectra and concentrations. Such a calibration enables us to
% calculate the concentrations directly from the measured spectra,
% thus saving further chemical analyses.
%
pause, clc % press any key to continue ...
%
%
% The calibration models are here selected by crossvalidation.
% The data is divided in 6 parts . The 5/6 part
% of the data is used to build the model, the rest of the data
% is then predicted by the model. The procedure is randomly
% repeated so that all the observations will be predicted.
% This is the idea of crossvalidation: we study the prediction
% ability of the model by simulated 'new' observations.
%
% The aim here is to select those PLS and PCR models that
% perform the prediction most reliably. As PLS and PCR are
% principal component regression methods, this amounts to
% selecting the best number of principal component dimensions.
%
pause, clc % press any key to continue ...
%
%
%
% We demonstrate the calibration and prediction of new concentrations
% by modeling the spectra/concentrations relations using two of the
% batch reactions only (second and third). The concentrations of the
% first batch are then calculated by the PLS and PCR model and compared
% with the laboratory analyses.
%
%
pause, clc % press any key to continue ...
%
% First load the data:

% spectra x1 x2 x3 and the respective concentration
% matrices y1 y2 y3

 load nirdemo


% There are 251 different wavelengths in each spectra -
% rather too much, both for the speed and memory of a (small) PC,
% and for the purpose of calibration. We do a truncation by averaging
% the spectra over 5 adjacent wavelengths.
%
% First form the calibration matrices

%        xx = [x2;x3];    and    yy = [y2;y3];


% then use the utility   x = contract(xx',5);x=x';  (wait a little):

echo off

 xx = [x2;x3];  yy = [y2;y3];
 clear x2 x3
 x  = contract(xx',5);x=x';

echo on

pause, clc % press any key to continue ...
%
%We use the function CROSPVAL to test the dimensions
%1,...,10 by the crossvalidition criterion 'Q2'.
%The input list for the call of CROSPVAL reads
%as CROSPVAL(x,y,dims,part,method,iscale).
%Now the data is divided in six parts (part = 6), and
%we compute both the PSL (method = 1) and PCR (method = 2)
%models. The optional parameter 'iscale' may be omitted: the
%scaling of data is performed as default. So the calls may
%be written as
%
% [q2pls,q2ypls,ypredpls] = crospval(x,yy,1:10,6,1);
% [q2pcr,q2ypcr,ypredpcr] = crospval(x,yy,1:10,6,2);
%
%
%Since the computation usually takes some time, the function
%echoes the number of each 'part' it is processing.

pause, clc % press any key to continue ...
%
%
% compute the pls crossvalidation,  wait ...

echo off

[q2pls,q2ypls,ypredpls] = crospval(x,yy,1:10,6,1);

echo on
%
% compute the pcr crossvalidation,  wait ...
%
echo off
[q2pcr,q2ypcr,ypredpcr] = crospval(x,yy,1:10,6,2);
clc
echo on

%
%
% Then we plot R2 values of the both methods for each dimension.
%
%
pause, clc % press any key to continue ....



%          % See the plots in Figure 1
echo off
clf;
subplot(211);plot(1:1:10,q2pls);
title( 'Q2 values of crosplsq '),xlabel('dimensions')

subplot(212);plot(1:1:10,q2pcr);
title( 'Q2 values of crospcrq '),xlabel('dimensions')
subplot
pause
clc
echo on

%
%
% We can see from the plots that dimension 3 should be enough for PLS
% and PCR. Let us first plot the PLS/PCR-prediction with dimension 3 for
% the concentrations of the calibration batches to see how good
% the 'internal' prediction is.
%
pause % press any key to continue ....


echo off
time = 1:9;
j = 9:12;

subplot(121)
plot(time,yy(time,:),'-',time,ypredpls(time,j),'--'),
title( 'data (-), prediction (--), PLS ')
xlabel(' time ')
ylabel(' concentration' )

subplot(122)
plot(time,yy(time,:),'-',time,ypredpcr(time,j),'--'),
title( 'data (-), prediction (--), PCR ')
xlabel(' time ')
ylabel(' concentration ')
subplot
pause
clc

echo on
%
%
% Both of the fits seems to be fine. Finally we make the true PLS-
% prediction and the PCR-prediction with dimension 3 for the
% concentrations of the first batch. (We use the functions 'plspred'
% and 'pcrpred' with dimension 3.)
%
%
%


 xx1 = contract(x1',5);xx1=xx1';

 [yfit,b] = plsreg(x,yy,3);
 yhatpls1 = [oneg(xx1(:,1)) xx1]*b;

 [yfit,b] = pcreg(x,yy,3);
 yhatpcr1 =[oneg(xx1(:,1)) xx1]*b;

 pause % press any key to continue ...
 echo off

 subplot(121);
 plot(time,y1(time,:),'-',time,yhatpls1(time,:),'--'),
 title( 'data (-), prediction (--), PLS ')
 xlabel(' time ')
 ylabel(' concentration ' )

 subplot(122);
 plot(time,y1(time,:),'-',time,yhatpcr1(time,:),'--'),
 title( 'data (-), prediction (--), PCR ')
 xlabel(' time ')
 ylabel(' concentration ' )

subplot
pause
clc
echo on
%
%
% In this demo there seems to be no essential difference between PLS and PCR.
% This is rather accidental, due to the 'nice' data. In general, PLS and
% PCR may behave quite differently.

