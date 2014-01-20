function R = mpt_call_gurobi(S)
%
%  MPT_CALL_GUROBI: A gateway function to GUROBI solver (without errorchecks) 
%  ===========================================================================
%  
%  
%  SYNTAX
%  ------
%     
%      R = mpt_call_gurobi(S)
%    
%  
%  DESCRIPTION
%  -----------
%     The function implements call to GUROBI solver based on formulation from Opt
%  class. QP, LP, MILP and MIQP problems are supported. It is assumed that
%  QP/LP/MIQP/MILP entering this function (for LP/MILP H=0) is of the form 
%                                   1  T    T                      
%                             min   - x Hx+f x                 (1) 
%                                   2                              
%                            s.t.   lb <= x <= ub              (2) 
%                                   Ax <= b                    (3) 
%                                                                  
%                                   A x = b                    (4) 
%                                    e     e                       
%                                   x in {C, I, B, N, S }      (5) 
%     where the set {C, I, B, N, S}  represents 
%    
%     - C - continuous variables, x in (-oo,oo)   
%     - I - integer variables x in (..., -1, 0, 1, ...)   
%     - B - binary variables x in {0,1}  
%     - N - semi-integer variables (possibly bounded above)  x in [0, 1, x <= oo ) 
%     
%     - S - semi-continuous variables (possibly bounded above)  x in [0, x <= oo)  
%    which is given by strings in vartype field. GUROBI accepts this format
%  directly, the only prerequisite is to transform input data to sparse format.
%  
%  INPUT
%  -----
%     
%        
%          S              Structure of the Opt class.              
%                         Class: struct                            
%          S.H            Quadratic part of the objective          
%                         function.                                
%                         Class: double                            
%                         Default: []                              
%          S.f            Linear part of the objective function.   
%                         Class: double                            
%          S.A            Linear part of the inequality            
%                         constraints Ax <= b.                     
%                         Class: double                            
%          S.b            Right hand side of the inequality        
%                         constraints Ax <= b.                     
%                         Class: double                            
%          S.Ae           Linear part of the equality constraints  
%                         A_ex=b_e.                                
%                         Class: double                            
%                         Default: []                              
%          S.be           Right hand side of the equality          
%                         constraints A_ex=b_e.                    
%                         Class: double                            
%                         Default: []                              
%          S.lb           Lower bound for the variables x >= lb.   
%                         Class: double                            
%                         Default: []                              
%          S.ub           Upper bound for the variables x <= ub.   
%                         Class: double                            
%                         Default: []                              
%          S.n            Problem dimension (number of variables). 
%                                                                  
%                         Class: double                            
%          S.m            Number of inequalities in Ax <= b.       
%                         Class: double                            
%          S.me           Number of equalities in A_ex=b_e         
%                         Class: double                            
%          S.problem_type A string specifying the problem to be    
%                         solved.                                  
%                         Class: char                              
%          S.vartype      A string specifying the type of          
%                         variable. Supported characters are C     
%                         (continuous), I (integer), B (binary), N 
%                         (semi-integer), S (semi-continuous).     
%                         Example: First variable from three is    
%                         binary, the rest is continuous:          
%                         S.vartype='BCC';                         
%                         Class: char                              
%          S.test         Call (false) or not to call (true) MPT   
%                         global settings.                         
%                         Class: logical                           
%                         Default: false                           
%                           
%  
%  
%  OUTPUT
%  ------
%     
%        
%          R          result structure                         
%                     Class: struct                            
%          R.xopt     optimal solution                         
%                     Class: double                            
%          R.obj      Optimal objective value.                 
%                     Class: double                            
%          R.lambda   Lagrangian multipliers.                  
%                     Class: double                            
%          R.exitflag An integer value that informs if the     
%                     result was feasible (1), or otherwise    
%                     (different from 1).                      
%                     Class: double                            
%          R.how      A string that informs if the result was  
%                     feasible ('ok'), or if any problem       
%                     appeared through optimization.           
%                     Class: char                              
%                       
%  
%  
%  SEE ALSO
%  --------
%     mpt_solve
%  

%  AUTHOR(s)
%  ---------
%     
%    
%   (c) 2010-2013  Martin Herceg: ETH Zurich
%   mailto:herceg@control.ee.ethz.ch 
%  
%  

%  LICENSE
%  -------
%    
%    This program is free software; you can redistribute it and/or modify it under
%  the terms of the GNU General Public License as published by the Free Software
%  Foundation; either version 2.1 of the License, or (at your option) any later
%  version.
%    This program is distributed in the hope that it will be useful, but WITHOUT
%  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
%  FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%    You should have received a copy of the GNU General Public License along with
%  this library; if not, write to the  Free Software Foundation, Inc.,  59 Temple
%  Place, Suite 330,  Boston, MA 02111-1307 USA
 
 
global MPTOPTIONS
if isempty(MPTOPTIONS) && ~S.test
    MPTOPTIONS = mptopt;
end

if strcmpi(S.problem_type,'LCP')
    error('mpt_call_lcp: GUROBI solver does not solve %s problems!',S.problem_type);
