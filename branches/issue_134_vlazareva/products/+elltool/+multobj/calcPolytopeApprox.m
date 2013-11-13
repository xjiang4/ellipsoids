function [approxMat, approxVec, discrepVec,vertMat] = calcPolytopeApprox(inEqPolyMat, eqPolyMat,...
                          inEqPolyVec, eqPolyVec, indProjVec, improveDirectVec,  nPropExpected, properties)

% CALCPOLYTOPEAPPROX- builds the approximation of given polytope'projection on fixed nProjElems axis
% 
% Input:
%   regular:
%       inEqPolyMat: double [nInequalities, nDims] 
%       inEqPolyVec: double [nInequalities, 1] 
%           inEqPolyMat and inEqPolyVec   determine inequalities from the polytope's definition:
%                        inEqPolyMat*x<=inEqPolyVec
% 
%        eqPolyMat: double [nEqualities, nDims] 
%        eqPolyVec: double [nEqualities, 1] 
%            eqPolyMat and eqPolyVec determine  equalities from the polytope's definition:
%                        eqPolyMat*x=eqPolyVec
% 
%        indProjVec:double [1, nProjElems] - indieces of projection variables, that define the axis, on which  the polytope  will be projected               
%        improveDirectVec: double [1, nProjElems] - the direction of improvement of projection variables:  nonzero value indicates that for corresponding projection variable Pareto shell will be built in specified direction
%              for each variable : 1 -  increase, -1 - reduction, 0 - no improvement%
%   optional:
%         nPropExpected: double[1,1] - an expected number of properties
%    properties:
%         approxPrec: double[1,1] - desirable precision of approximation, when the precision is reached, the process will be completed; by default approxPrec = 1e-3  
%         freeMemoryMode: double[1,1] - determines if mode of freeing memory after attaching of each vertex is on (1) or off (0 - by default)
%         discardIneqMode: double[1,1] - determines if mode of combinatory discarding  nonessential inequalities is on (1 - by default) or off (0)
%         faceDist: double[1,1] - is used to determine on which side from the face the attached point is, if the distance from the point to the hyperplane of the face is less then faceDist then it is considered that the point is on the face; by default faceDist = 9e-5
%         inApproxDist: double[1,1] - is used in the process of approximation; if  the point found as a result of calculating  the support function lies inside the current approximation at the distance more than inApproxDist, then the process is interrupted with a message "the vertex is inside the multiplicity" ; by default inApproxDist = 1e-4  
%         ApproxDist: double[1,1] - is used in the process of approximation; if  the point found as a result of calculating  the support function lies at the distance less than ApproxDist from the internal approximation then it is not expectant to be attached and so it isn't kept on memory;by default ApproxDist  = 1e-5
%         relPrec: double[1,1] - is used in the process of calculating  the dot product; if when finding the sum of two values, the result isn't more than the result of multiplying of one of the values and relPrec, then the sum is defined as 0;by default relPrec = 1e-5
%         inftyDef: double[1,1] - is used as infinity; by default IinftyDef = 1e6
%         isVerbose:double[1,1] - determins if the mode of printing the process information is on (1) or off (0 - be default)
%               NOTE: EPSdif must be less than faceDist and precTest!
%         
%  Output:
%         approxMat: double [nResInequalities,nProjElems] ,
%         approxVec: double [nResInequalities,1] 
%         the result is defined as a multiplicity of x such that:  
%                                           approxMat*x +  approxVec <= 0                                               
%         
%          discrepVec: double [1,nResInequalities] -  vector of approximation
%          error for  each vertex of result polytope
%          vertMat: double [nVertices, nProjElems] - vertices of result polytope