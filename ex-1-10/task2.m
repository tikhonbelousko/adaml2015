clc
clear all
close all

% Constants 
CHUNK_SIZE = 10;
SHIFT = -2;

% Load data
load signal_b.mat

% Get chunks
parts = reshape(y, CHUNK_SIZE, []);

% Process
[rows, columns] = size(parts);
similarity = [];
for i = 1:columns
    part1 = parts(:,i);
    part2 = parts(:, mod(i + SHIFT, columns) + 1);
    similarity = [similarity, abs(var(part1) - var(part2))];
end

[m, di] = max(similarity);
 
hold on
plot(y, '-o')
indeces = (1:CHUNK_SIZE) + (di - 1)*rows
plot(indeces', parts(:, di), '-o')
hold off