end

% if ~ispc
%     % before calling GUROBI, we need to check out whether the path to shared
%     % libraries contains the directory with "libgurobi.so"
%     d = which('libgurobi.so');
%     id = findstr(d,filesep);
%     dn = d(1:id(end)-1);
%     if isunix && ~ismac
%         p = getenv('LD_LIBRARY_PATH');
%         % path is not set
%         if isempty(strfind(p,dn))
%             % append to the path variable
%             setenv('LD_LIBRARY_PATH',[p,':',dn]);
%         end
%     elseif ismac
%         p = getenv('DYLD_LIBRARY_PATH');
%         % path is not set
%         if isempty(strfind(p,dn))
%             % append to the path variable
%             setenv('DYLD_LIBRARY_PATH',[p,':',dn]);
%         end
%     else
%         p = getenv('PATH');
%         % path is not set
%         if isempty(strfind(p,dn))
%             % append to the path variable
%             setenv('PATH',[p,';',dn]);
%         end
%     end
% end
% 
% % adjust size of A, B to have at least one row if it's empty
% if (S.m+S.me)==0
%     S.A = sparse([1 zeros(1,S.n-1)]);
%     S.b = 1e12;
%     S.m = 1;
% end


% merge constraints, must be in sparse format
A = sparse([S.Ae; S.A]);
b = full([S.be; S.b]);
% constraint types, accepts "<", ">", "=" chars
ctypes = char(['='*ones(S.me,1); '<'*ones(S.m,1)]);


% merge lb/ub with inequality constraints
% detect Inf boundaries
if S.test
    ilb = (S.lb==-Inf) | (S.lb<=-1e6);
    iub = (S.ub==Inf)  | (S.ub>=1e6);
else
    ilb = (S.lb==-Inf) | (S.lb<=-MPTOPTIONS.infbound);
    iub = (S.ub==Inf)  | (S.ub>=MPTOPTIONS.infbound);
end
% store kept rows
kept_rows.lb = find(~ilb);
kept_rows.ub = find(~iub);
if any(~ilb)
    % put ones at the positions where there is lb/ub
    Alb = zeros(nnz(~ilb),S.n);
    Alb(:,~ilb) = -speye(nnz(~ilb));
    A = [A; Alb];
    b = [b; -S.lb(~ilb)];
    ctypes = [ctypes; '<'*ones(nnz(~ilb),1) ];
end
if any(~iub)
    Aub = zeros(nnz(~iub),S.n);
    Aub(:,~iub) = speye(nnz(~iub));
    A = [A; Aub];
    b = [b; S.ub(~iub)];
    ctypes = [ctypes; '<'*ones(nnz(~iub),1) ]; 
end

% option description can be found:
%   http://www.gurobi.com/doc/20/refman/node378.html
%
if ~S.test
    opts = MPTOPTIONS.modules.solvers.gurobi;
else
    opts.IterationLimit = 1e3;
    opts.FeasibilityTol = 1e-6;
    opts.IntFeasTol = 1e-5;
    opts.OptimalityTol = 1e-6;
    opts.Method = 1;         % 0=primal simplex, 1=dual simplex, 2=barrier, 3=concurrent, 4=deterministic concurrentx
    opts.Presolve = -1;        % -1 - auto, 0 - no, 1 - conserv, 2 - aggressive
    % complete silence
    opts.OutputFlag= 0;
end

% % for MAC we need to load shared libraries into memory and the simplest way
% % to do this without needing root privileges is to change the directory
% if ismac
%     current_dir = pwd;
%     cd(dn);
% end

% put arguments to a struct
model.A = A;
model.rhs = b;
model.sense = ctypes;
model.lb = -Inf(S.n,1);
model.ub = Inf(S.n,1);
if ~isempty(S.vartype)
    model.vtype = S.vartype;
end
model.obj = S.f;

if any(strcmpi(S.problem_type,{'QP','MIQP'}))
    model.Q = sparse(S.H*0.5);
end

% do LP and MILP first (do not require quadratic terms in opts)
if any(strcmpi(S.problem_type,{'LP','QP'}))
    %[R.xopt,R.obj,flag,output,lambda] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);    
    result = gurobi(model,opts);
    if isfield(result,'pi')
        lam = -result.pi;
    else
        lam = NaN(size(A,1),1);
    end
elseif any(strcmpi(S.problem_type,{'MILP','MIQP'}))
    % GUROBI gives no lambda (Pi) for MIPs.
    %[R.xopt,R.obj,flag,output] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);
    result = gurobi(model,opts);
    lam = NaN(size(A,1),1);
end
if isfield(result,'x')
    R.xopt = result.x;
else
    % in case no output is returned, make zero output to at least match the
    % dimension
    R.xopt = S.x0;
end
if isfield(result,'objval')
    R.obj = result.objval;
else
    R.obj = 0;
end


