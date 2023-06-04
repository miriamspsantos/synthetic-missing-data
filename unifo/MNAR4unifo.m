function outputX = MNAR4unifo(inputX, mr, categ, flag)
% MNAR4unifo(inputX, mr, categ) performs MNAR from Zhu12. It generates mr missing
% values in all features.
%
%
% Each feature in the dataset is divided into two groups: numerical values
% are divided according the median and nominal values are randomly divided
% into two equally-sizes groups.
%
% For each feature, one of the groups is set to be missing with 2*mr%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of the whole dataset
%   categ: 0/1 array indicating if features are categorical (1) or not (0)
%   (must come from arff2double --> dataOut.CatLogical)
%   flag: could be
%           0 = no need for correction in numeric variables (uses median)
%           1 = performs correction for numeric variables (guarantees
%               two groups of same size)
%
%
%
% OUTPUT:
%   outputX: outputX with mr missing values in all features
%
%
% EXAMPLE:
% X = rand(100,5);
% categ = [0 0 0 0 0];
% mr = 10;
% outputX = MNAR4unifo(X, mr, categ,0)
% outputX = MNAR4unifo(X, mr, categ,1)
%
% x = rand(100,4);
% Cat = [ones(1,50) ones(1,50)+1]';
% X = [x Cat];
% categ = [0 0 0 0 1];
% mr = 10;
% outputX = MNAR4unifo(X, mr, categ,0)
% outputX = MNAR4unifo(X, mr, categ,1)
%
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
% Copyright: Miriam Santos, 2017


% For this implementation, given the 2k% restriction (see Zhu12), the
% missing rate cannot be higher than 50%.
if (mr > 50)
    error('Error:: Missing Rate is too high for the existing number of patterns.');
end


outputX = inputX;
p = size(inputX,2);
n = size(inputX,1);

% For each feature in the dataset
for i = 1:p

    % Get the feature
    xs = inputX(:,i);
    catVal = categ(i);


    % Check if its nominal ou numeric
    % If xd is numeric:
    if (catVal == 0)
        switch flag
            case 0
                % Get the median of xs
                medVal = median(xs);

                % Get the groups lower/higher than the median
                % 1 indicates that xs <= medVal
                % 0 indicates that xs > medVal
                logicalGroups = le(xs,medVal);

                % Choose one group randomly
                g = randi(2)-1;
                % g = 1 --> lower than median
                % g = 0 --> higher than median

                % And get that group
                groupIdx = find(logicalGroups == g);

            case 1
                % Build two equally-sized groups from categorical data
                catGroup = divideCategorical(xs);

                % Choose one group randomly
                c = randi(2);

                % And get that group
                groupIdx = catGroup.(strcat('g',num2str(c)));
        end
    else
        % If xd is nominal
        % Build two equally-sized groups from categorical data
        catGroup = divideCategorical(xs);

        % Choose one group randomly
        c = randi(2);

        % And get that group
        groupIdx = catGroup.(strcat('g',num2str(c)));

    end

    % Find the length of groupIdx
    Ngroup = length(groupIdx);

    % Compute the number of patterns to have missing values
    cutK = 2*mr;
    N = round(Ngroup*cutK/100);


    % 'Median' not providing two equally-sized groups
    % Should be unlikely for numerical/continuous features...
    if (floor(N) ~= floor((n*mr/100)))
        warning('Not removing the correct amount.')
    end

    % Get N random values to be removed
    missValues = groupIdx(randperm(numel(groupIdx),N));

    % Place them as NaN
    outputX(missValues,i) = NaN;


end

end
