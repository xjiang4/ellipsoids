function display(myEllArr)
%
% DISPLAY - Displays the details of the ellipsoid object.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%           
% Example:
%   ellObj = ellipsoid([-2; -1], [2 -1; -1 1]);
%   display(ellObj)
% 
%   ellObj =
% 
%   Center:
%       -2
%       -1
% 
%   Shape Matrix:
%        2    -1
%       -1     1
% 
%   Nondegenerate ellipsoid in R^2.
% 
% 
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright: The Regents of the University of California 
%             2004-2008 $
MAX_DISP_ELEM = 15;
DEFAULT_NAME = 'ellArr';

fprintf('\n');
variableName = inputname(1);
if (isempty(variableName))
    variableName = DEFAULT_NAME;
end

fprintf('-------ellipsoid object-------\n');
fprintf('Properties:\n');
fprintf('   |\n');    
fprintf('   |-- actualClass : ''ellipsoid''\n');
fprintf('   |--------- size : ');
sizeVec = size(myEllArr);
fprintf('[%d', sizeVec(1));
for index = 2 : length(sizeVec)
    fprintf(', %d', sizeVec(index));
end
fprintf(']\n');
fprintf('\n');
fprintf('Fields (name, type, description):\n');
fprintf('    ''Q''    ''double''    ''Configuration matrix''\n');
fprintf('    ''a''    ''double''    ''Center''\n');
fprintf('\nData: \n');

strucdisp(myEllArr.toStruct(), 'maxArrayLength', MAX_DISP_ELEM, ...
     'defaultName', variableName);
end

