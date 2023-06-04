function r_rb  = rankbiserial(dataN,dataO)
% rankbiserial(dataN,dataO) Rank Biserial correlation
%
%
% Correlation: BINARY+ORDINAL
%
%             rrb = rankbiserial(dataN,dataO) returns the rank biserial
%             coefficient between a binary and an ordinal variable
%   INPUT:
%       dataN = vector of binary data
%       dataO = vector of ordinal data
%
%   OUTPUT:
%       r_rb = value of correlation (ranges from -1 to +1):
%         +1: perfect positive correlation
%          0: no association at all
%         -1: perfect negative correlation
%
% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of r_rb: |r_rb|
%
%   EXAMPLE:
%   dataN = [1 1 1 0 1];
%   dataO = [3 1 5 4 2];
%
%   r_rb = rankbiserial(dataN,dataO)
%
%
% Copyright Miriam Santos, 2017



% FORMULA for r_rb:
%
%                   2* (M0 - M1)
%           r_rb  = -------------
%                         N
%
% where:
%       M1 = mean of datai one category (1)
%       M0 = mean of datai the other category
%       N = number of observations



uniqueVals = unique(dataN);
N = length(dataN);

% Only two possible categories exist:
idx_N1 = find(dataN == uniqueVals(1));
idx_N0 = find(dataN == uniqueVals(2));


M1 = mean(dataO(idx_N1));
M0 = mean(dataO(idx_N0));

r_rb = 2*(M0-M1)/N;

% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of r_rb: |r_rb|
% Get the absolule (module) of r_rb

r_rb = abs(r_rb);


end
