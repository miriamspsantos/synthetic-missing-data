function r_eta = eta(dataI, dataN)
% eta(dataI, dataN) Correlation Ratio (Eta)
%
% Correlation: CONTINUOUS+NOMINAL and ORDINAL/NOMINAL
% In the case of ORDINAL/NOMINAL, the eta is done using the ranks of
% ordinal data (as continous).
%
% r_eta = eta(dataI, dataN) returns the correlation ratio (Eta) between a
% continuous and a nominal variable
%
%
%   INPUT:
%       dataI = vector of continous data
%       dataN = vector of nominal data
%
%   OUTPUT:
%       r_eta = value of correlation (ranges from 0 to 1):
%          1: perfect correlation
%          0: no association at all
%
%
%   EXAMPLE:
%   dataN = [1 1 1 1 1 2 2 2 2 3 3 3 3 3 3];
%   dataI = [45 70 29 15 21 40 20 30 42 65 95 80 70 85 73];
%
%   r_eta = eta(dataI, dataN)
%
% Copyright Miriam Santos, 2017


% Existing categories in the nominal variable
uniqueVals = unique(dataN);

% Number of observations
N = length(dataN);
totalMean = mean(dataI);

means = [];
nObs = []; % number of observations in each category

% Get the values and means of each category
for i = 1:length(uniqueVals)
    idx = find(dataN == uniqueVals(i));
    values.(strcat('cat', num2str(i))) = dataI(idx);
    means(i) = mean(dataI(idx));
    nObs(i) = length(idx);
end

% Numerator and denominator
numerator = sum(nObs.*(means-totalMean).^2);
denominator = sum((dataI-totalMean).^2);

% Compute the correlation ratio
r_eta = sqrt(numerator/denominator);
