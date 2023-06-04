function [outputX, idx_xs, idx_xd] = MAR4univa(inputX, mr, varargin)
%  MAR4univa(inputX, mr, varargin) performs MAR3 (Rieger10)
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
% [outputX, idx_xs, idx_xd] = MAR4univa(X, 50, 8) % 8 features missing
% [outputX, idx_xs, idx_xd] = MAR4univa(X, 50,1,3) % in 1, based
% on 3
% [outputX, idx_xs, idx_xd] = MAR4univa(X, 50) % randomly in one
%
%
% REFERENCES:
% @article{Rieger10,
%   title={Random forests with missing values in the covariates},
%   author={Rieger, Anna and Hothorn, Torsten and Strobl, Carolin},
%   year={2010}
% }
%
%
% Copyright: Miriam Santos, 2017



outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);

if (mr >= 100)
    error('Error:: Missing Rate is too high, the whole feature(s) will be deleted!');
end

switch length(varargin)
    case 0
        idx_xd = randi(p);
        values = 1:p;
        values(idx_xd) = []; % idx_xd cannot be chosen
        idx_xs = values(randi(numel(values)));
        N = round(n*mr/100);


    case 1
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
        N = round(n*p*mr/100/varargin{1});


    case 2
        idx_xs = varargin{1};
        idx_xd = varargin{2};
        N = round(n*mr/100);

end


aux_xd = inputX(:,idx_xd);

% Determine the N highest values of the determining feature xd
[~, xd_order] = sort(aux_xd);
highestNindex = xd_order(end:-1:end-(N-1));

% Introduce the missing values in the features nxs corresponding to the
% indices of X where xd has the highest values
outputX(highestNindex,idx_xs) = NaN;


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
