function error_string = yalmiperror(errorcode,solver)
%YALMIPERROR Creates YALMIP error message based on error code
%
%   s = YALMIPERROR(ID) gives a textual description of an error
%   code generated by YALMIP (typically in SOLVESDP)
%
%   The complete set of error codes are
%
%    -7 Solver does not return error codes
%    -6 Search space not bounded (bound all variables)
%    -5 License problems in solver
%    -4 Solver not applicable
%    -3 Solver not found
%    -2 Successfully solved
%    -1 Unknown error
%     0 Successfully solved
%     1 Infeasible problem
%     2 Unbounded objective function
%     3 Maximum #iterations or time-limit exceeded
%     4 Numerical problems
%     5 Lack of progress
%     6 Initial solution infeasible
%     7 YALMIP sent incorrect input to solver
%     8 Feasibility cannot be determined
%     9 Unknown problem in solver
%    10 bigM failed (obsolete)  
%    11 Other identified error
%    12 Infeasible or unbounded
%    13 YALMIP cannot determine status in solver
%    14 Convexity check failed.
%    15 Problem either infeasible or unbounded
%    16 User terminated
%
%   See also SOLVESDP

% Author Johan L�fberg 
% $Id: yalmiperror.m,v 1.8 2007-10-03 09:25:56 joloef Exp $

if nargin ==0
    help yalmiperror
    return
end

if nargin==1
    solver = '';
else
    solver = ['(' solver ')'];
end

switch errorcode
case -7
  error_string = ['Solver does not return error codes ' solver];
case -6
  error_string = ['Search space not bounded ' solver];
case -5 
  error_string = ['License problems in solver ' solver];
 case -4
  error_string = ['Solver not applicable ' solver];    
case -3
  error_string = 'Solver not found';
 case -2
  error_string = 'No suitable solver';
 case -1
  error_string = 'Unknown error';
 case 0
  error_string = ['Successfully solved ' solver ];
 case 1
  error_string = ['Infeasible problem ' solver ];
 case 2
  error_string = ['Unbounded objective function ' solver ];
 case 3
  error_string = ['Maximum iterations or time limit exceeded ' solver ];
 case 4
  error_string = ['Numerical problems ' solver ];
 case 5
  error_string = ['Lack of progress ' solver ];
 case 6
  error_string = ['Initial solution infeasible ' solver ];
 case 7
  error_string = ['YALMIP called solver with incorrect input ' solver ];
 case 8
  error_string = ['Feasibility cannot be determined ' solver ];	
 case 9
  error_string = ['Unknown problem in solver (try using ''debug''-flag in sdpsettings) ' solver ];
 case 10
  error_string = ['bigM failed, increase sp.Mfactor ' solver ];
 case 11
  error_string = ['Other identified error ' solver ]; 
 case 12
  error_string = ['Either infeasible or unbounded ' solver ]; 
 case 13
  error_string = ['YALMIP cannot determine status in solver ' solver ]; 
 case 14
  error_string = ['Convexity check failed ' solver ]; 
 case 15
  error_string = ['Infeasible or unbounded problem ' solver ]; 
  
  
 otherwise
end

	