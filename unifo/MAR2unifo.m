function outputX = MAR2unifo(inputX, mr, ftypes, Y)
% MAR2unifo(inputX, mr) performs MARunifo (Twala09)
% It generates mr missing values for pairs of correlated features.
% The mr given is the missing rate for the entire dataset.
%
%
% The features in inputX will be paired (Ax, Ay) according to their
% correlation. Then, for each pair, the feature most correlated with the
% target class Y is chosen to insert missing values (Ay). Ax is used as
% determining feature.
%
%
% For k% of missing values in the whole dataset, 2k% of missing values are
% simulated in Ay. For each Ax, its 2k quantil (cutoff = percentil 2k%) is
% determined and the positions where Ax < cutoff are replaced by NaN.
%
%
% For the case of trios, instead of pairs, 1.5k% of missing values are
% simulated in Ay1 and Ay2. (The two features most correlated with the
% target Y are chosen).
%
%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of the whole dataset
%   Y: class vector
%   ftypes: vector of feature types according to CODES defined by arff
%
%
% OUTPUT:
%   outputX: outputX with mr missing values in the pairs
%
%
% EXAMPLE:
% X = rand(100,4);
% ftypes = [0 0 0 0];
% Y = [ones(1,25) zeros(1,25) ones(1,25) zeros(1,25)]';
% mr = 10;
% outputX = MAR2unifo(X, mr, ftypes, Y);
%
%
% X = rand(100,5);
% ftypes = [0 0 0 0 0];
% Y = [ones(1,25) zeros(1,25) ones(1,25) zeros(1,25)]';
% mr = 10;
% outputX = MAR2unifo(X, mr, ftypes, Y);
%
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



% For this implementation, given the 2k% restriction (see Twala09), the
% missing rate cannot be higher than 50%.
if (mr >= 50)
    error('Error:: Missing Rate is too high for the existing number of patterns.');
end


outputX = inputX;
n = size(inputX,1);

% Get the correlated pairs of inputX
Pairs = getCorrPairs(inputX, ftypes);

% Determine, for each pair, which should be xs (1) and xd (0)
missPairs = getCorrY(inputX, Pairs, Y, ftypes);


varPairs = fieldnames(Pairs);

% For each pair in the dataset
for i = 1:length(varPairs)

    % Check the pair size:
    % If its a pair
    if length(Pairs.(varPairs{i})) == 2
        cutK = 2*mr;
    else
        % If its a trio
        cutK = 1.5*mr;
    end

    % Check where which vars are to be missing and observed
    idx_xs = find(missPairs.(varPairs{i}) == 1);
    idx_xd = find(missPairs.(varPairs{i}) == 0);


    X_xs = inputX(:, Pairs.(varPairs{i})(idx_xs)); % Could be 1 or 2 vars
    X_xd = inputX(:, Pairs.(varPairs{i})(idx_xd)); % Is always one feature


    % Compute the number of patterns to have missing values
    N = round(n*cutK/100);

    % Determine the N lowest values of the determining feature xd
    [~, xd_order] = sort(X_xd);
    lowestNindex = xd_order(1:N);

    outputX(lowestNindex, Pairs.(varPairs{i})(idx_xs)) = NaN;


end
