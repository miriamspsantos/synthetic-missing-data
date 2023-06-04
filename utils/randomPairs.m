function [Pairs, array_pairs, randomPair] = randomPairs(p)
% randomPairs(p) returns random pairs (or trios) of p features
%
% INPUT:
%   p: number of features in the dataset
%
% OUTPUT:
%   Pairs: random pairs of features
%   
%
% EXAMPLE:
% p = 6;
% [Pairs, array_pairs, randomPair] = randomPairs(p)
% 
% p = 7;
% [Pairs, array_pairs, randomPair] = randomPairs(p)
% 
% 
% 
% Copyright: Miriam Santos, 2017

array_pairs = randperm(p,p);

val = floor(p/2);

for i = 1:val
    Pairs.(strcat('p',num2str(i))) = [array_pairs(i) array_pairs(val+i)];
end

% If p is odd
if (mod(p,2) == 1)
    % Choose a random pair
    randomPair = randi(val);  
    % Add the remaining feature to that pair
    Pairs.(strcat('p',num2str(randomPair))) = [Pairs.(strcat('p',num2str(randomPair))) array_pairs(end)];
end


    