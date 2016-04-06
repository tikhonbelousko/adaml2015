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
data = reshape(temp(:,:,1,:), lonsz, latsz, size(time,1), 1);

%%%
% Save
%%%
save('air.mon.level1.mat', 'data', 'lonsz', 'latsz', 'time'); 