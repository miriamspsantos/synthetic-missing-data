function [Pairs, Vi, Vj, rij] = getCorrPairs(X, ftypes)
% getCorrPairs(X, ftypes) computes pairs of the most related features,
% according to what is specified in Twala09 (check REFERENCES)
%
%   INPUT:
%       X = matrix of data to be correlated
%      ftypes = type of feature, an array with codes as read from
%      arff2double:
%
%
%   OUTPUT:
%       Vi, Vj combination of features
%       Vi = [2 4] and Vj = [1 5] means that pairs (V2,V1) and (V4,V5) are
%       chosen.
%
%       CODES:
%            0 = numeric/continuous
%            1 = categorical (nominal)
%            2 = string
%            3 = date
%            4 = ordinal (if coded as numeric)
%            5 = binary
%            6 = ordinal (if coded as categorical)
%
%
% REFERENCES:
% @article{Twala09,
%   title={An empirical comparison of techniques for handling incomplete data using decision trees},
%   author={Twala, Bhekisipho},
%   journal={Applied Artificial Intelligence},
%   volume={23},
%   number={5},
%   pages={373--405},
%   year={2009},
%   publisher={Taylor \& Francis}
% }
%
%
% Copyright: Miriam Santos, 2017


N = size(X,2);

i_array = [];
j_array = [];

rij = [];
Vi = [];
Vj = [];
k = 1;

for i = 1:N-1
    for j = i+1:N
        i_array = [i_array i];
        j_array = [j_array j];
        r = association(X(:,i), X(:,j), ftypes(i), ftypes(j));
        rij = [rij r];
    end
end



% Auxiliary variables
aux_rij = rij;
aux_i = i_array;
aux_j = j_array;

while sum(isnan(aux_rij)) < length(rij)
    [~,idx] = max(aux_rij);

    % Chosen pair i,j
    Vi(k) = aux_i(idx);
    Vj(k)= aux_j(idx);

    % Remove chosen i and j from aux_i
    aux_i(aux_i == Vi(k)) = NaN;
    aux_i(aux_i == Vj(k)) = NaN;


    % Remove chosen i and j from aux_j
    aux_j(aux_j == Vj(k)) = NaN;
    aux_j(aux_j == Vi(k)) = NaN;

    % Where aux_i or j are NaN, place NaN in the corresponding aux
    aux_i(isnan(aux_j)) = NaN;
    aux_j(isnan(aux_i)) = NaN;


    % Remove points from rij
    aux_rij(idx) = NaN;
    aux_rij(isnan(aux_j)) = NaN;

    % Update k
    k = k+1;
end


% Start builing 'Pairs' structure

% If N is even
if (mod(N,2) == 0)
    pairs = [Vi' Vj'];
    pairsEven = pairs;

    % Construct final pairs (start with the even)
    for i = 1:size(pairsEven,1)
        Pairs.(strcat('p',num2str(i))) = pairsEven(i,:);
    end


    % If N is odd
else
    allV = 1:N;
    vTotal = [Vi Vj];
    rv = setdiff(allV,vTotal); % remaining variable

    % Correlation possibilities that include rv (idx of combinations)
    rv_possibilities = sort([find(i_array == rv) find(j_array == rv)]);

    % Get correlation coefficients from all possible pairs
    rv_rij = rij(rv_possibilities);

    % Get the maximum
    [~,idx_odd] = max(rv_rij);

    % Get the idx of pair where rv_rij is maximum
    rv_combo = rv_possibilities(idx_odd);


    % Get that pair Vi, vj
    Vi(k) = i_array(rv_combo);
    Vj(k) = j_array(rv_combo);


    % Get pairs:
    pairs = [Vi' Vj'];
    pairsEven = pairs(1:end-1,:);

    % Get last pair
    lastP = pairs(end,:);
    lookupVal = lastP(pairs(end,:) ~= rv);

    % Find the row of pairs where rv needs to be included
    row = find(any(pairsEven == lookupVal,2) == 1);

    % Get that pair
    trio = [pairsEven(row, :) rv];

    % Delete parts of trio from pairs
    pairsEven(row,:) = [];


    % Construct final pairs (start with the even)
    for i = 1:size(pairsEven,1)
        Pairs.(strcat('p',num2str(i))) = pairsEven(i,:);
    end

    % Add the final trio
    Pairs.(strcat('p',num2str(i+1))) = trio;


end


end
