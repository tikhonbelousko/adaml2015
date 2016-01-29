clc;
clearvars;
close all;


ncdisp('air.mon.mean.nc')

% IDs
ncid = netcdf.open('air.mon.mean.nc');
levid = netcdf.inqVarID(ncid,'level');
lonid = netcdf.inqVarID(ncid,'lon');
latid = netcdf.inqVarID(ncid,'lat');
timeid = netcdf.inqVarID(ncid,'time');
airid = netcdf.inqVarID(ncid,'air');
tboundsid = netcdf.inqVarID(ncid,'time_bnds');

% Data
lon = netcdf.getVar(ncid,lonid);
lat = netcdf.getVar(ncid,latid);
time = netcdf.getVar(ncid,timeid);
temp = netcdf.getVar(ncid,airid);
level = netcdf.getVar(ncid,levid);
tbounds = netcdf.getVar(ncid,tboundsid);