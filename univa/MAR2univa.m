function [outputX, pb, idx_xs, idx_xd] = MAR2univa(inputX, mr, varargin)
% MAR2univa(inputX, mr, varargin) performs MAR1 (Rieger10)
%
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%):
%           -- of the whole dataset for nxs features
%           -- of one feature alone otherwise
%
%   varargin: could be
%           -- 0 arguments: 2 features are randomly chosen, one xs and one
%           xd, and only one will have missing data. mr is the mr for one
%           feature alone!
%
%           -- 1 argument: nxs features. mr is the mr of the whole dataset,
%           divided by all features to be missing. nxs features are chosen
%           randomly
%
%           -- 2 arguments (xs,xd): the mr is the mr for that feature
%
%       SEE EXAMPLES to understand better.
%
% OUTPUT:
%   outputX: outputX with mr missing values in one feature or in the nxs features
%
%
% EXAMPLE:
% X = rand(5,10)
% [outputX, pb, idx_xs, idx_xd] = MAR2univa(X, 50, 8) % 8 features missing
% [outputX, pb, idx_xs, idx_xd] = MAR2univa(X, 50,1,3) % in 1, based
% on 3
% [outputX, pb, idx_xs, idx_xd] = MAR2univa(X, 50) % randomly in one
%
%
%
%
% REFERENCES:
% @article{Rieger10,
%   title={Random forests with missing values in the covariates},
%   author={Rieger, Anna and Hothorn, Torsten and Strobl, Carolin},
%   year={2010}
% }
%
% Copyright: Miriam Santos, 2017

outputX = inputX;

% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);


% If missing rate is too high, there will not be enough values in one
% feature to remove
if (mr >= 100)
    error('Error:: Missing Rate is too high, the whole feature(s) will be deleted!');
end


switch length(varargin)
    % Choose xs,xd random
    case 0
        % Randomly choose the determining feature, xd and save it as an auxiliar
        % variable
        idx_xd = randi(p);

        % Randomly choose the simulated features xs (cannot be the same as xd)
        values = 1:p;
        values(idx_xd) = []; % idx_xd cannot be chosen
        idx_xs = values(randi(numel(values)));

        % Compute the number of patterns to have missing values
        N = round(n*mr/100);


        % Choose nxs random
    case 1

        % ERROR CHECKS
        if (n*p*mr/100/varargin{1})>n
            error('Error:: Number of nxs is to low for specified missing rate.')
        end


        if varargin{1}>=p
            error('Error: Number of features to simulate is higher than the existing number of features.')
        end


        idx_xd = randi(p);
        values = 1:p;
        values(idx_xd) = []; % idx_xd cannot be chosen
        idx_xs = values(randperm(numel(values),varargin{1}));
        % Compute the number of patterns to have missing values
        N = round(n*p*mr/100/varargin{1});

    case 2
        idx_xs = varargin{1};
        idx_xd = varargin{2};

        % Compute the number of patterns to have missing values
        N = round(n*mr/100);

end


aux_xd = inputX(:,idx_xd);

% Define the probabilities of missingness according to the determining
% feature xd
[~, xd_order] = sort(aux_xd);
rank(xd_order) = 1:n;

pb(xd_order) = rank(xd_order)/sum(rank);

% Select the N patterns to be missing according to probability p
idx = samplefromp(n,pb,N);


% Introduce the missing values in the feature xs corresponding to the
% indices idx
outputX(idx,idx_xs) = NaN;


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


end
