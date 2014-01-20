function S = eliminateEquations(S)
%
%  ELIMINATEEQUATIONS: Reduce LP/QP/MPLP/MPQP by removing equality constraints 
%  ============================================================================
%  
%  
%  SYNTAX
%  ------
%     
%      problem.eliminateEquations
%      eliminateEquations(problem)
%    
%  
%  DESCRIPTION
%  -----------
%     Remove equality constraints involved in LP, QP, MPLP, and MPQP of the
%  dimension n  to get optimization problem in the dimension n-m_e  where m_e 
%  stands for the number of equalities. Consider the following MPQP 
%                                   1  T             T             
%                             min   - x Hx+(Ftheta+f) x        (1) 
%                                   2                              
%                            s.t.   Ax <= b + Btheta           (2) 
%                                                                  
%                                   A x = b  + Etheta          (3) 
%                                    e     e                       
%     which contains minequality constrains and m_e  equality constraints. To be
%  able to reduce the optimization problem to a simpler form, it is required that
%  the system of linear equations A_ex=b_e+Etheta  is consistent, i.e. no linearly
%  dependent rows are found and the number of equalities m_e  is strictly less than
%  number of variables n, i.e.  m_e<n . The principle is based on factorizing
%  equality constraints A_ex=b_e+Etheta  in basic  x_Bc and non-basic variables
%  x_Nc, i.e. 
%                                    (              )
%                               A  = ( A     A      )
%                                e   (  e,Bc  e,Nc  )
%    which gives 
%                                                           
%                         A    x   + A    x   = b  + Etheta 
%                          e,Bc Bc    e,Nc Nc    e          
%     where the index sets Bc, Nc denote the columns from which factored system is
%  built. The factored submatrix A_e,Bc  must be invertible in order to express
%  basic variables as a function of non-basic variables, i.e. 
%                            -1                -1          -1       
%                x   = -A      A    x   + A      b  + A      Etheta 
%                 Bc     e,Bc   e,Nc Nc    e,Bc   e    e,Bc         
%     Using the substitution 
%                                           -1      
%                                 C = -A      A     
%                                       e,Bc   e,Nc 
%     and 
%                                            -1    
%                                  D  = A      b   
%                                   1    e,Bc   e  
%                                             -1   
%                                   D  = A      E  
%                                    2    e,Bc     
%     the relation between basic and non-basic variables is simplified to 
%                                                           
%                         x   = Cx   + D  + D theta      (4)
%                          Bc     Nc    1    2              
%     The above MPQP problem (1)-(3)can be expressed only in non-basic variables
%  x_Nc  as follows: 
%                               1    T                 T               
%                         min   - x   Hx  +(Ftheta + f) x          (5) 
%                               2  Nc   Nc               Nc            
%                                                                      
%                        s.t.   Ax   <= b + Btheta                 (6) 
%                                 Nc                                   
%     where 
%                    T           T                                                 
%                                                
%             H  =  C H     C + C H      + H     C + H                             
%                                            (7) 
%                      Bc,Bc       Bc,Nc    Nc,Bc     Nc,Nc                        
%                                                
%                        T            T      T           T                  T      
%                                                
%             F  =  0.5(C H     D  + C H      D  + H      D  + H     D ) + C F   +
%                                   F         (8) 
%                          Bc,Bc 2      Bc,Bc  2    Bc,Nc  2    Nc,Bc 2       Bc   
%                                   Nc           
%                        T            T      T           T                  T      
%                                                
%             f  =  0.5(C H     D  + C H      D  + H      D  + H     D ) + C f   +
%                                   f         (9) 
%                          Bc,Bc 1      Bc,Bc  1    Bc,Nc  1    Nc,Bc 1       Bc   
%                                   Nc           
%                                                                                  
%                                                
%             A  =  A  C+A                                                         
%                                           (10) 
%                    Bc   Nc                                                       
%                                                
%                                                                                  
%                                                
%             b  =  b - A  D                                                       
%                                           (11) 
%                        Bc 1                                                      
%                                                
%                                                                                  
%                                                
%             B  =  B - A  D                                                       
%                                           (12) 
%                        Bc 2                                                      
%                                                
%     Original solution to LP/QP problem (1)-(3)  can be obtained via relation (4).
%  The matrices of the backward map are stored inside recover property of the Opt
%  class as follows 
%                                            (        )
%                             x   = Yx   + th( theta  )
%                              Bc     Nc     (   1    )
%     where the matrix Y corresponds to C  and the matrix th to D  in (4). Note the
%  the reduced problem (5)-(6)  has different cost function as the original
%  problem.
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
%     solve
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

