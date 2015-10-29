  function jd=datjul(date)
% keywords: Julian day number
% call: jd=datjul(date)
% The function computes the julian day number.
%
% INPUT    date       a matrix with columns [day month year]
%
% OUTPUT   jd         the corresponding julian day numbers
%

% Copyright (c) 1994 by ProfMath Ltd
% $Revision: 1.2 $  $Date: 2002/12/09 15:16:12 $

igreg=15+31*(10+12*1582);
[n m]=size(date);
jy=zeros(n,1); jm=zeros(n,1); ja=zeros(n,1); jd=zeros(n,1);

day=date(:,1);
month=date(:,2);
year=date(:,3);

j1=find(year==0);
if size(j1)>0
      error('There is no year zero')
end
j1=find(year<0);
year(j1)=year(j1)+1;

j1=find(month>2);
j2=find(month<=2);

jy(j1)=year(j1); jm(j1)=month(j1)+1;
jy(j2)=year(j2)-1; jm(j2)=month(j2)+13;

jd=floor(365.25*jy)+floor(30.6001*jm)+day+1720995;

j1=find(day+31*(month+12*year)>=igreg);

ja(j1)=floor(0.01*jy(j1));
jd(j1)=jd(j1)+2-ja(j1)+floor(0.25*ja(j1));
