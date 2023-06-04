addpath('arff-to-mat');
addpath(genpath('univa'));
addpath(genpath('unifo'));
addpath(genpath('atypical'));
addpath(genpath('data'));
addpath(genpath('correlation'));
addpath(genpath('utils'));
addpath(genpath('toolboxes'));



X = rand(100,4);
missing_percentage = 20;
synth_X = MCAR1unifo(X, missing_percentage);
sum(isnan(synth_X))
sum(sum(isnan(synth_X))) / (size(X, 1) * size(X, 2)) * 100
