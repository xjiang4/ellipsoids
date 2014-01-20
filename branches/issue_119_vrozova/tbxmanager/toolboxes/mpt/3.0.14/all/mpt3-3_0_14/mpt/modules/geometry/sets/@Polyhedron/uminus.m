function Q = uminus(P)
%
%  UMINUS: Unitary minus for a polyhedron. 
%  ========================================
%  
%  
%  SYNTAX
%  ------
%     
%      Q = -P;
%    
%  
%  DESCRIPTION
%  -----------
%     Revert H- and V- representation of the polyhedron.
%  
%  INPUT
%  -----
%     
%        
%          P Polyhedron object.                       
%            Class: Polyhedron                        
%              
%  
%  
%  SEE ALSO
%  --------
%     umplus
%  

%  AUTHOR(s)
%  ---------
%     
%    
%   (c) 2010-2013  Colin Neil Jones: EPF Lausanne
%   mailto:colin.jones@epfl.ch 
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
 
 
Q(size(P)) = Polyhedron;

% revert A, Ae and Vertices
parfor i=1:length(P)
    Q(i) = Polyhedron('H',[-P(i).A P(i).b],'He',[-P(i).Ae P(i).be],'V',-P(i).V,'R',-P(i).R);    
end


end
