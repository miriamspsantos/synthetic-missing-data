function rcramer = cramerV(x1, x2)
% cramerV(x1, x2)  Computes Spearman coefficient between two
% ordinal variables or one ordinal and one continuous variables
%   
% Correlation: NOMINAL+BINARY or NOMINAL+NOMINAL 
%  
%   INPUT:
%       x1 = vector of nominal or binary data
%       x2 = vector of nominal data
%       (it's indiferent what is x1 and x2)
% 
%   OUTPUT:
%      rcramer = value of correlation (ranges from 0 to 1):
%          1: perfect correlation
%          0: no correlation at all
%    
%   EXAMPLE:
% 
%   a = [1 2 3 2 3 2 3 1 2 3 2 1];
%   b = [1 3 1 4 1 1 3 1 3 1 1 1];
%   rcramer = cramerV(a, b)
% 
% 
% Copyright Miriam Santos, 2017


% FORMULA for rcramer:
%
%           rcramer = sqrt( QUI^2 / N*(k-1) )
%                       
% where:
%       QUI^2 = Qui-squared statistic
%       N = Number of observations
%       k = lesser number of categories of either varible


% Get the number of categories in each variable
numCatX1 = length(unique(x1));
numCatX2 = length(unique(x2));

% Choose k as the minimum number of categories
% if numCatX1 <= numCatX2
if le(numCatX1, numCatX2)
    k = numCatX1;
else
    k = numCatX2;
end

% Number of observations
N = length(x1);

% Determine the QUI^2 (chi2)
[tbl,chi2,p] = crosstab(x1,x2);


deno = N*(k-1);
rcramer = sqrt(chi2/deno);