% deal with arrays
if numel(S)>1
    parfor i=1:numel(S)
        S(i).eliminateEquations;
    end
    return
end

if ~strcmpi(S.problem_type,{'FEAS','LP','QP'})
    error('No equality removal for %s type of problems.',S.problem_type);
end


% for no equalities, return the same structure
if (S.me==0)
    disp('Problem does not contain equality constraints.');
    return;
end


% % remove -Inf/Inf from bounds
% if all(isinf(S.ub))
%     S.ub = [];
% else
%     S.ub(isinf(S.ub))=MPTOPTIONS.infbound;
% end
% if all(isinf(S.lb))
%     S.lb = [];
% else
%     S.lb(isinf(S.lb))=-MPTOPTIONS.infbound;
% end

% take merged inequality constraints
A = S.Internal.A;
b = S.Internal.b;
pB = S.Internal.pB;

% check rank of equality constraints
re = rank(full([S.Ae -S.pE S.be]));

% for underdetermined system check linearly dependent rows
me = S.me;
Ae = S.Ae;
be = S.be;
pE = S.pE;
kept_rows = 1:me;
if re<me
    while me ~= re
        % find linearly dependent rows Ae*x - pE*th = be
        [~,~,p] = lu(sparse([Ae -pE be]),'vector');
        rd = p(re+1:end);
        
        % remove linearly dependent rows
        Ae(rd,:) = [];
        be(rd) = [];
        if S.isParametric
            pE(rd,:) = [];
        end
        me = me-length(rd);
        kept_rows(rd) = [];
        
        re = rank(full([Ae -pE be]));
    end
end
S.Internal.removed_rows.eqlin = setdiff(1:me,kept_rows);

% check rank of Ae
if rank(Ae,MPTOPTIONS.abs_tol)==0
    error('Rank of equality constraint matrix "Ae" is equal zero, you cannot remove equalities.');
end

% factorize Ae to get an invertible mapping
%  Ae(Br,Bc)*x(Bc) + Ae(Br,Nc)*x(Nc) = be(Br) + pE(Br,:)*th
[Le,Ue,pe,qe] = lu(sparse(Ae),'vector');
if rank(full(Ue(:,1:re)))~=re
    % if invertibility is not achieved, we need to factorize differently
    % try full factorization but we with different combination of
    % variables
    for i=1:S.n-re
        [Le,Ue,pe] = lu(sparse(Ae(:,i:re+i-1)),'vector');
        qe = 1:S.n;
        if rank(full(Ue(:,1:re)))~=re
            continue
        else
            break;
        end
    end
    if rank(full(Ue(:,1:re)))~=re
        error('EliminateEquations: Could not find invertible submatrix for removing equalities.');
    end
end
Br = pe(1:re); Bc = qe(1:re);
Nr = pe(re+1:end); Nc = qe(re+1:end);
if rank(Ae(Nr,:),MPTOPTIONS.abs_tol)~=0
    error('EliminateEquations: Matrix of equality constraints is row-dependent and there are no equality constraints on the parameter.');
end

% substitute x(Bc) = C*x(Nc) + D1 + D2*th
Aebn = Ae(Br,Nc);
%iAebb = inv(S.Ae(Br,Bc));
beb = be(Br);
if S.isParametric
    pEb = pE(Br,:);
end

% use factorized solution to compute C
% C = -S.Ae(Br,Bc)\Aebn;
Cl = -linsolve(full(Le(1:re,:)),Aebn,struct('LT',true));
C = linsolve(full(Ue(:,1:re)),Cl,struct('UT',true));

% use factorized solution to compute D1
% D1 = S.Ae(Br,Bc)\beb;
Dl1 = linsolve(full(Le(1:re,:)),beb,struct('LT',true));
D1 = linsolve(full(Ue(:,1:re)),Dl1,struct('UT',true));

