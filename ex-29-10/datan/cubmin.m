function lamin = cubmin(fnew,fold,gnew,gold,step,vali1,vali2)

eeta = 3*(fnew-fold)-2*step*gold-step*gnew;
ksii = step*gold+step*gnew-2*(fnew-fold);
root = sqrt(4*eeta^2-12*step*gold*ksii);
a = (-2*eeta+root)/(6*ksii);
b = (-2*eeta-root)/(6*ksii);
y1 = fold+step*gold*vali1+eeta*vali1^2+ksii*vali1^3;
y2 = fold+step*gold*vali2+eeta*vali2^2+ksii*vali2^3;
miny = min(y1,y2);
if miny == y1
     lamin = vali1;
else
     lamin = vali2;
end

if a>vali1 & a<vali2
     y3 = fold+step*gold*a+eeta*a^2+ksii*a^3;
     if y3 < miny
          lamin = a;
          miny = y3;
     end
end

if b>vali1 & b<vali2
     y3 = fold+step*gold*b+eeta*b^2+ksii*b^3;
     if y3 < miny
          lamin = b;
          miny = y3;
     end
end


