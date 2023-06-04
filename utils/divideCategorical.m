function catGroup = divideCategorical(X)
% divideCategorical(X) divides a categorical feature X into two
% equally-sized groups
%
% INPUT:
%   X: categorical feature (1:K categories, specified as numbers)
%
% OUTPUT:
%   catGroup: groups with the indices of the features that belong to each group
%              catGroup.g1 and catGroup.g2
%
% EXAMPLE:
% X = [1 4 2 6 4 5 2 4 4 4 4 4 4 9 1]; % 15 values
% catGroup = divideCategorical(X)
% 
% X = [1 4 2 6 4 5 2 4 4 4 4 4 4 9 1 2]; % 16 values
% catGroup = divideCategorical(X)
% 
% 
% 
% 
% Copyright: Miriam Santos, 2017


[~, order] = sort(X);
nel = length(X); % number of elements
val = floor(nel/2);

catGroup.g1 = order(1:val);
catGroup.g2 = order(val+1:end);


end