function invEllMat = inv(myEllMat)
%
% INV - inverts shape matrices of ellipsoids in the given array.
%
%   invEllMat = INV(myEllMat)  Inverts shape matrices of ellipsoids
%       in the array myEllMat. In case shape matrix is sigular, it is
%       regularized before inversion.
%
% Input:
%   regular:
%       myEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids.
%
% Output:
%    invEllMat: ellipsoid [mRows, nCols] - matrix of ellipsoids with
%       inverted shape matrices.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(myEllMat,...
    'errorMessage', 'input argument must be array of ellipsoids.');

invEllCMat = arrayfun(@(x) fSingleInv(x),myEllMat,'UniformOutput',false);

invEllMat = reshape([invEllCMat{:}],size(myEllMat));
end

function invEll = fSingleInv(singEll)

if isdegenerate(singEll)
    regShMat = ellipsoid.regularize(singEll.shape,...
        absTolMat(singEll));
else
    regShMat = singEll.shape;
end
regShMat = ell_inv(regShMat);
invEll = ellipsoid(singEll.center , 0.5*(regShMat + regShMat'));

end
