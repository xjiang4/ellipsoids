%initial parameters
nCols=10;
nRows=11;
%simulate data
randMat=rand(nRows,nCols);
%calculate indeces
isPositive=randMat>0; indPositive=find(isPositive);
%calculate number of positive elements: method #1
nPositive=sum(isPositive);
%%calculate number of positive elements: method #2
nPositiveAlt=numel(indPositive);