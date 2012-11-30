function [fstOutEmpt, ellConstr, secOutEmpt, gVec] = ...
    ellconstraint(xVec, Q1, Q2, varargin)
%
% ELLCONSTRAINT - describes ellipsoidal constraint.
%                 This function describes ellipsoidal constraint
%                 <lVec, shMat lVec> = 1,
%                 where shMat is positive semidefinite.
%
% Input:
%   regular:
%       xVec: double[ellDimension, 1] - direction vector.
%           Q1, Q2: are ignored.
%
%   optional:
%       shMat: double[ellDimension, ellDimension] - shape matrix of 
%           ellipsoid. Default values - identity matrix.
%
% Output:
%   fstOutEmpt, secOutEmpt: [] - always empty.
%   ellConstr: double[1, 1] - ellipsoidal constraint
%   GVec: double[ellDimension, 1] -
%
% $Author: Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
% $Copyright:  The Regents of the University of California 2004-2008 $

fstOutEmpt = [];
secOutEmpt = [];

if nargin > 3
    shMat = varargin{1};
    ellConstr = (xVec' * shMat * xVec) - 1;
    gVec = 2 * shMat * xVec;
else
    ellConstr = (xVec' * xVec) - 1;
    gVec = 2 * xVec;
end
