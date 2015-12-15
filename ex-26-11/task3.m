clc;
clearvars;

% IDs
ncid = netcdf.open('air.2m.mon.mean.nc');
lonid = netcdf.inqVarID(ncid,'lon');
latid = netcdf.inqVarID(ncid,'lat');
timeid = netcdf.inqVarID(ncid,'time');
airid = netcdf.inqVarID(ncid,'air');

% Data
lon = netcdf.getVar(ncid,lonid);
lat = netcdf.getVar(ncid,latid);
time = netcdf.getVar(ncid,timeid);
data = netcdf.getVar(ncid,airid);

% Vars
lon_size = size(lon,1);
lat_size = size(lat,1);

n = size(time, 1); % # of timestemps
d = size(lon,1) * size(lat, 1); % # of grid points
k = floor(d * 0.05); 

% Random projection
X = zeros(n, d);

for i1=1:lon_size
    for i2=1:lat_size
        for j=1:k
            X(j, (i1-1) * lat_size + i2) = data(i1,i2,n);
        end
    end
end

R = randn(d, k);
P = X * R;

% SVD
[U,S,V] = svd(P);

plot(U(1:10, :));


