  function [Q2,Q2y,ypred,press,pressy]=crosplsq(x,y,dims,part,iscale,iperm);
% keywords: variable selection, regression, crossvalidation, PLS
% call: [Q2,Q2y,ypred,press,pressy]=crosplsq(x,y,dims,part,iscale,iperm);
% The function calculates the value of the crossvalidation criterion
% 'Q2,press' for the dimensions 'dims' using the PLS-method. A scaling of 'x'
% is optional. The data is devided in 'part' parts. 'Press' is calculated by
% dropping out each 'part' of the data and using the rest of the data in
% calibration and the dropped part for prediction. The goodness of 
% prediction is measured with 'press'.
% INPUT  :      x,y       data matrixes   [m,ny] = size(y)
%               dims      criteria calculated for dimensions given in 'dims'
%		part	  data is devided in 'part' parts
%               iscale    perform the scaling of 'x' (0 = no   1 = yes)
%                         OPTIONAL, default iscale = 1.
%               iperm     the order of observations used in crossvalidation
%                         OPTIONAL, default: iperm randomized
% OUTPUT :      Q2        R2 values for each dimension (mean values for
%                         multiresponse 'y')
%               Q2y       Q2 for each response component & dimension
%               ypred     predicted 'y' for each dimension
%                         [mypred,nypred] = size(ypred)
%                         mypred=floor(m/part)*part,nypred=length(dims)*ny
%               press     predicted residual sum of squares for each
%                         dimension
%               pressy    press for each response component & dimension


if nargin == 4
    iscale = 1;
elseif nargin < 4
    disp('too few inputs')
    break
end
if length(iscale) == 0, iscale = 1; end

[m,nx] = size(x);           [m,ny] = size(y);

mp          = floor(m/part);
ndim        = length(dims);
press       = zeros(ndim,1);
pres2       = zeros(ny,ndim);
ypred       = zeros(m,ndim*ny);

if nargin< 6
   iperm = randperm(m); iperm = iperm(:);
else
   iperm = iperm(:);
end

[a,invperm] = sortrow(iperm,1,1);

%iperm = (1:m)'; invperm = iperm;

x = x(iperm,:); y = y(iperm,:);

imax = part;
if rem(m,part) > 0, imax = part+1; end

for i = 1:imax;

     disp('part'), disp(i)
     if i > part
         ind = max(ind)+1:m;
     else
         ind       = ((i-1)*mp+1:i*mp)'; 
     end
     xi        = remove(x,ind); yi   = remove(y,ind);
     if iscale == 1
         [xi,ximean,xistd] = scale(xi); yimean = mean(yi);
     else
         ximean = mean(xi); yimean = mean(yi);
     end 

     [t,p,q,w] = pls(xi,yi,max(dims));
 
     for j = 1:ndim;
        dim    = dims(j);
        indy   = ((j-1)*ny+1:j*ny)';
        if iscale == 1
            [mm,nn]         = size(x(ind,:));
            xipred          = zeros(mm,nn);
            k               = find(xistd > 0);
            I               = ones(length(ind),1);
            xipred(:,k)     = (x(ind,k)-I*ximean(k))./(I*xistd(k));
            ypred(ind,indy) = plspred(xipred,p,q,w,dim,yimean);
        else
            xipred = x(ind,:);
            ypred(ind,indy) = plspred(xipred,p,q,w,dim,yimean,ximean);
        end
     end
end

ypred    = ypred(invperm,:);
y        = y(invperm,:);
x        = x(invperm,:);
yy       = kron(ones(1,ndim),y);

Q2y      = r2(yy,ypred); QQ = Q2y; QQ=reshape(QQ,ny,ndim);
Q2y      = QQ';
Q2       = mean(QQ);

press    = sum((yy - ypred).^2)/m; pressy = zeros(ny,ndim);
pressy(:)= press;
press    = mean(pressy);

