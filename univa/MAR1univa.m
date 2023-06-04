function [outputX, idx_xs, idx_xd] = MAR1univa(inputX, mr, ftypes, Y, flag)
% MAR1univa(inputX, mr, ftypes, Y) performs MARuniva (Twala09)
% It generates mr missing values on only one feature. The mr given can be
% the mr of whole dataset or of a feature alone, depending on the value of flag.
%
%
% The feature to be missing, xs, is the one highly correlated with the class
% variable (as is done in the paper). Then, the determining feature xd is
% the one that is highly correlated with xs.
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
%
% OUTPUT:
%   outputX: outputX with mr missing values in one feature
%
%
% EXAMPLE:
% X = rand(200,4);
% ftypes = [0 0 0 0];
% Y = [ones(1,25) zeros(1,25) ones(1,25) zeros(1,25)]';
% mr = 10;
% flag = 0;
% flag = 1;
% [outputX, idx_xs, idx_xd] = MAR1univa(X, mr, ftypes, Y, flag)
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


outputX = inputX;

n = size(inputX,1); % Number of patterns
p = size(inputX,2); % Number of features


if flag
    if (mr >= 100/p)
        error('Error:: Missing Rate is too high for the existing number of features.');
    end
    N = round(n*p*mr/100); % Correction for mr of whole dataset
else
    if (mr >= 100)
        error('Error:: Missing Rate is too high, the whole feature will be deleted!');
    end
    N = round(n*mr/100); % mr for that feature only
end


% Determine which feature xs should be missing
% It should be the one highly correlated with the class
for i = 1:p
    rxs(i) = association(inputX(:,i), Y, ftypes(i), 5);
end

[~, idx_xs] = max(rxs);


% Determine the feature most correlated with xs, that is, xd
for i = 1:p
    rxd(i) = association(inputX(:,i), inputX(:,idx_xs), ftypes(i), ftypes(idx_xs));
end

rxd(idx_xs) = NaN;
[~, idx_xd] = max(rxd);


% Get the determining feature xd
xd = inputX(:,idx_xd);


% NOTE: This following procedure of looking for the N lowest values in the
% percentil is necessary so that the code is able to deal with nominal and
% ordinal values (many are repeated), so we need to account for this...
% Otherwise we could use the function percentil directly and replace the
% values under it.


% Determine the N lowest values of the determining feature xd
[~, xd_order] = sort(xd);
lowestNindex = xd_order(1:N);

outputX(lowestNindex,idx_xs) = NaN;
