function rpb  = pbiserial(datan,datai)
% pbiserial Point-Biserial correlation
%
%
% Correlation: CONTINOUS+BINARY
%
%             rbp = pbiserial(datan, datai) returns the point
%             biserial correlation coefficient between a nominal
%             feature (datan) and a ratio-scaled/intervalar or
%             continuous feature. datan and datai are vectors
%             containing the observations.
%
%   INPUT:
%       datan = vector of binary data
%       datai = vector of continuous data
%
%   OUTPUT:
%       rpb = value of correlation (ranges from -1 to +1):
%         +1: perfect positive correlation
%          0: no association at all
%         -1: perfect negative correlation
%
%         NOTE: Since we are only interested in determining the strength of
%         the correlation, we will compute the module of rpb: |rpb|
%
%
% Copyright Miriam Santos, 2017

% FORMULA for rpb:
%
%                     M1 - M0
%           rpb  = ------------- x sqrt(pq)
%                       std
% where:
%       M1 = mean of datai one category (1)
%       M0 = mean of datai the other category
%       std = standard deviation of all datai
%       p = proportion of one category (1)  = N1/N
%       q = proportion of the other category (0) = N0/N
%
%   EXAMPLE:
%   A = [1 1 0 0 1];
%   A2 = [0 0 1 1 0];
%   B = [0 0 0 1 1];
%   B2 =[1 1 1 0 0];
%   datai = [2 4 2 3 5];
%   rpb = pbiserial(A,datai)
%   rpb = pbiserial(A2,datai)
%   rpb = pbiserial(B,datai)
%   rpb = pbiserial(B2,datai)


uniqueVals = unique(datan);
N = length(datan);


% Only two possible categories exist:
idx_N1 = find(datan == uniqueVals(1));
idx_N0 = find(datan == uniqueVals(2));



N1 = length(idx_N1);
N0 = length(idx_N0);

p = N1/N;
q = N0/N;

M1 = mean(datai(idx_N1));
M0 = mean(datai(idx_N0));


% std is normalized by N
sd = std(datai,1);

rpb = ((M1-M0)/sd)*sqrt(p*q);


% NOTE: Since we are only interested in determining the strength of
% the correlation, we will compute the module of rpb: |rpb|
% Get the absolule (module) of rpb
rpb = abs(rpb);


end
