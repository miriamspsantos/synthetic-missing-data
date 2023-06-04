function outputX = MNAR3unifo(inputX, mr, flag)
% MNAR3unifo(inputX, mr) performs MNAR from Ali17. It generates mr missing
% values in all features.
%
%
% Each feature in the dataset is divided into two groups (one with
% values lower than the median and the other with values higher
% than the median). One of the groups is chosen randomly and its values
% will be missing by 2k%, so that the whole feature has k%.
%
%
% In MNAR, the values of each feature itself conditioned the missing
% positions. In this implementation, there are no pairings to be done, the
% procedure is done for all features.
%
%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of the whole dataset
%   flag: could be
%           0 = no need for correction in numeric variables (uses median)
%           1 = performs correction for numeric variables (guarantees
%               two groups of same size)
%
%
% OUTPUT:
%   outputX: outputX with mr missing values in all features
%
%
% EXAMPLE:
% X = rand(100,4);
% mr = 10;
% outputX = MNAR3unifo(X, mr,0);
% outputX = MNAR3unifo(X, mr,1);
%
% X = rand(100,5);
% mr = 10;
% outputX = MNAR3unifo(X, mr,0);
% outputX = MNAR3unifo(X, mr,1);
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


% For this implementation, given the 2k% restriction (see Ali17), the
% missing rate cannot be higher than 50%.
if (mr > 50)
    error('Error:: Missing Rate is too high for the existing number of patterns.');
end


outputX = inputX;
p = size(inputX,2);


% For each feature in the dataset
for i = 1:p

    % Get the feature
    xs = inputX(:,i);


    switch flag
        case 0
            % Get the median of xs
            medVal = median(xs);

            % Get the groups lower than the median
            logicalGroups = le(xs,medVal); % 1 indicates that xs <= medVal


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
