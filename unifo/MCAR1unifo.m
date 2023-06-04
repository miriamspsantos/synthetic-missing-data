function outputX = MCAR1unifo(inputX, mr)
% MCAR1unifo(inputX, mr) performs MCARunifo (Twala09)
% It generates mr missing values on ALL THE FEATURES (it is what is
% done in the paper) according to a Bernoulli distribution.
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of the whole dataset
%
% OUTPUT:
%   outputX: outputX with the same mr missing values in all features
%   (global mr rate for the whole dataset)
%
%
% EXAMPLE:
% X = rand(100,4)
% outputX = MCAR1unifo(X, 20)
% sum(isnan(outputX))
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


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);

% Generate n Bernoulli trials, with probability of sucess mr%
% Each pattern has the same probability of being observed or missing

% Probability of sucess
psucess = mr/100;

% For each feature in the dataset, generate a missing value template

for i = 1:p
    mv_template = binornd(1,psucess,1,n);
    logicalTemplate = logical(mv_template);
    outputX(logicalTemplate,i) = NaN;
end


% BEWARE:
% Sometimes the bernoulli array may not produce sucessful trials
% You should create a condition in the program that calls this to verify if
% there truly are missing values in the data

% ------------------------------
% LAW OF LARGE NUMBERS
% ------------------------------
% In this type of generation, we don't specify the number of samples
% to be missing, we specify only the probability of missing (desired missing rate)
% This missing rate is used as probability of sucess in a bernoulli trial
% Sometimes, the mr will be higher, sometimes lower than specified, that is
% why we should perform the simulations/sampling procedures several times

% maxSim = 10;
% maxSim = 100;
% maxSim = 1000;
% maxSim = 1000;
% maxSim = 1000;
% for i = 1:maxSim
% X = rand(100,4);
% [outputX, logicalT] = MCAR1unifo(X, 20);
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
    warning('No missing values were generated for MCAR1unifo');
end

end
