function idx = samplefromp(n, p, k)
% samplefromp(n,p,k) takes k numbers from n according to probability vector
% p. 
% 
% INPUT:
%   n: number of patterns in the dataset
%   p: probability of each pattern to be chosen 
%   k: number of patterns we need to choose
% 
% OUTPUT:
%   idx: indices of the patterns in the dataset chosen according to p

idx = datasample(1:n, k, 'Replace', false, 'Weights', p);

end