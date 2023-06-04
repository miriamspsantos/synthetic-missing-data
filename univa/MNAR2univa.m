function [outputX,idx_xs] = MNAR2univa(inputX, mr, varargin)
% MNAR2univa(inputX, mr) performs MNAR generation according to Xia17.
% The highest values of xs features are set to NaN.
%
% INPUT:
%   inputX: matrix of data (n patterns x p features)
%   mr: missing rate (%) of one feature
%
%   varargin: could be
%           -- 0 arguments: feature xs is randomly chosen
%           -- 1 argument: the index of feature xs is given by varargin{1}
%
% OUTPUT:
%   outputX: outputX with mr missing values in one feature or in the nxs features
%
%
% EXAMPLE:
% X = rand(5,10)
% [outputX, idx_xs] = MNAR2univa(X, 50) % randomly chosen
% [outputX, idx_xs, idx_xd] = MNAR2univa(X, 50, 3) % missing in 3
%
%
%
% REFERENCES:
%@article{Xia17,
%   title={Adjusted weight voting algorithm for random forests in handling missing values},
%   author={Xia, Jing and Zhang, Shengyu and Cai, Guolong and Li, Li and Pan, Qing and Yan, Jing and Ning, Gangmin},
%   journal={Pattern Recognition},
%   volume={69},
%   pages={52--60},
%   year={2017},
%   publisher={Elsevier}
% }
%
%
%
% Copyright: Miriam Santos, 2017


outputX = inputX;
% Determine number of patterns n and number of features p in inputX
n = size(inputX,1);
p = size(inputX,2);


if (mr >= 100)
    error('Error:: Missing Rate is too high, the whole feature will be deleted!');
end


switch length(varargin)
    case 0
        % Choose xs random
        idx_xs = randi(p);

    case 1
        idx_xs = varargin{1};
end


% Compute the number of patterns to have missing values
N = round(n*mr/100);

% Determine the N highest values of xs
[~, xd_order] = sort(inputX(:,idx_xs));
highestNindex = xd_order(end:-1:end-(N-1));

% Set then to NaN
outputX(highestNindex,idx_xs) = NaN;


end
