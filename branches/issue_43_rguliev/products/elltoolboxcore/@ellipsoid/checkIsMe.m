function checkIsMe(ellArr,varargin)

if nargin == 1
    modgen.common.checkvar(ellArr,@(x) isa(x,'ellipsoid'));
else
    modgen.common.checkvar(ellArr,@(x) isa(x,'ellipsoid'),varargin{:});
end