if S.isParametric
    % use factorized solution to compute D2
    % D2 = S.Ae(Br,Bc)\pE(Br,:);
    Dl2 = linsolve(full(Le(1:re,:)),pEb,struct('LT',true));
    D2 = linsolve(full(Ue(:,1:re)),Dl2,struct('UT',true));
end

% simplify substutition
Abc = A(:,Bc); Anc = A(:,Nc);

% modify inequality constraints
S.A = Abc*C + Anc;
S.b = b - Abc*D1;
S.Internal.A = S.A; % update merged constraints stored internally
S.Internal.b = S.b; % update merged constraints stored internally
if S.isParametric
    S.pB = pB - Abc*D2;
    S.Internal.pB = S.pB; % update merged constraints stored internally
end

% modify cost
if isempty(S.H)
    f = C'*S.f(Bc) + S.f(Nc,:);
    c = S.f(Bc)'*D1 + S.c;
    if S.isParametric
        pF = C'*S.pF(Bc,:) + S.pF(Nc,:);
        Y = S.pF(Bc,:)'*D2 + S.Y;
        Cx = S.f(Bc)'*D2 + S.C;
    end
else
    H = S.H(Nc,Nc) + C'*S.H(Bc,Bc)*C + C'*S.H(Bc,Nc) + S.H(Nc,Bc)*C;
    % make sure H is symmetric due numerical problems
    H = 0.5*(H'+H);
    f = 0.5*(C'*S.H(Bc,Bc)*D1 + C'*S.H(Bc,Bc)'*D1 + S.H(Bc,Nc)'*D1 + S.H(Nc,Bc)*D1) + C'*S.f(Bc) + S.f(Nc,:);
    c = 0.5*D1'*S.H(Bc,Bc)*D1 + S.f(Bc)'*D1 + S.c;
    if S.isParametric
        pF = 0.5*(C'*S.H(Bc,Bc)*D2 + C'*S.H(Bc,Bc)'*D2 + S.H(Bc,Nc)'*D2 + S.H(Nc,Bc)*D2) + C'*S.pF(Bc,:) + S.pF(Nc,:);
        Y = 0.5*D2'*S.H(Bc,Bc)*D2 + S.pF(Bc,:)'*D2 + S.Y;
        Cx = S.f(Bc)'*D2 + S.C;
    end
    S.H = H;
end

S.f = f;
S.c = c;
if S.isParametric
    S.pF = pF;
    S.Y = Y;
    S.C = Cx;
end

% xB = C*xN + D1 + D2*th;
% xB = C*xN + [D2 D1]*[th;1]

% Compute map from new variables back to old
% x = recover.Y*y + recover.th*[th;1]
%  [xb]   [C]       [D2 D1]*[th]
%  [xn] = [I]*[xn] +[0   0] [1 ]
S.recover.Y(Nc,:) = eye(S.n-re);
S.recover.Y(Bc,:) = C;
S.recover.th = zeros(S.n,S.d+1);
if S.isParametric
    S.recover.th(Bc,:) = [D2 D1];
else
    S.recover.th(Bc,:) = D1;
end

% modify dimensions
S.n = S.n-re;
S.me=length(Nr);
S.m=size(S.A,1);

% remaining equality constraints on the parameter
% 0 = be + pE*th
S.Ae = Ae;
S.be = be;
S.Ae(Br,:) = [];
S.be(Br,:) = [];
if S.isParametric
    S.pE(Br,:) = [];
end

% correct empty matrices with proper dimensions
if isempty(S.Ae)
    S.Ae = zeros(S.me,S.n);
    S.pE = zeros(S.me,S.d);
end

% type of variables must reflect the change in number of optimization
% variables

% TODO: support binary variables
S.vartype = repmat('C', 1, S.n);

% put Inf terms in lb/ub back
% S.lb = -Inf(S.n,1);
% S.ub = Inf(S.n,1);
if ~isempty(S.lb)
    S.lb(Bc) = [];
end
if ~isempty(S.ub)
    S.ub(Bc) = [];
end

end
