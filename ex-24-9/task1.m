clear
load data1.dat
load data2.dat

subplot(1,2,1);
scatter(data1(:,1), data1(:,2));

subplot(1,2,2);
scatter(data2(:,1), data1(:,2));