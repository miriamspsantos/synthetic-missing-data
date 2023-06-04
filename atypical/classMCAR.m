function dataMiss = classMCAR(X, T, percentage, type, minClass, majClass, varargin)
% classMCAR Introduces MCAR mechanism in the data in X
%
%   INPUT:
%       X = dataset (samples x features)
%       percentage = percentage of desired missing rate. In this case,
%       the percentage is considered as numberOfMissings/NumberOfElements xij.
%       There is not a guarantee that all features have the same percentage
%       of missing data, so several runs should be performed.
%       type = desired type of missing data insertion (string):
%               -- minority: only in minority class
%               -- majority: only in majority class
%               -- both: half of the percentage in minority and majority
%               class
%   OUTPUT:
%       dataMiss = data with missing data (X with some elements to NaN)
%
%
% Copyright: Miriam Santos 2018

% Get minority data and number of xij positions
idx_min = find(T == minClass);
Xmin = X(idx_min,:);

% Get majority data and number of xij positions
idx_maj = find(T == majClass);
Xmaj = X(idx_maj,:);

% Determine the number of elements to create has NaN
noMissings = round(percentage*numel(X)/100);

% Check if X already has missing values
noNaN = sum(sum(isnan(X)));
noValues = abs(noNaN - noMissings); % Number of missing elements to create

% If the number of existing NaN values is higher than the number of missing values to insert, throw an error:
if noNaN > noMissings
    error('ERROR: The desired missing rate is lower than the original missing rate in the dataset! Try a higher rate...');
elseif noNaN == noMissings
    return;
else
    switch type
        case 'minority'
            if noValues > sum(sum(~isnan(Xmin)))
                error('ERROR: The desired missing rate will delete the entire minority data! Try a lower rate!...');
            else
                % Determine the possible elements where missing values can be inserted
                possibleElements = find(~isnan(Xmin));
                P = randperm(numel(possibleElements),noValues);
                Xmin(possibleElements(P)) = NaN;
            end
        case 'majority'
            if noValues >  sum(sum(~isnan(Xmaj)))
                error('ERROR: The desired missing rate will delete the entire minority data! Try a lower rate!...');
            else
                % Determine the possible elements where missing values can be inserted
                possibleElements = find(~isnan(Xmaj));
                P = randperm(numel(possibleElements),noValues);
                Xmaj(possibleElements(P)) = NaN;
            end
        case 'equal'
            noHalf_min = floor(noValues/2);
            noHalf_maj = noValues - noHalf_min;
            if (noHalf_min > sum(sum(~isnan(Xmin)))) || (noHalf_maj > sum(sum(~isnan(Xmaj))))
                error('ERROR: The desired missing rate is to high, it will delete one of the classes, or both.');
            else
                % Determine the possible elements where missing values can be inserted
                possibleElements = find(~isnan(Xmin));
                P = randperm(numel(possibleElements),noHalf_min);
                Xmin(possibleElements(P)) = NaN;

                % Determine the possible elements where missing values can
                % be inserted (maj class)
                possibleElements = find(~isnan(Xmaj));
                P = randperm(numel(possibleElements),noHalf_maj);
                Xmaj(possibleElements(P)) = NaN;
            end
        case 'unequal'
            noNaN_insert_min = floor(varargin{1}*noValues/percentage);
            noNaN_insert_maj = floor(varargin{2}*noValues/percentage);
            if (noNaN_insert_min > sum(sum(~isnan(Xmin)))) || (noNaN_insert_maj > sum(sum(~isnan(Xmaj))))
                error('ERROR: The desired missing rate is to high, it will delete one of the classes, or both.');
            else
                % Determine the possible elements where missing values can be inserted
                possibleElements = find(~isnan(Xmin));
                P = randperm(numel(possibleElements),noNaN_insert_min);
                Xmin(possibleElements(P)) = NaN;

                % Determine the possible elements where missing values can
                % be inserted (maj class)
                possibleElements = find(~isnan(Xmaj));
                P = randperm(numel(possibleElements),noNaN_insert_maj);
                Xmaj(possibleElements(P)) = NaN;
            end
    end
    dataMiss(idx_min,:) = Xmin;
    dataMiss(idx_maj,:) = Xmaj;
end
