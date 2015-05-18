function [M,F] = TrStifCal_v1_2(nodes,dmat,heat)

%% TrStifCal Evaluates the stiffness matrix for a triangular element
%
%  Parameters:
%
%    Input, nodes : Contains the 2D coordinates of the nodes
%           dmat  : Constitutive matrix
%           heat  : Heat per area unit
%
%    Output, M the element local stiffness matrix
%            F the element local force vector

  b(1) = nodes(2,2) - nodes(3,2);
  b(2) = nodes(3,2) - nodes(1,2);  
  b(3) = nodes(1,2) - nodes(2,2);

  c(1) = nodes(3,1) - nodes(2,1);
  c(2) = nodes(1,1) - nodes(3,1);
  c(3) = nodes(2,1) - nodes(1,1);

  area2 = abs(b(1)*c(2) - b(2)*c(1));
  area  = area2 / 2;

  bmat = [b(1),b(2),b(3) ;
          c(1),c(2),c(3)];

  bmat = bmat / area2;

  M = (transpose(bmat)*dmat*bmat)*area;

  force = area*heat/3;

  F = [ force, force, force];

