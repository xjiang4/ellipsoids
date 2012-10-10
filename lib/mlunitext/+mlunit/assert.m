function assert(expr, msg, isInternalCall)
% ASSERT checks whether the expr is true or not and throws an error if not.
%
% Input:
%   regular:
%       expr: logical[1,1] - logical expression to calculate
%   optional:
%       msg: char[1,] - message to display in case of error
%       isInternalCall: logical[1,1] - indicates whether the call is
%           internal. The parameter is used to trim the top
%           entries of the stack trace, e.g. for user-defined
%           assert methods (see the code of assert_equals for an example).
%
% Example: assert(a == b);
%   The assertion will fail, if a is not equal to b.
%   In addition, a message can be specified:
%
% Example: assert(a == b, 'a is not equal to b.');
%   The message is only used, if the assertion fails.
%
%
% $Author: Peter Gagarinov, Moscow State University by M.V. Lomonosov,
% Faculty of Applied Mathematics and Cybernetics, System Analysis
% Department, 7-October-2012, <pgagarinov@gmail.com>$
%
import modgen.common.throwerror;
if (nargin == 1)
    msg = 'no message.';
    isInternalCall = false;
end;
if (nargin == 2)
    isInternalCall = false;
end;
if ((isempty(expr)) || (~expr))
    stack = dbstack('-completenames');
    stacktrace = '';
    for i = 2 + isInternalCall:size(stack, 1)
        stacktrace = sprintf('%s\n  In %s at line %d', ...
            stacktrace, ...
            stack(i).file, stack(i).line);
    end;
    stacktrace = sprintf('%s\n', stacktrace);
    throwerror(['MLUNIT FAILURE:Traceback (most recent call first): ', ...
        stacktrace, ...
        'AssertionError: ', ...
        msg]);
end;
