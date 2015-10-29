clc
echo on

% keywords: demo
% This is a basic demo on using the PLS algorithm for calibration of
% NIR spectral data. The demonstration data is real, measured from
% three chemical batch reactions, each containing  the same reactants
% with different initial concentrations. Samples of the reactants are
% taken and analysed at nine time points during the reactions. At the
% same instants, the NIR spectra of the reacting liquids are measured.

% The aim here is to be able to calibrate the relationship between
% the spectra and concentrations. Such a calibration enables us to
% calculate the concentrations directly from the measured spectra,
% thus saving further chemical analyses.


pause, clc % press any key to continue ...


% We demonstrate the calibration and prediction of new concentrations
% by modeling the spectra/concentrations relations using two of the
% batch reactions only. The concentrations of the third batch are then
% calculated by the PLS model and compared with the analysed values.

% As a preliminary way of selecting a correct dimension (number of
% principal components) for the PLS model we plot the spectra x of the
% first two batches and the corresponding spectra reconstructed from the
% first (PLS) principal components. For other ways of selecting
% the dimension and further analysis of this case see DEMONIR2.


pause, clc % press any key to continue ...


% First load the data:

% spectra x1 x2 x3 and the respective concentration
% matrices y1 y2 y3

 load nirdemo




% To have a look at our data, let us plot the spectra and
% concentrations of the first batch


pause, clc % press any key to continue ...


           % See the plots in Figure 1
echo off
 subplot(121); plot(1:251,x1,'-');
 title(' The NIR absorbance spectra'), xlabel('the wavelengths')

 time = 1:9;
 subplot(122); plot(time,y1,'-');
 title(' The concentrations'), xlabel(' time')
 pause
 subplot
 clc

echo on


% There are 251 different wavelengths in each spectra -
% rather too much, both for the speed and memory of a PC, and for
% the purpose of calibration. We do a truncation by averaging
% the spectra over 5 adjacent wavelengths
% First form the calibration matrices

%        xx = [x1;x2];    and    yy = [y1;y2];



% then use the utility   x = contract(xx',5);x=x';  (wait a little):

echo off

 xx = [x1;x2];  yy = [y1;y2];
 clear x1 x2
 x  = contract(xx',5);x=x';

echo on

pause, clc %press any key to continue ...


% Now the spectra have only 50 wavelength variables,
% we compute the PLS matrices for the dimensions 1,...,6 using
% the command [t,p,q,w] = pls(x,yy,6);

% wait again ...

echo off

 i=1:50;
 [t,p,q,w] = pls(x,yy,6);

echo on


% Let us now look how well the principal components t and p
% approximate the spectra in x.  We should approximately have
% x = t(:,dim)*p(:,dim)''. Try the first two dimensions, i.e.
% dim = 1:2

pause, clc % press any key to continue ...


           % See the plots in Figure 1

echo off

 dim = 1:2;
 plot(i,t(:,dim)*p(:,dim)','-',i,x,'--')
 title(' original spectra (-) and the spectra (--) constructed by 2 dimensions')
 pause

echo on

% well, the fit is not too fine, let us take dim = 1:5


pause  % press any key to continue ...



           % See the plots in Figure 1
echo off

 dim = 1:5;
 plot(i,t(:,dim)*p(:,dim)','-',i,x,'--')
 title(' original spectra (-) and the spectra (--) constructed by 5 dimensions')

pause

echo on

% Now the fit seems rather good, let us make the PLS-prediction
% with dimension 5 for the concentrations of the third batch:
% (remember to contract the spectra of x3, too!)

pause, clc % press any key to continue ...

% truncating ...


           % See the plots in Figure 1
echo off
 x3 = contract(x3',5);x3=x3';

 yhat3 = plspred(x3,p,q,w,5);
 plot(time,y3(time,:),'-',time,yhat3(time,:),'--'),
 title( 'concentration data (-)/prediction (--), PLS dimension 5 ') , pause

echo on
% The fit seems OK, let us still try the same using only dimension
% 2 for the model:

pause, clc % press any key to continue ...


           % See the plots in Figure 1
echo off

 yhat3 = plspred(x3,p,q,w,2);

 plot(time,y3(time,:),'-',time,yhat3(time,:),'--'),
 title( 'concentration data (-)/prediction (--), PLS dimension 2 ')

clc

