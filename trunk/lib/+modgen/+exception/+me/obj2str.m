function [message,stacktrace]=obj2str(err,varargin)
% OBJ2STR returns string representations of an MException object
%
% input:
%   regular:
%     err: MException [1,1]
%   properties:
%     useHyperlink: logical [1,1] - print hyperlinks suitable for Matlab
%       screen output. Default = true.
%     prefixStr: char [1,n] - prefix to put at the beginning of each line
%       of the stack trace. Default = ''.
% output:
%   regular:
%     message: char [1,n] - error message
%     stacktrace: char [m,n] - string representation of the stack trace
%
% $Author: Peter Gagarinov, Moscow State University by M.V. Lomonosov,
% Faculty of Applied Mathematics and Cybernetics, System Analysis
% Department, 12-October-2012, <pgagarinov@gmail.com>$


stacktrace = modgen.exception.me.printstack(err.stack,varargin{:});
[message, stacktrace] = modgen.exception.me.parsemessage(err.message, stacktrace);
stacktrace = sprintf('%s\n', stacktrace);
nCause=length(err.cause);
for iCause=1:nCause
    [messageCause,stacktraceCause]=modgen.exception.me.obj2str(err.cause{iCause},varargin{:});
    message=[message,sprintf('\n\tCause(%d): %s',iCause,messageCause)];
    stacktrace=[stacktrace,sprintf('\tCause(%d): %s',iCause,stacktraceCause)];
end