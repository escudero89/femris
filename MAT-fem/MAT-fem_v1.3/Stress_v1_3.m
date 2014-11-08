function S = Stress_v1_3(dmat,poiss,thick,pstrs,u)

%% Stress Evaluates the stresses at the Gauss points and smooth the values
%         to the nodes
%
%  Parameters:
%
%    Input, dmat  : Constitutive matrix
%           poiss : Poisson ratio
%           thick : Thickness
%           pstrs : Flag for Plane Stress
%           u     : Nodal displacements
%   
%    Output, S the nodal stress matrix (nnode, nstrs)

  global coordinates;
  global elements;

% Find basic dimensions
  nelem = size(elements,1);            % Number of elements
  nnode = size(elements,2);            % Number of nodes per element
  npnod = size(coordinates,1);         % Number of nodes

  if (pstrs == 1)
    nstrs = 3;                         % Number of Strs. Sx Sy Txy
  else
    nstrs = 4;                         % Number of Strs. Sx Sy Sz Txy
  end

  nodstr = zeros(npnod,nstrs+1);
  
% Element cycle
  for ielem = 1 : nelem
      
% Recover element properties
    lnods = elements(ielem,:);
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:);
    eqnum = [];
    for i = 1 : nnode
      eqnum = [eqnum,lnods(i)*2-1,lnods(i)*2];
    end
    displ = u(eqnum);
    
% Stresses inside the elements
% Triangular element constant stress
    if (nnode == 3)
      ElemStr = TrStrs_v1_3(coord,dmat,displ,poiss,thick,pstrs);

      for j = 1 : nstrs
        nodstr(lnods,j) = nodstr(lnods,j) + ElemStr(j);
      end
      nodstr(lnods,nstrs+1) = nodstr(lnods,nstrs+1) + 1;

% Quadrilateral element stress at nodes
    else 
      ElemStr = QdStrs_v1_3(coord,dmat,displ,poiss,thick,pstrs);

      for j = 1 : 4
        for i = 1 : nstrs
          nodstr(lnods(j),i) = nodstr(lnods(j),i) + ElemStr(i,j);
        end
      end
      nodstr(lnods,nstrs+1) = nodstr(lnods,nstrs+1) + 1;
      
    end
    
  end  % End element cycle
  
% Find the mean stress value
  S = [];
  for i = 1 : npnod
    S = [S ; nodstr(i,1:nstrs)/nodstr(i,nstrs+1)];
  end
 
