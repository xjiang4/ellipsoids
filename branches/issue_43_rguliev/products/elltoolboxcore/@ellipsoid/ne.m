function [isNeqArr, reportStr] = ne(ellFirstArr, ellSecArr)
%
%
% Description:
% ------------
%
%    The opposite of EQ.
%

%
% Author:
% -------
%
%    Alex Kurzhanskiy <akurzhan@eecs.berkeley.edu>
%

[isEqualArr, reportStr] = eq(ellFirstArr, ellSecArr);
isNeqArr = ~isEqualArr;