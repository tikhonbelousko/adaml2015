clc;
clear all;
addpath(genpath('./drtoolbox'));

load('yeast.mat');

% % PCA
% [mapped_data, mapping] = compute_mapping(data, 'PCA');
% figure, scatter(mapped_data(:,1), mapped_data(:,2)); 
% title('Result of PCA');
% 
% % LLE
% [mapped_data, mapping] = compute_mapping(data, 'LLE');
% figure, scatter(mapped_data(:,1), mapped_data(:,2)); 
% title('Result of LLE');
% 
% % FA
% [mapped_data, mapping] = compute_mapping(data, 'FA');
% figure, scatter(mapped_data(:,1), mapped_data(:,2)); 
% title('Result of FA');
% 
% % PCA RAND
% rdata = rand([10 100]);
% [mapped_data, mapping] = compute_mapping(rdata, 'PCA');
% figure, scatter(mapped_data(:,1), mapped_data(:,2)); 
% title('Result of PCA with random data');

disp('**********************');
disp('*      YEST.MAT      *');
disp('**********************');
fprintf('EigVal:\t%d \n', intrinsic_dim(data, 'EigValue'));
fprintf('MLE:\t%d \n',    intrinsic_dim(data, 'MLE'));
fprintf('CorrDim:\t%d \n',intrinsic_dim(data, 'CorrDim'));
fprintf('PackNum:\t%d \n',intrinsic_dim(data, 'PackingNumbers'));
fprintf('GMST:\t%d \n',   intrinsic_dim(data, 'GMST'));

disp('**********************');
disp('* RANDOM DATA 100x10 *');
disp('**********************');

rdata = rand([1000, 3]);
fprintf('EigVal:\t%d \n', intrinsic_dim(rdata, 'EigValue'));
fprintf('MLE:\t%d \n',    intrinsic_dim(rdata, 'MLE'));
fprintf('CorrDim:\t%d \n',intrinsic_dim(rdata, 'CorrDim'));
fprintf('PackNum:\t%d \n',intrinsic_dim(rdata, 'PackingNumbers'));
fprintf('GMST:\t%d \n',   intrinsic_dim(rdata, 'GMST'));

disp('**********************');
disp('*     SWISS ROLL     *');
disp('**********************');

sdata = generate_data('swiss', 1000);
fprintf('EigVal:\t%d \n', intrinsic_dim(sdata, 'EigValue'));
fprintf('MLE:\t%d \n',    intrinsic_dim(sdata, 'MLE'));
fprintf('CorrDim:\t%d \n',intrinsic_dim(sdata, 'CorrDim'));
fprintf('PackNum:\t%d \n',intrinsic_dim(sdata, 'PackingNumbers'));
fprintf('GMST:\t%d \n',   intrinsic_dim(sdata, 'GMST'));


disp('**********************');
disp('*      HELIX         *');
disp('**********************');

hdata = generate_data('helix', 1000);
fprintf('EigVal:\t%d \n', intrinsic_dim(hdata, 'EigValue'));
fprintf('MLE:\t%d \n',    intrinsic_dim(hdata, 'MLE'));
fprintf('CorrDim:\t%d \n',intrinsic_dim(hdata, 'CorrDim'));
fprintf('PackNum:\t%d \n',intrinsic_dim(hdata, 'PackingNumbers'));
fprintf('GMST:\t%d \n',   intrinsic_dim(hdata, 'GMST'));


subplot(1,3,1);
scatter3(hdata(:, 1),hdata(:, 2), hdata(:,3), '.r');
subplot(1,3,2);
scatter3(sdata(:, 1),sdata(:, 2), sdata(:,3), '.g');
subplot(1,3,3);
scatter3(rdata(:, 1),rdata(:, 2), rdata(:,3), '.b');
