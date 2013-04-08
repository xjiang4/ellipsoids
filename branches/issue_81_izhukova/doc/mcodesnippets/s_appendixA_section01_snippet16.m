firstEllObj = ellipsoid([-2; -1], [4 -1; -1 1]);
secEllObj = 3*ell_unitball(2);
dirsMat = [1 0; 1 1; 0 1; -1 1]';
bufEllVec = [secEllObj firstEllObj];
internalEllVec = secEllObj.minkmp_ia(firstEllObj, bufEllVec, dirsMat)

% internalEllVec =
% 1x2 array of ellipsoids.