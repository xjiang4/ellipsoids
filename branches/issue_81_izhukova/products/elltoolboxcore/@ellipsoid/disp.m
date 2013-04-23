function disp(myEllMat)
%
% DISP - Displays ellipsoid object.
%
% Input:
%   regular:
%     myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%           
% Example:
% ellObj = ellipsoid([-2; -1], [2 -1; -1 1]);
% disp(ellObj)
% 
% Ellipsoid with parameters
% Center:
%     -2
%     -1
% 
% Shape Matrix:
%      2    -1
%     -1     1
% 
%
% $Author: Irina Zhukova <irizka91@gmail.com> $	$Date: 2013-04-19 $ 
% $Copyright: Moscow State University,
%            Faculty of Applied Mathematics and Computer Science,
%            System Analysis Department 2013 $
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright: The Regents of the University of California 
%              2004-2008 $

fprintf('Ellipsoid with parameters\n');

[mRows, nCols] = size(myEllMat);
if (mRows > 1) || (nCols > 1)
    fprintf('%dx%d array of ellipsoids.\n\n', mRows, nCols);
else
    fprintf('Center:\n'); disp(myEllMat.center);
    fprintf('Shape Matrix:\n'); disp(myEllMat.shape);
    if isempty(myEllMat)
        fprintf('Empty ellipsoid.\n\n');
    end
end