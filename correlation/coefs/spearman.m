function rspearman = spearman(x1, x2)
% pearson(x1, x2)  Computes Spearman coefficient between two
% ordinal variables or one ordinal and one continuous variables
%
% Correlation: ORDINAL+ORDINAL or CONTINUOUS+ORDINAL
%
%   INPUT:
%       x1 = vector of continuous or ordinal data
%       x2 = vector of ordinal data
%       (it's indiferent what is x1 and x2)
%
%   OUTPUT:
%      rspearman = value of correlation (ranges from -1 to +1):
%         +1: perfect positive correlation
%          0: no association at all
%         -1: perfect negative correlation
%
% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of rspearman: |rspearman|
%
% EXAMPLE:
% a = rand(1,10)';
% b = randi(10,1,10)';
% c = randi(10,1,10)';
%
% rspearman = spearman(a, b);
% rspearman = spearman(b, c);
%
%
% Copyright Miriam Santos, 2017


% Guarantee that datai1 and datai2 are vectors
assert(size(x1,2)== 1 && size(x2,2)== 1);


% Use corr to compute pearson
rspearman = corr(x1, x2, 'Type', 'Spearman');

% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of rspearman: |rspearman|
rspearman = abs(rspearman);
