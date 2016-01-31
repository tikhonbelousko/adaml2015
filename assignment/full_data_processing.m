%%%
% Plots that are showing
% trends in temperature changes utilizing information
% of the whole data set. Data is processed 
% using random projection.
%%%

clc;
clearvars;
close all;

ncdisp('air.mon.mean.nc')

%%%
% IDs
%%%
ncid = netcdf.open('air.mon.mean.nc');
levid = netcdf.inqVarID(ncid,'level');
lonid = netcdf.inqVarID(ncid,'lon');
latid = netcdf.inqVarID(ncid,'lat');
timeid = netcdf.inqVarID(ncid,'time');
airid = netcdf.inqVarID(ncid,'air');
tboundsid = netcdf.inqVarID(ncid,'time_bnds');

%%%
% Data
%%%
tic();
lon = netcdf.getVar(ncid,lonid);
lat = netcdf.getVar(ncid,latid);
time = netcdf.getVar(ncid,timeid);
temp = netcdf.getVar(ncid,airid);
level = netcdf.getVar(ncid,levid);
tbounds = netcdf.getVar(ncid,tboundsid);
toc();

%%%
% Vars
%%%
lonsz = size(lon,1);
latsz = size(lat,1);
levsz = size(level,1);

n = size(time, 1); % # of timestemps
d = lonsz * latsz * levsz; % # of grid points
k = floor(sqrt(d) * 0.1); 

%%%
% Random projection
%%%


% Flattened matrix
tic();
X = reshape(temp, d, n)';
Xm = repmat(mean(X),size(X,1),1);
Xc = X - Xm; 
toc();

% Random matrix
tic();
R = rand(d, k);
R(R<1/6) = -sqrt(3);
R(R>5/6) = sqrt(3);
R((R>-sqrt(3)) & (R<sqrt(3))) = 0;
toc();

% Projection
tic();
P = Xc * R;
Pm = repmat(mean(P),size(P,1),1);
toc();

% PCA
[c,s,l,~,e] = pca(P);
toc();

% Draw first components
tic();
snorm = s./repmat(std(s),size(s,1),1);
toc();

N = 3;
del = [140 150; 138 148; 280 290];
for i=1:N
    tic();
    
    sfft = fft(snorm(:,i));
    sfft(del(i,1):del(i,2)) = 0;
    sfft(n-del(i,2):n-del(i,1)) = 0;

    subplot(3,N,1+N*(i-1));
    plot(snorm(:,i));
    title(sprintf('Component %d',i));

    subplot(3,N,2+N*(i-1));
    plot(ifft(sfft, 'symmetric'));
    title(sprintf('Component %d (Peak filter)',i));

    subplot(3,N,3+N*(i-1));
    plot(imgaussfilt(ifft(sfft, 'symmetric'), 50));
    title(sprintf('Component %d (Peak + Gaussian filter)',i));
    toc();
end
