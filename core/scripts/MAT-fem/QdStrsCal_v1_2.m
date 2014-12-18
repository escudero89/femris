function S = QdStrsCal_v1_2(nodes,dmat,displ)

%% QdStrsCal Evaluates the fluxes for a quadrilateral element
%
%  Parameters:
%
%    Input, nodes : Contains the 2D coordinates of the nodes
%           dmat  : Constitutive matrix
%           displ : Nodal temperatures
%   
%    Output, S the element constant flux vector
%

  fform = @(s,t)[(1-s-t+s*t)/4,(1+s-t-s*t)/4,(1+s+t+s*t)/4,(1-s+t-s*t)/4];
  deriv = @(s,t)[(-1+t)/4,( 1-t)/4,( 1+t)/4,(-1-t)/4;
                 (-1+s)/4,(-1-s)/4,( 1+s)/4,( 1-s)/4];

  pospg = [ -0.577350269189626E+00 ,  0.577350269189626E+00 ];
  pespg = [  1.0E+00 ,  1.0E+00 ];

  strsg = [];
  extrap = [];
  order = [ 1 , 4 ; 2 , 3 ];    % Align the G-pts. with the element corners
  
  for i = 1 : 2
    for j = 1 : 2
      lcder = deriv(pospg(i),pospg(j));            % SF Local derivatives
      xjacm = lcder*nodes;                         % Jacobian matrix
      ctder = xjacm\lcder;                         % SF Cartesian derivates
      
      bmat = [];
      for inode = 1 : 4
        bmat = [ bmat , [ctder(1,inode);
                         ctder(2,inode)] ];
      end
      
      strsg(:,order(i,j)) = (dmat*bmat*displ) ;
      
      a = 1/pospg(i);
      b = 1/pospg(j);

      extrap(order(i,j),:) = fform(a,b);
    end
  end

  se = transpose(extrap*transpose(strsg));

  S = se;

