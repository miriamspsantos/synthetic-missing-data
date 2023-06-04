function [outputX, logicalTemplate, idx_xs] = MCAR1univa(inputX, mr, ftypes, Y, flag)
% MCAR1univa(inputX, mr, ftypes, Y, flag) performs MCARuniva (Twala09)
% It generates mr missing values on ONLY ONE FEATURE (the one most
% correlated with the target Y) according to a
% Bernoulli distribution. The mr given can be the mr of whole dataset or of
% a feature alone, depending on the value of flag.
%
%
% This implementation chooses the feature most related to the target T to
% be missing.
%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%)
%           -- of the whole dataset if flag is 1
%           -- of that feature if flag is 0
%   Y: class vector
%   ftypes: vector of feature types according to CODES defined by arff
%
%   flag:
%       -- if 1, then correction for mr of whole dataset is applied (N = p*mr)
%       -- if 0, mr is considered to be of that feature alone
%
% OUTPUT:
%   outputX: outputX with mr missing values in one feature
%
%
% EXAMPLE:
% X = rand(200,4)
% ftypes = [0 0 0 0];
% Y = [ones(1,50) zeros(1,50) ones(1,50) zeros(1,50)]';
% mr = 20;
% flag = 0;
% flag = 1;
% outputX = MCAR1univa(inputX, mr, ftypes, Y, flag)
%
%
% load appendicitis.mat
% [outputX, logicalTemplate, idx_xs] = MCAR1univa(dataOut.A(:,1:end-1), 30, dataOut.ftypes, dataOut.A(:,end), 0)
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
% Last-update: 20-10-17


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);



if flag
    if (mr >= 100/p)
        error('Error:: Missing Rate is too high for the existing number of features.');
    end
    % For mr% of the whole dataset, for only one feature, we need p*mr% of
    % missing values.
    psucess = p*mr/100; % Correction for mr of whole dataset
else
    if (mr >= 100)
        error('Error:: Missing Rate is too high, the whole feature will be deleted!');
    end
    psucess = mr/100; % mr for that feature only
end


% For mr% of the whole dataset, for only one feature, we need p*mr% of
% missing values.
% Generate n Bernoulli trials, with probability of sucess p*mr%
% Each pattern has the same probability of being observed or missing


% Missing value template
mv_template = binornd(1,psucess,1,n);
logicalTemplate = logical(mv_template);

% Choose feature to have its values missing (the one more correlated
% with the target Y):

for i = 1:p
    rxs(i) = association(inputX(:,i), Y, ftypes(i), 5);
end

[~, idx_xs] = max(rxs);


% Add missing values
outputX(logicalTemplate,idx_xs) = NaN;


% BEWARE:
% Sometimes the bernoulli array may not produce sucessful trials
% You should create a condition in the program that calls this to verify if
% there truly are missing values in the data


% maxSim = 10;
% maxSim = 100;
% maxSim = 1000;
% maxSim = 1000;
% maxSim = 1000;
% for i = 1:maxSim
% X = rand(100,4);
% [outputX, logicalT] = MCAR1univa(X, 20);
% m(i) = sum(logicalT);
% end


% Return a warning if some patterns or some features are completely
% missing, or have only some values (defined by thresh)

% Number of features with all values missing (or only one value)

%------------------------------------------------------------------------
% Number of existing (non-NaN) values for each is considered 'risk'
thresh = 1;
%------------------------------------------------------------------------

nFeaturesRisk = sum(ge(sum(isnan(outputX)), n-thresh));
nPatternsRisk = sum(ge(sum(isnan(outputX),2),p-thresh));

if (nFeaturesRisk > 0)
    warning('FEATURES in risk of being all NaN: %d',nFeaturesRisk)
end


if (nPatternsRisk > 0)
    warning('PATTERNS in risk of being all NaN: %d',nPatternsRisk)
end



%------------------------------------------------------------------------
% Given the generation of Bernoulli trials, also send a warning if there
% are no missing values:
%------------------------------------------------------------------------
if sum(sum(isnan(outputX))) == 0
    warning('No missing values were generated for MCARuniv');
end



end
