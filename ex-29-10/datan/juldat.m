  function date=juldat(julday)
% keywords: Julian day number
% call: date=juldat(julday)
% The function returns the date correponding to a given julian day number
%
% INPUT:    julday       the julian day numbers
%
% OUTPUT:   date         a matrix with columns [day month year]

igreg=2299161;

%julday=colvec(julday);
julday = julday(:);
[n m]=size(julday);
jalpha=zeros(n,1);
ja=zeros(n,1);

j1=find(julday>=igreg);
j2=find(julday<igreg);

jalpha(j1)=floor(((julday(j1)-1867216)-0.25)/36524.25);
ja(j1)=julday(j1)+1+jalpha(j1)-floor(0.25*jalpha(j1));
ja(j2)=julday(j2);

jb=ja+1524;
jc=floor(6680+((jb-2439870)-122.1)/365.25);
jd=365*jc+floor(0.25*jc);
je=floor((jb-jd)/30.6001);

day=jb-jd-floor(30.6001*je);

month=je-1;

j1=find(month>12); month(j1)=month(j1)-12;

year=jc-4715;

j1=find(month>2); year(j1)=year(j1)-1;

j1=find(year<0); year(j1)=year(j1)-1;

date=[day month year];
