function missPairs = getCorrY(X, Pairs, Y, ftypes)
% missPairs = getCorrY(X, Pairs, Y, ftypes) returns the same pairs as Pairs
% with 0/1 values indicating (0 = observed and 1 = to be missing).
%
%       INPUT:
%           X = dataset
%           Pairs = structure of correlated pairs in X
%           Y = categorical variable that indicates the class
%           ftypes = feature types
%
%       OUTPUT:
%           missPairs = structure indicating, for each pair, which variable
%           is observed and which will have missing values
%
%
% Copyright: Miriam Santos, 2017

varPairs = fieldnames(Pairs);


% For all pairs
for i = 1:length(varPairs)

    combo = Pairs.(varPairs{i});
    pairs = X(:,combo);
    types = ftypes(combo);

    mPairs = zeros(1,length(combo));

    % For each variable in the pair
    for j = 1:length(combo)

        var = combo(j);

        % Get association of each variable with the target/class, Y (binary):
        r(j) = association(X(:,var), Y, types(j), 5);

    end

    % If it's a pair, get the most correlated with target
    if (length(combo) == 2)
        [~,idx] = max(r);
        mPairs(idx) = 1; % The most correlated should be missing

    else % If it's a trio, get the two most correlated with target
        [~, idx] = sort(r);
        twoIdx = idx(end:-1:end-1);
        mPairs(twoIdx) = 1; % The two most correlated should be missing
    end


    missPairs.(varPairs{i}) = mPairs;

end


end
