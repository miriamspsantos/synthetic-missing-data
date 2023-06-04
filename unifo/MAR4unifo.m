function [outputX, Pairs, missPairs] = MAR4unifo(inputX, mr, categ, flag)
% MAR4unifo(inputX, mr, categ) performs MAR from Zhu12.
%
% The features in inputX will be paired (Ax, Ay) randomly.
% Then, for each pair, one feature is selected randomly to be
% missing.
%
% Trios are made also randomly (one pair is randomly selected to for a trio).
% For trios, 2 features are randomly selected to be missing. Ax is
% used as determining feature.
%
%
% For k% of missing values in the whole dataset, 2k% of missing values are
% simulated in Ay.
%
%
% For numerical data, Ax is divided into two groups, one whose values are
% higher than the median of Ax and the other, whose values are higher than
% the median of Ax. One group is randomly chosen and its missing rate is
% set to 4k%. (3k% for trios)
%
%
% For nominal data, the observations are divided into two equal-sized
% groups. One group is randomly chosen and its missing rate is
% set to 4k%. (3k% for trios)
%
%
% INPUT:
%       inputX: matrix of data (n patterns x p features)
%       mr: missing rate (%) of the whole dataset
%       categ: 0/1 array indicating if features are categorical (1) or not (0)
%       (must come from arff2double --> dataOut.CatLogical)
%       flag: could be
%           0 = no need for correction in numeric variables (uses median)
%           1 = performs correction for numeric variables (guarantees
%               two groups of same size)
%
%
% OUTPUT:
%   outputX: outputX with mr missing values in the pairs
%
%
% EXAMPLE:
% X = rand(100,5);
% categ = [0 0 0 0 0];
% mr = 10;
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,0)
%
%
%  X = rand(100,4);
% categ = [0 0 0 0];
% mr = 10;
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,0)
%
%
% x = rand(100,4);
% Cat = [ones(1,50) ones(1,50)+1]';
% X = [x Cat];
% categ = [0 0 0 0 1];
% mr = 10;
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,0)
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,1)
%
%
% x = rand(100,1);
% Cat = [ones(1,80) ones(1,20)+1]';
% X = [x Cat];
% mr = 10;
% categ = [0 1];
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,0)
%
% Two numeric and no correction:
% Try several times. At some point, the warning will be trigered due
% to the problem of median...
% x = rand(100,1);
% Cat = [ones(1,80) ones(1,20)+1]';
% X = [x Cat];
% mr = 10;
% categ = [0 0];
% [outputX, Pairs, missPairs] = MAR4unifo(X, mr, categ,0)
%
%
% REFERENCES:
% @article{Zhu12,
%   title={A robust missing value imputation method for noisy data},
%   author={Zhu, Bing and He, Changzheng and Liatsis, Panos},
%   journal={Applied Intelligence},
%   volume={36},
%   number={1},
%   pages={61--74},
%   year={2012},
%   publisher={Springer}
% }
%
%
%
% Copyright: Miriam Santos, 2017


% For this implementation, given the 4k% restriction (see Zhu12), the
% missing rate cannot be higher than 25%.
if (mr > 25)
    error('Error:: Missing Rate is too high for the existing number of patterns.');
end

outputX = inputX;
n = size(inputX,1);
p = size(inputX,2);


% Get random pairs of inputX
Pairs = randomPairs(p);

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


    % Check which vars are to be missing and observed
    idx_xs = find(missPairs.(varPairs{i}) == 1);
    idx_xd = find(missPairs.(varPairs{i}) == 0);


    % Get the determining feature xd and its type (categ)
    X_xd = inputX(:, Pairs.(varPairs{i})(idx_xd)); % Is always one feature
    catVal = categ(Pairs.(varPairs{i})(idx_xd));


    % If xd is numeric:
    if (catVal == 0)

        % Check wether correction for groups is performed for numeric
        % features
        switch flag
            case 0
                % Get the median of X_xd
                medVal = median(X_xd);

                % Get the groups lower/higher than the median
                % 1 indicates that X_xd <= medVal
                % 0 indicates that X_xd > medVal
                logicalGroups = le(X_xd,medVal);

                % Choose one group randomly
                g = randi(2)-1;
                % g = 1 --> lower than median
                % g = 0 --> higher than median

                % And get that group
                groupIdx = find(logicalGroups == g);


            case 1
                % Build two equally-sized groups from categorical data
                catGroup = divideCategorical(X_xd);

                % Choose one group randomly
                c = randi(2);

                % And get that group
                groupIdx = catGroup.(strcat('g',num2str(c)));
        end

    else
        % If xd is nominal
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
