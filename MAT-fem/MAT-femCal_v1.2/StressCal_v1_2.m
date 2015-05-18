function S = StressCal_v1_2(dmat,u)

%% StressCal Evaluates the fluxes at the Gauss points and smooth the values
%            to the nodes
%
%  Parameters:
%
%    Input, dmat : Constitutive matrix
%           u    : Nodal temperatures
%   
%    Output, S the nodal flux matrix (nnode,nstrs)

  global coordinates;
  global elements;
 
% Find basic dimensions
  nelem = size(elements,1);            % Number of elements
  nnode = size(elements,2);            % Number of nodes per element
  npnod = size(coordinates,1);         % Number of nodes
  nstrs = 2;                           % Number of heat fluxes
 
  nodstr = zeros(npnod,nstrs+1);
  
% Element cycle
  for ielem = 1 : nelem
      
% Recover element properties
    lnods = elements(ielem,:);
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:);
    eqnum = [];
    for i =1 : nnode
      eqnum = [eqnum,lnods(i)];
    end
    displ = u(eqnum);
    
% Fluxes inside the elements
% Triangular elements constant flux
    if (nnode == 3)
      ElemStr = TrStrsCal_v1_2(coord,dmat,displ);
      for j = 1 : nstrs
        nodstr(lnods,j) = nodstr(lnods,j) + ElemStr(j);
      end
      nodstr(lnods,nstrs+1) = nodstr(lnods,nstrs+1) + 1;

% Quadrilateral elements flux at nodes
    else
      ElemStr = QdStrsCal_v1_2(coord,dmat,displ);
      for j = 1 : 4
        for i = 1 : nstrs
          nodstr(lnods(j),i) = nodstr(lnods(j),i) + ElemStr(i,j);
        end
      end
      nodstr(lnods,nstrs+1) = nodstr(lnods,nstrs+1) + 1;
    end
    
  end  % End element cycle
  
% Find the mean flux value
  S = [];
  for i = 1 : npnod
    S = [ S ; nodstr(i,1:nstrs)/nodstr(i,nstrs+1) ];
  end
 
