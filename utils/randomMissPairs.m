function missPairs = randomMissPairs(Pairs)
% missPairs = randomMissPairs(Pairs) returns the same pairs as Pairs
% with 0/1 values indicating (0 = observed and 1 = to be missing). In this
% case, the choice is done randomly.
% 
%       INPUT:
%           X = dataset
%           Pairs = structure of correlated pairs in X
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
    
    mPairs = zeros(1,length(combo));
    
    % If it's a pair, get only one random value
    if (length(combo) == 2)
        idx = randi(2); % Choose randomly one feature to be missing
        mPairs(idx) = 1;
        
    else % If it's a trio, get two random values
        twoIdx = randperm(3,2); % Select 2 random positions, out of 3
        mPairs(twoIdx) = 1; 
    end
      
    missPairs.(varPairs{i}) = mPairs;
    
end


end