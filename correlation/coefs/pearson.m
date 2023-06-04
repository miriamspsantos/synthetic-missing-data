function rpearson = pearson(datai1, datai2)
% pearson(datai1, datai2)  Computes Pearson coefficient between two
% intervalar variables
%
% Correlation: CONTINUOUS+CONTINUOUS
%
%   INPUT:
%       datai1 = vector of continuous data x1
%       datai2 = vector of continuous data x2
%
%
%   OUTPUT:
%      rpearson = value of correlation (ranges from -1 to +1):
%         +1: perfect positive correlation
%          0: no association at all
%         -1: perfect negative correlation
%
% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of rpearson: |rpearson|
%
%
% EXAMPLE:
% a = rand(1,10)';
% b = rand(1,10)';
%
% rpearson = pearson(a, b);
%
%
% Copyright Miriam Santos, 2017


% Guarantee that datai1 and datai2 are vectors
assert(size(datai1,2)== 1 && size(datai2,2)== 1);


% Use corr to compute pearson
rpearson = corr(datai1, datai2, 'Type', 'Pearson');

% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of rpearson: |rpearson|
rpearson = abs(rpearson);
