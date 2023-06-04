function [ selectedIndex ] = deterHighHist( data,  numDel, k )
% Author: Jastin Pompeu Soares
% Birth Date: 2016-11-30
% Last review Date: 2016-11-30
% This function search at least k*numDel's which are the most frequent 
% values from data using a histogram with bin width calculated by the 
% method "sqrt". It returns the location on data (Index) from the values 
% found.
%
% 'data' is a vector with all the samples.
% 'numDel' is the number of elements that we pretend to delete from 'data'.
% 'k' is the multiplication factor of 'numDel' - k*numDel gives the number 
%  of elements that we want to found/select. (Default k=1)
%
% [ selectedIndex ] = deterHighHist( data,  numDel, k )
%

%Verification of input arguments
narginchk(2,3);

%check if k is defined
if ~exist('k','var')
    k=1;
end

%verify if the vector  with the data samples is column, make the transpose
if isrow(data)
    data=data';
end

%selected index table inicialization
selectedIndex=[];

%claculate the bins counts for each edge (bin)
[N,EDGES] = histcounts(data,'BinMethod','sqrt');

%Bins  counts limit
limitN=max(N);

%total of elements found
countTotal=sum(N(N>=limitN));

%find the smallest limitN than was K x NumMiss elements or more
while(countTotal<k*numDel)

%step to increment the limitN
    %Step=limitN-max(N(N<limitN));    
%increment the limit and save the anterior
    %limitN=limitN-Step;
limitN=max(N(N<limitN));

%total of elements found
countTotal=sum(N(N>=limitN));
end

%index of the edges that have equal or less bin counts than the 'limitN'
%and won't detected before.
edgeFound=find(N>=limitN);

%obtain the index of the data selected
for i=1:size(edgeFound,2)
    %If the edge found is the last interval of the histogram the
        %restrictions are diferent <= and >=
    if edgeFound(i)<size(EDGES,2)-1
        selectedIndex=[selectedIndex; find(data>=EDGES(edgeFound(i)) & data<EDGES(edgeFound(i)+1))];
    else
       selectedIndex=[selectedIndex; find(data>=EDGES(edgeFound(i)))];
    end
end

end