% % QP, MIQP
% if any(strcmpi(S.problem_type,{'QP','MIQP'}))
%     % extract row, column and value information from a sparse matrix
%     [qrow, qcol, qval] = find(S.H);
%     opts.QP.qval = 0.5*qval';
%     %MH: gurobi_mex does not detect the platform correctly, must supply 32bit int anyway
%     %     if any(strcmp(computer,{'PCWIN','GLNX86','MACI'}))
%     opts.QP.qrow = int32(qrow'-1);
%     opts.QP.qcol = int32(qcol'-1);
%     %      elseif any(strcmp(computer,{'PCWIN64','GLNXA64','MACI64'}))
%     %          opts.QP.qcol = int64(qcol'-1);
%     %          opts.QP.qrow = int64(qrow'-1);
%     %      end
% end
% 
% if strcmpi(S.problem_type,'QP')
%     [R.xopt,R.obj,flag,output,lambda] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);
%     lam = -lambda.Pi;
% elseif strcmpi(S.problem_type,'MIQP')
%     % no lambda for MIP
%     [R.xopt,R.obj,flag,output] = gurobi_mex(S.f, 1, A, b, ctypes, lb, ub, S.vartype, opts);
%     lam = NaN(size(A,1),1);
% end

% assign Lagrange multipliers
if isempty(lam)
   R.lambda.ineqlin = [];
   R.lambda.eqlin = [];
   R.lambda.lower = [];
   R.lambda.upper = [];
else
    R.lambda.ineqlin = lam(S.me+1:S.me+S.m);
    R.lambda.eqlin = lam(1:S.me);    
    if ~isempty(S.lb)
        R.lambda.lower = zeros(S.n,1);
        R.lambda.lower(kept_rows.lb) = lam(S.me+S.m+1:S.me+S.m+numel(kept_rows.lb));
    else
        R.lambda.lower = zeros(S.n,1);
    end
    if ~isempty(S.ub) && isempty(S.lb)
        R.lambda.upper = zeros(S.n,1);
        R.lambda.upper(kept_rows.ub) = lam(S.me+S.m+1:S.me+S.m+numel(kept_rows.ub));
    elseif ~isempty(S.ub) && ~isempty(S.lb)
        R.lambda.upper = zeros(S.n,1);
        R.lambda.upper(kept_rows.ub) = lam(S.me+S.m+numel(kept_rows.lb)+1:S.me+S.m+numel(kept_rows.lb)+numel(kept_rows.ub));
    else
        R.lambda.upper = zeros(S.n,1);
    end    
end

% % change back the directory
% if ismac
%     cd(current_dir)
% end

% % recalculate the objective function for QP, MIQP
% if ~isempty(R.xopt) && any(strcmpi(S.problem_type,{'QP','MIQP'}))
%     R.obj = 0.5*R.xopt'*S.H*R.xopt + S.f'*R.xopt;
% end

switch result.status
    case 'LOADED'
        R.how = 'not started';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'OPTIMAL'
        R.how = 'ok';
        if S.test
            R.exitflag = 1;
        else
            R.exitflag = MPTOPTIONS.OK;
        end
    case 'INFEASIBLE'
        R.how = 'infeasible';
        if S.test
            R.exitflag = 2;
        else
            R.exitflag = MPTOPTIONS.INFEASIBLE;
        end
    case 'INF_OR_UNBD'
        R.how = 'infeasible or unbounded';
		
		% according to the docs we should switch off presolve:
		% http://www.gurobi.com/documentation/4.6/example-tour/node77
		opts.Presolve = 0; % 0 = off
		result = gurobi(model, opts);
		switch result.status,
			case {'OPTIMAL', 'UNBOUNDED'}
				if S.test
					R.exitflag = 3;
				else
					R.exitflag = MPTOPTIONS.UNBOUNDED;
				end
				R.how = 'unbounded';
				
				% do not forget to update the optimizer
				if isfield(result, 'x')
					R.xopt = result.x;
				end
				if isfield(result, 'objval')
					R.obj = result.objval;
				end
			otherwise
				if S.test
					R.exitflag = 2;
				else
					R.exitflag = MPTOPTIONS.INFEASIBLE;
				end
				R.how = 'infeasible';
		end
    case 'UNBOUNDED'
        R.how = 'unbounded';
        if S.test
            R.exitflag = 3;
        else
            R.exitflag = MPTOPTIONS.UNBOUNDED;
        end
    case 'CUTOFF'
        R.how = 'objective worse than specified cutoff';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'ITERATION_LIMIT'
        R.how = 'reaching iteration limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'NODE_LIMIT'
        R.how = 'reaching node limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'TIME_LIMIT'
        R.how = 'reaching time limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'SOLUTION_LIMIT'
        R.how = 'reaching solution limit';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'INTERRUPTED'
        R.how = 'user interruption';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'NUMERIC'
        R.how = 'numerical difficulties';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    case 'SUBOPTIMAL'
        R.how = 'suboptimal solution';
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
    otherwise
        R.how = result.status;
        if S.test
            R.exitflag = -1;
        else
            R.exitflag = MPTOPTIONS.ERROR;
        end
end

end
