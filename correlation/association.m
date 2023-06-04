function r = association(xA, xB, typeA, typeB)
% association(xA, xB, typeA, typeB) returns the correlatin coefficient
% between xA and xB according to their feature types, typeA and typeB
% 
% 
%   INPUT:
%       xA, xB = feature vectors
%       typeA, tyoeB = feature types of xA and xB according to CODES read
%       from arff.
% 
% 
%   OUTPUT:
%       r = correlation coefficient between xA and xB 
% 
% 
% CODES FROM ARFF READ (ftypes)
% ftypes => array defining the type of attribute:
%
%   0 = numeric/continuous
%   1 = categorical (nominal)
%   2 = string
%   3 = date
%   4 = ordinal (if coded as numeric)
%   5 = binary
%   6 = ordinal (if coded as categorical)
% 
% 
% Copyright: Miriam Santos, 2017

if (typeA == 0 && typeB == 0) % CONTINUOUS+CONTINUOUS -- pearson(datai1, datai2)
    r = pearson(xA,xB);
%     disp('xA and xB are CONTINUOUS.');
    
elseif (typeA == 5 && typeB == 5) % BINARY+BINARY -- phi(datan1, datan2)
    r = phi(xA,xB);
%     disp('xA and xB are BINARY.');
    
elseif (typeA == 4 || typeA == 6) && (typeB == 4 || typeB == 6) % ORDINAL+ORDINAL -- spearman(x1, x2)
    r = spearman(xA, xB);
%     disp('xA and xB are ORDINAL.');
    
elseif (typeA == 1 && typeB == 1) % NOMINAL+NOMINAL -- cramerV(x1, x2)
    r = cramerV(xA, xB);
%     disp('xA and xB are NOMINAL.');
    
elseif (typeA == 1 && typeB == 5) || (typeA == 5 && typeB == 1) % NOMINAL+BINARY / BINARY+NOMINAL -- cramerV(x1, x2)
    r = cramerV(xA,xB);
%     disp('xA is NOMINAL/BINARY and xB is NOMINAL/BINARY.');
    
elseif (typeA == 0 && typeB == 5) % CONTINUOUS+BINARY -- pbiserial(datan,datai)
    r = pbiserial(xB,xA); % xB is binary
%     disp('xA is CONTINUOUS and xB is BINARY.');
    
elseif (typeA == 5 && typeB == 0) % BINARY+CONTINUOUS -- pbiserial(datan,datai)
    r = pbiserial(xA, xB); % xA is binary
%     disp('xA is BINARY and xB is CONTINUOUS.');
    
elseif (typeA == 0) && (typeB == 4 || typeB == 6) % CONTINUOUS+ORDINAL -- spearman(x1, x2)
    r = spearman(xA, xB);
%     disp('xA is CONTINUOUS and xB is ORDINAL.');
    
elseif (typeA == 4 || typeA == 6) && (typeB == 0) % ORDINAL+CONTINUOUS -- spearman(x1, x2)
     r = spearman(xA, xB);
%     disp('xA is ORDINAL and xB is CONTINUOUS.');
     
elseif (typeA == 5) && (typeB == 4 || typeB == 6) % BINARY + ORDINAL -- rankbiserial(dataN,dataO)
     r = rankbiserial(xA,xB); % xA is binary
%      disp('xA is BINARY and xB is ORDINAL.');
     
elseif (typeA == 4 || typeA == 6) && (typeB == 5) % ORDINAL + BINARY -- rankbiserial(dataN,dataO)    
    r = rankbiserial(xB,xA); % xB is binary
%      disp('xA is ORDINAL and xB is BINARY.');
     
elseif (typeA == 0 && typeB == 1) % CONTINUOUS + NOMINAL -- eta(dataI, dataN)
    r = eta(xA,xB); % xB is nominal
%     disp('xA is CONTINUOUS and xB is NOMINAL.');
    
elseif (typeA == 1 && typeB == 0) % NOMINAL + CONTINUOUS -- eta(dataI, dataN)
    r = eta(xB,xA); % xA is nominal
%     disp('xA is NOMINAL and xB is CONTINUOUS.');
    
elseif (typeA == 4 || typeA == 6) && (typeB == 1) % ORDINAL + NOMINAL -- eta(dataI, dataN)
     r = eta(xA,xB); % xA is ordinal and xB is nominal
%      disp('xA is ORDINAL and xB is NOMINAL.');
     
     
elseif (typeA == 1) && (typeB == 4 || typeB == 6) % NOMINAL + ORDINAL -- eta(dataI, dataN)
    r = eta(xB,xA); % xA is nominal and xB is ordinal
%     disp('xA is NOMINAL and xB is ORDINAL.');
  
    
end

end


% -----------
% OPTIONS:
% -----------

% CONTINUOUS+CONTINUOUS -- pearson(datai1, datai2)
% CONTINUOUS+ORDINAL -- spearman(x1, x2)
% CONTINUOUS+NOMINAL -- eta(dataI, dataN)
% CONTINOUS+BINARY -- pbiserial(datan,datai)

% ORDINAL+CONTINUOUS -- spearman(x1, x2)
% ORDINAL+ORDINAL -- spearman(x1, x2)
% ORDINAL+NOMINAL -- eta(dataI, dataN)
% ORDINAL+BINARY -- rankbiserial(dataN,dataO)

% NOMINAL+CONTINUOUS -- eta(dataI, dataN)
% NOMINAL+ORDINAL -- eta(dataI, dataN)
% NOMINAL+NOMINAL -- cramerV(x1, x2)
% NOMINAL+BINARY -- cramerV(x1, x2)

% BINARY+CONTINUOUS -- pbiserial(datan,datai)
% BINARY+ORDINAL -- rankbiserial(dataN,dataO)
% BINARY+NOMINAL -- cramerV(x1, x2)
% BINARY+BINARY -- phi(datan1, datan2)

