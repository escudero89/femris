function [M,F] = QdStif_v1_3(nodes,dmat,thick,denss)

%% QdStif Evaluates the stiffness matrix for a quadrilateral element
%
%  Parameters:
%
%    Input, nodes : Contains the 2D coordinates of the element nodes
%           dmat  : Constitutive matrix
%           thick : Thickness
%           denss : Density
%    
%    Output, M the element local stiffness matrix
%            F the element local force vector

  fform = @(s,t)[(1-s-t+s*t)/4,(1+s-t-s*t)/4,(1+s+t+s*t)/4,(1-s+t-s*t)/4];
  deriv = @(s,t)[(-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4;
                 (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4];

  pospg = [ -0.577350269189626E+00 ,  0.577350269189626E+00 ];
  pespg = [  1.0E+00 ,  1.0E+00 ];
  M = zeros(8,8);
  fy = zeros(1,4);
  
  for i = 1 : 2
    for j = 1 : 2
      lcffm = fform(pospg(i),pospg(j));            % SF at Gauss point
      lcder = deriv(pospg(i),pospg(j));            % SF Local derivatives
      xjacm = lcder*nodes;                         % Jacobian matrix
      ctder = xjacm\lcder;                         % SF Cartesian derivates
      darea = det(xjacm)*pespg(i)*pespg(j)*thick;
      
      bmat = [];
      for inode = 1 : 4
        bmat = [ bmat , [ctder(1,inode),            0 ;
                                     0 ,ctder(2,inode);
                         ctder(2,inode),ctder(1,inode)] ];
      end

      M = M + (transpose(bmat)*dmat*bmat)*darea;
      
      fy = fy + lcffm*denss*darea;
      
      % FEMRIS ADDITION >>>>>>>
      global femris_elemental_matrix;
      femris_elemental_matrix{12}(:,:,end + 1) = lcffm;
      femris_elemental_matrix{13}(:,:,end + 1) = lcder;
      femris_elemental_matrix{14}(:,:,end + 1) = xjacm;
      femris_elemental_matrix{15}(:,:,end + 1) = ctder;
      femris_elemental_matrix{16}(:,:,end + 1) = darea;
      femris_elemental_matrix{17}(:,:,end + 1) = bmat;
      % <<< END FEMRIS ADDITION

    end
  end
  
  F = [ 0,-fy(1), 0,-fy(2), 0,-fy(3), 0,-fy(4)];

  % FEMRIS ADDITION >>>>>>>
  global femris_elemental_matrix;
  femris_elemental_matrix{10}(:,:,end + 1) = M;
  femris_elemental_matrix{11}(:,:,end + 1) = transpose(F);
  % <<< END FEMRIS ADDITION