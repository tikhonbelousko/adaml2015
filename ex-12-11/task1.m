clc;
clear all;

addpath(genpathKPM('./bnt'));

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

% Inference
engine = global_joint_inf_engine(bnet);
evidence = cell(1, N);

[engine, loglik] = enter_evidence(engine, evidence);
m = marginal_nodes(engine, [D I G S L]);

m.T(1,1,1,1,1)



