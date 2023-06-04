function rphi = phi(datan1, datan2)
% corrphi(x1, x2) The Phi Coefficient: determines the correlation
% coefficient for 2 binary variables
%
% Correlation: BINARY+BINARY
%
%   INPUT:
%       datan1 = vector of binary data x1
%       datan2 = vector of binary data x2
%
%
%   OUTPUT:
%      rphi = value of correlation (ranges from 0 to 1):
%          1: perfect correlation
%          0: no association at all
%
%   EXAMPLE:
%
% a = [1 2 2 2 1 2 1 2 2 1 2 2 1 2 1 2];
% b = [2 1 1 1 1 1 1 2 1 1 2 1 2 1 2 1];
%
%
% a = [ones(1,50) ones(1,10) zeros(1,20) zeros(1,50)]';
% b = [ones(1,50) zeros(1,10) ones(1,20) zeros(1,50)]';
% rphi = phi(a, b)
%
%
% Copyright Miriam Santos, 2017

% FORMULA for rphi:
%
%
%       rphi  = sqrt(QUI^2/N)
%
% where:
%       QUI^2 = Qui-squared statistic
%       N = Number of observations


[tbl,chi2,p] = crosstab(datan1,datan2);

N = length(datan1);
rphi = sqrt(chi2/N);
