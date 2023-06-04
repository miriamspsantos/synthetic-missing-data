function [outputX, idx] = MCAR3univa(inputX, mr, varargin)
% MCAR3univa(inputX, mr, varargin) performes MCAR generation according to
% what was explained in Laencina10 and Laencina13 (see REFERENCES)
%
%
% INPUT:
%   inputX = dataset X
%   mr = missing rate for a single feature
%   varargin: could be:
%            1) nothing: the program chooses one feature to be missing,
%             randomly;
%
%            2) a number: indicates the index of the feature to be missing
%
%            3) A combo ['min' T]: indicating that we want to insert NaN in
%            the LEAST RELEVANT feature for classification, determined by
%            NMI. T is the target vector, the class labels
%
%            4) A combo ['max' T]: indicating that we want to insert NaN in
%            the MOST RELEVANT feature for classification, determined by
%            NMI. T is the target vector, the class labels
%
%
% OUTPUT:
%   outputX = data with missing values in one feature
%   idx = the idx of the feature that is missing
%
%
% REFERENCES:
%
% @article{Laencina10,
%   title={Pattern classification with missing data: a review},
%   author={Garc{\'\i}a-Laencina, Pedro J and Sancho-G{\'o}mez, Jos{\'e}-Luis and Figueiras-Vidal, An{\'\i}bal R},
%   journal={Neural Computing and Applications},
%   volume={19},
%   number={2},
%   pages={263--282},
%   year={2010},
%   publisher={Springer}
% }
%
%
% @article{Laencina13,
%   title={Classifying patterns with missing values using Multi-Task Learning perceptrons},
%   author={Garc{\'\i}A-Laencina, Pedro J and Sancho-G{\'o}Mez, Jos{\'e}-Luis and Figueiras-Vidal, An{\'\i}Bal R},
%   journal={Expert Systems with Applications},
%   volume={40},
%   number={4},
%   pages={1333--1341},
%   year={2013},
%   publisher={Elsevier}
% }
%
%
%   EXAMPLE:
%   filename = 'telegu.arff';
%   [dataOut,DataTab,DataStruct] = arff2double(filename);
%   X = dataOut.A(:,1:3);
%   T = dataOut.A(:,end);
%
%   [outputX, idx] = MCAR3univa(X, 50); % Chooses randomly
%   [outputX, idx] = MCAR3univa(X, 50, 2); % NaN in idx 2
%   [outputX, idx] = MCAR3univa(X, 50, 'min', T); % LEAST RELEVANT
%   [outputX, idx] = MCAR3univa(X, 50, 'max', T); % MOST RELEVANT
%
%
% Copyright: Miriam Santos, 2017

outputX = inputX;
p = size(inputX,2);
n = size(inputX,1);


if (mr >= 100)
    error('Error:: Missing Rate is too high, the whole feature will be deleted!');
end


if isempty(varargin)
    % Choose a random feature
    idx = randi(p);

elseif varargin{1} == 'min'
    % Choose the min of NMI
    [~, order] = nmi(inputX,varargin{2}); % varargin{2} = T (target)
    idx = order(1);

elseif varargin{1} == 'max'
    % Choose the max of NMI
    [~, order] = nmi(inputX,varargin{2}); % varargin{2} = T (target)
    idx = order(end);

else
    % The idx of feature is given by varargin
    idx = varargin{1};
end

% Number of cases to 'remove'
N = round(mr*n/100);

% Choose random positions to be missing in idx
P = randperm(n,N);

% Assign those positions to NaN
outputX(P,idx) = NaN;
