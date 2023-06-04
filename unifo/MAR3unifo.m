function outputX = MAR3unifo(inputX, mr, ftypes, flag)
% MAR3unifo(inputX, mr, ftypes) performs MAR from Ali17. It generates mr
% missing values for pairs of correlated features. The mr given is the
% missing rate for the entire dataset.
%
%
% The features in inputX will be paired (Ax, Ay) according to their
% correlation. Then, for each pair, one feature is selected randomly to be
% missing. For trios, 2 features are randomly selected to be missing. Ax is
% used as determining feature.
%
%
% For k% of missing values in the whole dataset, 2k% of missing values are
% simulated in Ay. Ax is divided into two groups, one whose values are
% higher than the median of Ax and the other, whose values are higher than
% the median of Ax. One of those groups is randomly chosen and 4k% of missing
% values are introduced in the corresponding positions of Ay.
%
% For the case of trios, instead of pairs, 3k% of missing values are
% simulated in Ay1 and Ay2 (lower than median).
%
%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of the whole dataset
%   ftypes: vector of feature types according to CODES defined by arff
%    flag: could be
%           0 = no need for correction in numeric variables (uses median)
%           1 = performs correction for numeric variables (guarantees
%               two groups of same size)
%
% OUTPUT:
%   outputX: outputX with mr missing values in the pairs
%
%
% EXAMPLE:
% X = rand(100,4);
% ftypes = [0 0 0 0];
% mr = 10;
% outputX = MAR3unifo(X, mr, ftypes);
%
%
% X = rand(100,5);
% ftypes = [0 0 0 0 0 0];
% mr = 10;
% outputX = MAR3unifo(X, mr, ftypes);
%
%
%
% REFERENCES:
% @article{Ali17,
%   title={Improving accuracy of missing data imputation in data mining},
%   author={Ali, Nzar A and Omer, Zhyan M},
%   journal={Kurdistan Journal of Applied Research},
%   volume={2},
%   number={3},
%   year={2017}
% }
%
%
% Copyright: Miriam Santos, 2017


% For this implementation, given the 4k% restriction (see Ali17), the
% missing rate cannot be higher than 25%.
if (mr > 25)
    error('Error:: Missing Rate is too high for the existing number of patterns.');
    return;
end

outputX = inputX;
n = size(inputX,1);

% Get the correlated pairs of inputX
Pairs = getCorrPairs(inputX, ftypes);

% Determine, for each pair, which should be xs (1) and xd (0)
% In this implementation, this is done randomly
missPairs = randomMissPairs(Pairs);


varPairs = fieldnames(Pairs);

% For each pair in the dataset
for i = 1:length(varPairs)

    % Check the pair size:
    % If its a pair
    if length(Pairs.(varPairs{i})) == 2
        cutK = 4*mr;
    else
        % If its a trio
        cutK = 3*mr;
    end

    % Check where which vars are to be missing and observed
    idx_xs = find(missPairs.(varPairs{i}) == 1);
    idx_xd = find(missPairs.(varPairs{i}) == 0);


    X_xd = inputX(:, Pairs.(varPairs{i})(idx_xd)); % Is always one feature


    switch flag
        case 0
            % Get the median of X_xd
            medVal = median(X_xd);

            % Get the groups lower than the median
            logicalGroups = le(X_xd,medVal);
            % 1 indicates that X_xd <= medVal
            % 0 indicates that X_xd > medVal

            % Choose one of those groups randomly
            g = randi(2)-1;

            % And get that group
            groupIdx = find(logicalGroups == g);
            % g = 1 --> lower than median
            % g = 0 --> higher than median


        case 1
            % Build two equally-sized groups from categorical data
            catGroup = divideCategorical(X_xd);

            % Choose one group randomly
            c = randi(2);

            % And get that group
            groupIdx = catGroup.(strcat('g',num2str(c)));

    end


    % Find the length of groupIdx
    Ngroup = length(groupIdx);

    % Compute the number of patterns to have missing values
    N = round(Ngroup*cutK/100);


    % 'Median' not providing two equally-sized groups
    % Should be unlikely for numerical/continuous features...
    if (floor(N) ~= floor((n*(cutK/2)/100)))
        warning('Not removing the correct amount.')
    end

    % Get N random values to be removed
    missValues = groupIdx(randperm(numel(groupIdx),N));

    % Place them as NaN
    outputX(missValues, Pairs.(varPairs{i})(idx_xs)) = NaN;


end

end
