function B = outerApprox(U)
%
%  OUTERAPPROX: Computes outer bounding box for the union of polyhedra 
%  ====================================================================
%  
%  
%  SYNTAX
%  ------
%     
%      B = outerApprox(U)
%      B = U.outerApprox
%    
%  
%  DESCRIPTION
%  -----------
%     Compute the smallest axis-aligned hypercube that contains all polyhedra in
%  this union. The lower and upper bounds of the hypercube are stored under
%  Internal property, i.e. Internal.lb for lower bound and Internal.ub for upper
%  bound.
%  
%  INPUT
%  -----
%     
%        
%          U Union of polyhedra in the same dimension 
%                                                     
%            Class: PolyUnion                         
%              
%  
%  
%  OUTPUT
%  ------
%     
%        
%          B Bounding box B  described as Polyhedron  
%            in H-representation.                     
%            Class: Polyhedron                        
%              
%  
%  
%  SEE ALSO
%  --------
%     convexHull
%  

%  AUTHOR(s)
%  ---------
%     
%    
%   (c) 2003-2013  Michal Kvasnica: STU Bratislava
%   mailto:michal.kvasnica@stuba.sk 
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
if numel(U)>1
    B(size(U)) = Polyhedron;
    parfor i=1:numel(U)
        B(i) = U(i).outerApprox;
    end
    return;
end

% if there is 0 sets contained, return empty polyhedron
if U.Num<1
    B = Polyhedron;
    return
end


% single bounding box for arrays
BP = U.Set.outerApprox;
d = U.Dim;
lb = Inf(d, 1);
ub = -Inf(d, 1);
for i = 1:length(BP)
    lb = min(lb, BP(i).Internal.lb);
    ub = max(ub, BP(i).Internal.ub);
end

Hbox = [eye(d) ub; -eye(d) -lb];

% get rid of inf terms for constructing bounding box
zh = isinf([ub; lb]);
Hbox(zh,:) = [];

B = Polyhedron(Hbox(:, 1:end-1), Hbox(:, end));

% store internally
B.setInternal('lb',lb);
B.setInternal('ub',ub);


end
