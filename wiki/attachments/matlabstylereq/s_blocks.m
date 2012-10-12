%% Initial parameters
%
nCols=10;
nRows=10;
%
simMethod='norm';
%
%% Simulation
%
simMat=random(simMethod,nRows,nCols);
%
%% Display results
%
disp(simMethod);
disp(simMat);
