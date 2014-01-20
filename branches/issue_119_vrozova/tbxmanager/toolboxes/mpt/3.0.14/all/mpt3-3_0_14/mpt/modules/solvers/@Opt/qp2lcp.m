function S = qp2lcp(S,reduce_flag)
%
%  ELIMINATEEQUATIONS: Transforms LP/QP/MPLP/MPQP to LPC/PLCP 
%  ===========================================================
%  
%  
%  SYNTAX
%  ------
%     
%      problem.qp2lcp
%      qp2lcp(problem)
%    
%  
%  DESCRIPTION
%  -----------
%     Transformation of LP, QP, MPLP, and MPQP to LCP/PLCP formulation. Consider
%  the following MPQP format that is accepted by Opt class: 
%                                   1  T             T              
%                             min   - x Hx+(Ftheta+f) x         (1) 
%                                   2                               
%                            s.t.   Ax <= b + Btheta            (2) 
%                                                                   
%                                   A x = b  + Etheta           (3) 
%                                    e     e                        
%                                                                   
%                                   A     theta = b             (4) 
%                                    theta         theta            
%                                                               (5) 
%     which contains minequality constrains and m_e  equality constraints and
%  constraints on the parameter theta. If there are lower and upper bounds on the
%  variables x  present, i.e. lb and ub, these can be merged to inequalities (2).
%  This format is not appropriate for transformation to LCP form because it
%  contains equality constraints and the inequalities are not nonnegative. To get
%  appropriate LCP representation, the equality constrains of the problem (1)-(4) 
%  are removed using eliminateEquations method of the Opt class. The intermediate
%  form of the optimization problem is given as 
%                               1    T                 T               
%                         min   - x   Hx  +(Ftheta + f) x          (6) 
%                               2  Nc   Nc               Nc            
%                                                                      
%                        s.t.   Ax   <= b + Btheta                 (7) 
%                                 Nc                                   
%                                                                      
%                               A     theta = b                    (8) 
%                                theta         theta                   
%                                                                  (9) 
%     with x_Nc  as the non-basic variables that map to x  affinely. Problem
%  (6)-(7)  can be transformed effectively when considering the rank of the matrix
%  A. If the rank of matrix A  is less than the number of inequalities in (7), then
%  vector x_N  can be expressed as a difference of two positive numbers, i.e. 
%                                            +      -           
%                                x    =   x    - x         (10) 
%                                 Nc       Nc     Nc            
%                                  +                            
%                               x     >=  0                (11) 
%                                Nc                             
%                                  -                            
%                               x     >=  0                (12) 
%                                Nc                             
%     Using the substitution 
%                                    (    +  )        
%                                    ( x     )        
%                                    (  Nc   )        
%                                v = (    -  )    (13)
%                                    ( x     )        
%                                    (  Nc   )        
%     and putting back to (6)-(7)  we get 
%                     1  T (        )    ((       )      (       ))T              
%               min   - v  ( H  -H  )v + (( F -F  )theta ( f -f  ))  v       (14) 
%                     2    ( -H H   )    ((       )      (       ))               
%                     (       )                                                   
%              s.t.   ( -A A  )v >= -b -Btheta                               (15) 
%                     (       )                                                   
%                     v >= 0                                                 (16) 
%     which is a form suitable for PLCP formulation. If the rank of matrix A  is
%  greater or equal than the number of inequalities in (7), we can factorize the
%  matrix A  rowwise 
%                                        (     )
%                                        ( A   )
%                                        (  B  )
%                                    A = (     )
%                                        ( A   )
%                                        (  N  )
%    where B, N  are index sets corresponding to rows from which submatrices are
%  built. The factored system can be written as 
%                                        -b                       
%                              -A x  =       -Btheta + y     (17) 
%                                B         B                      
%                                        -b                       
%                              -A x >=       -Btheta         (18) 
%                                N         N                      
%                                 y  >=  0                   (19) 
%     where the matrix A_B  form by rows in the set B  must be invertible. Using
%  this substitution the system (6)(8)  can be rewritten in variable y 
%                                 1  T                 T              
%                           min   - y  H y + (Ftheta+f)  y       (20) 
%                                 2                                   
%                          s.t.   A >= b + Btheta                (21) 
%                                 y >= 0                         (22) 
%     which is suitable for PLCP formulation where 
%                                     -T   -1                      
%                             H  =  A   HA                    (23) 
%                                    B    B                        
%                                     A -T   -1      -T            
%                             F  =  -(    HA   B  -A   F      (24) 
%                                      B    B   B   B              
%                                      -T   -1     -T              
%                             f  =  -A   HA   b -A   f        (25) 
%                                     B    B   B  B                
%                                       -1                         
%                             A  =  A A                       (26) 
%                                    N B                           
%                                       -1                         
%                             b  =  A A   b -b                (27) 
%                                    N B   B  N                    
%                                       -1                         
%                             B  =  A A   B -b  -B            (28) 
%                                    N B   B  N   N                
%     The corresponding PLCP can be written as follows: 
%                               w - Mz  =   q + Qtheta      (29) 
%                                    w  >=  0               (30) 
%                                    z  >=  0               (31) 
%                                   T                            
%                                  w z  =   0               (32) 
%                                                                
%     where the problem data are built from MPQP (20)-(22) 
%                                        (     T  )          
%                                        ( H -A   )          
%                                  M  =  (        )     (33) 
%                                        ( A  0   )          
%                                        (     )             
%                                  q  =  ( f   )        (34) 
%                                        ( -b  )             
%                                        (     )             
%                                  Q  =  ( F   )        (35) 
%                                        ( -B  )             
%     Original solution to MPQP problem (1)-(3)  can be obtained by affine map from
%  the variables w(theta)  and z(theta)  to x. The matrices of the backward map are
%  stored inside recover property of the Opt class as follows 
%                                  (    )     (        )
%                            x = uX( w  )+ uTh( theta  )
%                                  ( z  )     (   1    )
%     If the problem was formulated using YALMIP, it is possible that some
%  variables are in the different order. The original order of variables is stored
%  in problem.varOrder.requested_variables and the map to original variables is
%  given by 
%                                  (    )          (        )
%                       x = primalX( w  )+ primalTh( theta  )
%                                  ( z  )          (   1    )
%  
%  
%  INPUT
%  -----
%     
%        
%          problem LP/QP/MPLP/MPQP optimization problem     
%                  given as Opt class.                      
%                  Class: Opt                               
%                    
%  
%  
%  SEE ALSO
%  --------
%     solve,  mpt_call_lcp
%  

%  AUTHOR(s)
%  ---------
%     
%    
%   (c) 2010-2013  Colin Neil Jones: EPF Lausanne
%   mailto:colin.jones@epfl.ch 
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

if isempty(MPTOPTIONS)
    MPTOPTIONS = mptopt;
end

% if no arguments, do redundancy elimination automatically
if nargin<=1
    reduce_flag = true;
else
    % check input argument if provided
    validate_logicalscalar(reduce_flag);
end

% deal with arrays
if numel(S)>1
    parfor i=1:numel(S)
        S(i).qp2lcp(reduce_flag);
    end
    return
end

% for LCP do nothing
if strcmpi(S.problem_type,'LCP')
    return;
end

% store the original objective function
S.Internal.H = S.H;
S.Internal.pF = S.pF;
S.Internal.f = S.f;
S.Internal.Y = S.Y;
S.Internal.C = S.C;
S.Internal.c = S.c;

% store the original constraints (used in Opt/feasibleSet)
S.Internal.constraints.A = S.A;
S.Internal.constraints.b = S.b;
S.Internal.constraints.pB = S.pB;
S.Internal.constraints.Ae = S.Ae;
S.Internal.constraints.be = S.be;
S.Internal.constraints.pE = S.pE;

if reduce_flag
%     % Remove redundancies to reduce the problem size if possible
%     Hp = [-S.pB S.A S.b;
%         S.Ath zeros(length(S.bth),S.n) S.bth;    
%         zeros(S.n,S.d) eye(S.n) S.ub;
%         zeros(S.n,S.d) -eye(S.n) -S.lb];
%     % remove Inf bounds if any
%     Hp(isinf(Hp(:,end)),:)=[];
% 
%     P = Polyhedron('H',Hp);
%     if isEmptySet(P),
%         error('Opt:qp2lcp', 'Feasible set is empty.');
%     end
%     hull = P.minHRep();
%     pB = -hull.H(:,1:S.d);
%     A = hull.H(:,S.d+1:S.n+S.d);
%     b  =  hull.H(:,end);

    % take internally stored values
    if S.isParametric       
        % the redundancy elimination was done by validation, take the
        % internal values
        pB = S.Internal.pB;
        A = S.Internal.A;
        b = S.Internal.b;
    else
        % perform the elimination, don't throw error if empty
        P = Polyhedron('A',S.Internal.A,'b',S.Internal.b,'Ae',S.Ae,'be',S.be);
        [P, hull] = P.minHRep();
        A = P.A;
        b = P.b;
        pB = S.Internal.pB;

        % update internal values
        S.Internal.A = A;
        S.Internal.b = b;
        
        % indices of constraints to be extracted
        ie = 1:S.Internal.m-numel(S.Internal.removed_rows.ineqlin);
        ilb = S.Internal.m-numel(S.Internal.removed_rows.ineqlin)+1:S.Internal.m-numel(S.Internal.removed_rows.ineqlin)+S.Internal.n-numel(S.Internal.removed_rows.lower);
        iub = S.Internal.m-numel(S.Internal.removed_rows.ineqlin)+S.Internal.n-numel(S.Internal.removed_rows.lower)+1:...
            S.Internal.m-numel(S.Internal.removed_rows.ineqlin)+S.Internal.n-numel(S.Internal.removed_rows.lower)+S.Internal.n-numel(S.Internal.removed_rows.upper);
        % store removed rows
        S.Internal.removed_rows.ineqlin = [S.Internal.removed_rows.ineqlin; find(hull.I(ie))];
        S.Internal.removed_rows.lower = [S.Internal.removed_rows.lower; find(hull.I(ilb))];
        S.Internal.removed_rows.upper = [S.Internal.removed_rows.upper; find(hull.I(iub))];
        
    end
    
else
    % take merged constraints 
    A = S.Internal.A;
    b = S.Internal.b;
    pB = S.Internal.pB;
end

% put all constraints to A, b, pB
S.A = A;
S.b = b;
S.pB = pB;
S.lb = [];
S.ub = [];
S.m = size(A,1);

% Remove equality constraints
equations = false;
if S.me > 0
    equations = true;
    
    % extract variables for recovering multipliers
    Ae = S.Ae;
    Am = A;
    if isempty(S.H)
        Hm = zeros(S.n);
    else
        Hm = S.H;
    end
    fm = S.f;    
    Fm = S.pF;
    
    % eliminate equations
    S.eliminateEquations;
    
    % If there are any equations left, then the parameter set is not full-dim
    if S.me > 0
        error('qp2lcp: Parameter space is not full-dimensional.'); 
    end
end


% Convert the problem to the standard form:
% min 0.5 u'*H*u + (F*th + f)'*u
% s.t. A*u <= b + B*th

if isempty(S.H)
    H = zeros(S.n);
else
    H = S.H;
end


% get the rank
r = rank(S.A,MPTOPTIONS.abs_tol);

if r<S.n    
    % express x as a difference of two positive numbers, i.e. x = x+ - x-
    
    % new objective function
    Hnew = [H -H; -H H];    
    fnew = [S.f; -S.f];
    pFnew = [S.pF; -S.pF];
    
    % new constraints Anew*y >= bnew
    Anew = [-S.A S.A];
    bnew = -S.b;
    pBnew = -pB;
    
    % create M,q for LCP
    M = [Hnew -Anew'; Anew zeros(size(Anew,1))];
    q = [fnew; -bnew];
    if S.isParametric
        Q = [pFnew; -pBnew];
    else
        Q=[];
    end

               
    % Build mapping from the lcp solution back to the original variables
    % x = z(1:n) - z(n+1:2*n)
    %     
    % x = [0 I -I]*[w] + [0]*[th]
    %              [z]       [1 ]
    % u = uX * [w;z] + uTh * [th;1]
    nd = size(M,1);
    recover.uX = zeros(S.n,2*nd);
    recover.uX(:,nd+1:nd+S.n) = eye(S.n);
    recover.uX(:,nd+S.n+1:nd+2*S.n) = -eye(S.n);
    recover.uTh = zeros(S.n,S.d+1);    

    % Lagrange multipliers are:
    % lambda_ineq = z(2*n+1:end);
    % lambda_ineq = z(2*n+1:end) + [0]*[th;1]
    % lambda_ineq = lambdaX * [w;z] + lambdaTh *[th;1];
    
    lambdaX = zeros(size(S.A,1),2*nd);
    lambdaX(:,nd+2*S.n+1:2*nd) = eye(size(S.A,1),nd-2*S.n);
    lambdaTh = zeros(size(S.A,1),S.d+1);

    
    % multipliers for the original inequalities
    kept_rows.ineq = setdiff(1:S.Internal.m,S.Internal.removed_rows.ineqlin);    
    recover.lambda.ineqlin.lambdaX = zeros(S.Internal.m,2*nd);
    recover.lambda.ineqlin.lambdaX(kept_rows.ineq,nd+2*S.n+1:nd+2*S.n+S.Internal.m) = eye(numel(kept_rows.ineq));
    recover.lambda.ineqlin.lambdaTh = zeros(S.Internal.m,S.d+1);
    
    % multipliers for the original lower bound
    kept_rows.lb = setdiff(1:S.Internal.n,S.Internal.removed_rows.lower);    
    recover.lambda.lower.lambdaX = zeros(S.Internal.n,2*nd);        
    recover.lambda.lower.lambdaX(kept_rows.lb,nd+2*S.n+S.Internal.m+1:nd+2*S.n+S.Internal.m+numel(kept_rows.lb)) = eye(numel(kept_rows.lb));
    recover.lambda.lower.lambdaTh = zeros(S.Internal.n,S.d+1);

    % multipliers for the original upper bound
    kept_rows.ub = setdiff(1:S.n,S.Internal.removed_rows.upper);
    recover.lambda.upper.lambdaX = zeros(S.Internal.n,2*nd);        
    recover.lambda.upper.lambdaX(kept_rows.ub,nd+2*S.n+S.Internal.m+numel(kept_rows.lb)+1:...
        nd+2*S.n+S.Internal.m+numel(kept_rows.lb)+numel(kept_rows.ub)) = eye(numel(kept_rows.ub));
    recover.lambda.upper.lambdaTh = zeros(S.Internal.n,S.d+1);

    
%     recover.lambdaX = zeros(S.m,2*nd);
%     recover.lambdaX(:,2*S.n+1:2*S.n+S.m) = eye(S.m);
%     recover.lambdaTh = zeros(S.m,S.d+1); 

    
%     % A'*lam = -H*x -[F f]*[th;1]
%     % A'*lam = -H*(uX*[w;z]+uTh*[th;1])-[F f]*[th;1]
%     % lam =  (-A'\H*uX)*[w;z] -A'\(H*uTh-[F f])*[th;1]
%     
%     recover.lambdaX = -S.A'\H*recover.uX;
%     recover.lambdaTh = -S.A'\(H*recover.uTh+[S.pF S.f]);

else
           
    % factorize A to get
    %  -A(B,:)*x = -b(B) -pB*th + y  % must be invertible mapping
    %  -A(N,:)*x >= -b(N) -pB*th
    %          y >= 0
    [L,U,p] = lu(sparse(-S.A),'vector');
    B = p(1:S.n);
    N = setdiff(1:size(S.A,1),B);
    
    % substitute
    % use factorized solution to compute inv(A(B,:))
    iAbl = -linsolve(full(L(1:S.n,:)),eye(S.n),struct('LT',true));
    iAb = linsolve(full(U),iAbl,struct('UT',true));
    %iAb = inv(A(B,:));
    bb = S.b(B);
    An = S.A(N,:);
    bn = S.b(N);
    if S.isParametric
        pBb = S.pB(B,:);
        pBn = S.pB(N,:);
    end
    
    % form new objective function
    Hnew = iAb'*H*iAb;
    fnew = -Hnew*bb - iAb'*S.f;
    if S.isParametric
        pFnew = -iAb'*H*iAb*pBb - iAb'*S.pF;
    end
    
    % new constraints Anew* y>= bnew
    Anew = An*iAb;
    if isempty(bn)
        bnew = [];
    else
        bnew = Anew*bb - bn;
    end
    if S.isParametric
        pBnew = Anew*pBb - pBn;
    end
    
    % create M,q for LCP
    M = [Hnew -Anew'; Anew zeros(size(Anew,1))];
    q = [fnew; -bnew];
    if S.isParametric
        Q = [pFnew; -pBnew];
    else
        Q=[];
    end
    
    
    % Build mapping from the lcp solution back to the original variables
    % x = iAb*bb + iAb*pBb*th -iAb*y
    %     
    % x = [0 -iAb]*[w] + [iAb*pBb iAb*bb]*[th]
    %              [z]                    [1 ]
    % u = uX * [w;z] + uTh * [th;1]
    recover.uX = [zeros(r,size(M,1))  -iAb  zeros(r,size(M,1)-r)];
   
    if S.isParametric
        recover.uTh    = [iAb*pBb iAb*bb];
    else
        recover.uTh    = iAb*bb;
    end
    %  lambda_B = w(1:n)
    %  lambda_N = z(n+1:end);
    %  lambda = lambdaX * [w;z] + lambdaTh * [th;1]

    % A'*lam = -H*x -[F f]*[th;1]
    % A'*lam = -H*(uX*[w;z]+uTh*[th;1])-[F f]*[th;1]
    % lam =  (-A'\H*uX)*[w;z] -A'\(H*uTh-[F f])*[th;1]

    nd = size(M,1);       
    lambdaX = zeros(size(S.A,1),2*nd);
    lambdaX(B,1:S.n) = eye(length(B),S.n);
    lambdaX(N,nd+S.n+1:2*nd) = eye(length(N),nd-S.n);
    lambdaTh = zeros(size(S.A,1),S.d+1); 

    % multipliers for the original inequalities    
    kept_rows.ineq = setdiff(1:S.Internal.m,S.Internal.removed_rows.ineqlin);    
    recover.lambda.ineqlin.lambdaX = zeros(S.Internal.m,2*nd);
    recover.lambda.ineqlin.lambdaX(kept_rows.ineq,:) = lambdaX(1:numel(kept_rows.ineq),:);
    recover.lambda.ineqlin.lambdaTh = zeros(S.Internal.m,S.d+1);
    
    % multipliers for the original lower bound
    kept_rows.lb = setdiff(1:S.Internal.n,S.Internal.removed_rows.lower);    
    recover.lambda.lower.lambdaX = zeros(S.Internal.n,2*nd);        
    recover.lambda.lower.lambdaX(kept_rows.lb,:) = ...
        lambdaX(numel(kept_rows.ineq)+1:numel(kept_rows.ineq)+length(kept_rows.lb),:);
    recover.lambda.lower.lambdaTh = zeros(S.Internal.n,S.d+1);

    % multipliers for the original upper bound
    kept_rows.ub = setdiff(1:S.Internal.n,S.Internal.removed_rows.upper);
    recover.lambda.upper.lambdaX = zeros(S.Internal.n,2*nd);        
    recover.lambda.upper.lambdaX(kept_rows.ub,:) = ...
        lambdaX(numel(kept_rows.ineq)+length(kept_rows.lb)+1:numel(kept_rows.ineq)+length(kept_rows.lb)+length(kept_rows.ub),:);
    recover.lambda.upper.lambdaTh = zeros(S.Internal.n,S.d+1);

        
           
end

if equations
    % Map from inequalities to equalities
    % u = uX * x + uTh * [th;1]
    % origU = recover.Y * u + recover.th * [th;1]
    % origU = recover.Y * [uX * x + uTh * [th;1]] + recover.th * [th;1]
    % origU = (recover.Y * uX) * x + (recover.Y * uTh + recover.th) * [th;1]
    recover.uX  = S.recover.Y*recover.uX;
    recover.uTh = S.recover.th + S.recover.Y*recover.uTh;
    
    % Lagrange multipliers for equalities
    % ni = -Ae'\H*x  -Ae'\A'*lam -Ae'\[F f]*[th; 1]
    % ni = -Ae'\H*(uX*[w;z]+uTh) -Ae'\'*(uLam*[w;z]+uTh)-Ae'\[F f]*[th;1]
    % ni = [(-Ae'\H)*Ux-(Ae'\A')*uLam]*[w;z] + 
    %      [(-Ae'\H)*uTh -(Ae'\A')*lamTh -(Ae'\[F f])]*[th; 1]

    AeH = -Ae'\Hm;
    AeA = -Ae'\Am';
    
    niX = AeH*recover.uX + AeA*lambdaX;
    if S.isParametric
        niTh = AeH*recover.uTh + AeA*lambdaTh -Ae'\[Fm fm];
    else
        niTh = AeH*recover.uTh + AeA*lambdaTh -Ae'\fm;
    end
    
    % lagrange multipliers for the original system
    kept_rows.eq = setdiff(1:S.Internal.me,S.Internal.removed_rows.eqlin);
    recover.lambda.eqlin.lambdaX = zeros(S.Internal.me,2*nd);
    recover.lambda.eqlin.lambdaX(kept_rows.eq,:) = niX;
    recover.lambda.eqlin.lambdaTh = zeros(S.Internal.me,S.d+1);
    recover.lambda.eqlin.lambdaTh(kept_rows.eq,:) = niTh;
    
    
%     recover.lambdaX = [recover.lambdaX; niX];
%     recover.lambdaTh = [recover.lambdaTh; niTh];
else
    recover.lambda.eqlin.lambdaX = zeros(0,2*nd);
    recover.lambda.eqlin.lambdaTh = zeros(0,S.d+1);
end

% reorder variables is this came from Yalmip
if ~isempty(S.varOrder)
     Px = speye(size(recover.uX,1));
     Px = Px(S.varOrder.requested_variables,:);
     recover.primalX = Px*recover.uX;
     recover.primalTh= Px*recover.uTh;
end


% clear unnecessary fields
S.A  = []; S.b  = []; S.pB = [];
S.Ae = []; S.be = []; S.pE = [];
S.H  = []; S.f  = []; S.pF = [];
S.Y  = []; S.C  = []; S.c  = [];
S.lb = []; S.ub = [];

S.n  = size(M,1); % Problem dimension
S.m  = 0; % Number of inequalities
S.me = 0; % Number of equality constraints
% Number of parameters
if ~isempty(Q)
    S.d = size(Q,2);
else
    S.d  = 0; 
end
S.solver = '';
S.problem_type = ''; 
S.isParametric = [];

% set up LCP
S.M = M;
S.q = q;
if ~isempty(Q)
    S.Q = Q;
end
S.recover = recover;

% validate data
S.validate;

end
