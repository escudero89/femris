function S = TrStrs_v1_3(nodes,dmat,displ,poiss,thick,pstrs)

%% TrStrs Evaluates the stresses for a triangular element
%
%  Parameters:
%
%    Input, nodes : Contains the 2D coordinates of the element nodes
%           dmat  : Constitutive matrix
%           displ : Nodal displacement
%           poiss : Poisson ratio
%           thick : Thickness
%           pstrs : Flag for Plane Stress
%   
%    Output, S the element constant stress vector

  b(1) = nodes(2,2) - nodes(3,2);
  b(2) = nodes(3,2) - nodes(1,2);  
  b(3) = nodes(1,2) - nodes(2,2);

  c(1) = nodes(3,1) - nodes(2,1);
  c(2) = nodes(1,1) - nodes(3,1);
  c(3) = nodes(2,1) - nodes(1,1);

  area2 = abs(b(1)*c(2) - b(2)*c(1));
  area = area2 / 2;

  bmat = [b(1),  0 ,b(2),  0 ,b(3),  0 ;
            0 ,c(1),  0 ,c(2),  0 ,c(3);
          c(1),b(1),c(2),b(2),c(3),b(3)];

  se = (dmat*bmat*displ)/area2;

% Plane Stress
  if (pstrs == 1)
    S = se ;
% Plane Strain
  else                
    S = [se(1),se(2),-poiss*(se(1)+se(2)),se(3)];
  end
 
