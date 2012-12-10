function invEllArr = inv(myEllArr)
%
% INV - inverts shape matrices of ellipsoids in the given array.
%
%   invEllArr = INV(myEllArr)  Inverts shape matrices of ellipsoids
%       in the array myEllMat. In case shape matrix is sigular, it is
%       regularized before inversion.
%
% Input:
%   regular:
%       myEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of ellipsoids.
%
% Output:
%    invEllArr: ellipsoid [nDims1,nDims2,...,nDimsN] - array of ellipsoids
%       with inverted shape matrices.
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

ellipsoid.checkIsMe(myEllArr);

invEllCMat = arrayfun(@(x) fSingleInv(x),myEllArr,'UniformOutput',false);

invEllArr = reshape([invEllCMat{:}],size(myEllArr));
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
