clc;
clear all;

cd bnt;
addpath(genpathKPM(pwd));
cd ..;

% Matrix
N = 5;
dag = zeros(N,N);

% Events
D = 1; I = 2; G = 3; S = 4; L = 5;

% Graph
dag(D, G) = 1;
dag(I, [G S]) = 1;
dag(G, L) = 1;

% Nodes
discrete_nodes = 1:N;
node_sizes = [2 2 3 2 2];

% Net
bnet = mk_bnet(dag, node_sizes);

% Parameters
bnet.CPD{D} = tabular_CPD(bnet, D, 'CPT', [0.6 0.4]);

bnet.CPD{I} = tabular_CPD(bnet, I, 'CPT', [0.7 0.3]);

bnet.CPD{G} = tabular_CPD(bnet, G, 'CPT', [0.3      0.05     0.9    0.5 ... 
                                           0.4      0.25     0.08   0.3 ...
                                           0.3      0.7      0.02   0.2]);
                                       
bnet.CPD{S} = tabular_CPD(bnet, S, 'CPT', [0.95     0.2 ...
                                           0.05      0.8]);
                                       
bnet.CPD{L} = tabular_CPD(bnet, L, 'CPT', [0.1      0.4     0.99 ...
                                           0.9      0.6     0.01]);
                                       
% Generate samples
nsamples = 100;
samples = cell(N, nsamples);
for i=1:nsamples
  samples(:,i) = sample_bnet(bnet);
end

% Make a tabula rasa
bnet2 = mk_bnet(dag, node_sizes);
seed = 0;
rand('state', seed);
bnet2.CPD{D} = tabular_CPD(bnet2, D);
bnet2.CPD{I} = tabular_CPD(bnet2, I);
bnet2.CPD{G} = tabular_CPD(bnet2, G);
bnet2.CPD{S} = tabular_CPD(bnet2, S);
bnet2.CPD{L} = tabular_CPD(bnet2, L);

% Learn
bnet3 = learn_params(bnet2, samples);

CPT3 = cell(1,N);
for i=1:N
  s=struct(bnet3.CPD{i});  % violate object privacy
  CPT3{i}=s.CPT;
end

dispcpt(CPT3{I})
disp(' ');
dispcpt(CPT3{G})
