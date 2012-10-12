%initial parameters
nRows=15;
nCols=10;
%generate random matrix
randMat=rand(nRows,nCols);
%find negative elements
isnNeg=randMat>=0;
%find sum of negative elements
res=sum(randMat(isnNeg));
%display results
disp(res);
