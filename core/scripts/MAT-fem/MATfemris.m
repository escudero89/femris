%% MAT-femris (without clear nor load from input file)
%

  file_name = '../../temp/currentMatFemFile';
  tic;                   % Start clock
  ttim = 0;              % Initialize time counter
  
% The variables are read as a MAT-fem subroutine
% pstrs = 1 indicate Plane Stress; 0 indicate Plane Strain
% young =   Young Modulus
% poiss =   Poission Ratio
% thick =   Thickness only valid for Plane Stress
% denss =   Density
% coordinates = [ x , y ] coordinate matrix nnode x ndime (2)
% elements    = [ inode , jnode , knode ] element connectivity  matrix
%               nelem x nnode; nnode = 3 for triangular elements and 
%               nnode = 4 for quadrilateral elements
% fixnodes    = [ node number , dimension , fixed value ] matrix with 
%               Dirichlet restrictions
% pointload   = [ node number , dimension , load value ] matrix with 
%               nodal loads
% sideload    = [ node number i , node number j , x load , y load ]
%               matrix with line definition and uniform load
%               applied in x and y directions

  tic;                   % Start clock
  ttim = 0;              % Initialize time counter

% Find basic dimensions
  npnod = size(coordinates,1);         % Number of nodes
  nndof = 2*npnod;                     % Number of total DOF
  nelem = size(elements,1);            % Number of elements
  nnode = size(elements,2);            % Number of nodes per element
  neleq = nnode*2;                     % Number of DOF per element

  elements = sortrows(elements);

  ttim = timing('Time needed to read the input file',ttim); %Reporting time

% Dimension the global matrices
  StifMat  = sparse( nndof , nndof );  % Create the global stiffness matrix
  force    = sparse( nndof , 1 );      % Create the global force vector
  force1   = sparse( nndof , 1 );      % Create the global force vector
  reaction = sparse( nndof , 1 );      % Create the global reaction vector
  u        = sparse( nndof , 1 );      % Nodal variables
  
% Material properties (Constant over the domain)
  dmat = constt(young,poiss,pstrs);

  ttim = timing('Time needed to  set initial values',ttim); %Reporting time

% Element cycle
  for ielem = 1 : nelem

% Recover element properties
    lnods = elements(ielem,:);                         % Elem. connectivity
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:);  % Elem. coordinates
 
% Evaluate the elemental stiffness matrix and mass force vector
    if (nnode == 3)   % 3 Nds. Triangle
      [ElemMat,ElemFor] = TrStif_v1_3(coord,dmat ,thick,denss);
    else              % 4 Nds. Quadrilateral
      [ElemMat,ElemFor] = QdStif_v1_3(coord,dmat ,thick,denss);
    end
    
% Find the equation number list for the i-th element
    eqnum = [];                                        % Clear the list
    for i = 1 : nnode                                  % Node cycle
      eqnum = [eqnum,lnods(i)*2-1,lnods(i)*2];         % Build the equation 
    end                                                % number list

% Assemble the force vector and the stiffness matrix
    for i = 1 : neleq
      force(eqnum(i)) = force(eqnum(i)) + ElemFor(i);
      for j = 1 : neleq
         StifMat(eqnum(i),eqnum(j)) = StifMat(eqnum(i),eqnum(j)) + ...
                                      ElemMat(i,j);
      end
    end

  end  % End element cycle

  ttim = timing('Time to assemble the global system',ttim); %Reporting time

% Add side forces to the force vector
  for i = 1 : size(sideload,1)
    x = coordinates(sideload(i,1),:) - coordinates(sideload(i,2),:);
    l = sqrt(x*transpose(x));          % Find the length of the side
    ieqn = sideload(i,1)*2;            % Find eq. number for the first node
    force(ieqn-1) = force(ieqn-1) + l*sideload(i,3)/2;        % Add x force 
    force(ieqn  ) = force(ieqn  ) + l*sideload(i,4)/2;        % Add y force

    ieqn = sideload(i,2)*2;           % Find eq. number for the second node
    force(ieqn-1) = force(ieqn-1) + l*sideload(i,3)/2;        % Add x force 
    force(ieqn  ) = force(ieqn  ) + l*sideload(i,4)/2;        % Add y force
  end

% Add point load conditions to the force vector
  for i = 1 : size(pointload,1)
    ieqn = (pointload(i,1)-1)*2 + pointload(i,2);       % Find eq. number
    force(ieqn) = force(ieqn) + pointload(i,3);         % and add the force
  end

  ttim = timing('Time for apply side and point load',ttim); %Reporting time

% Apply the Dirichlet conditions and adjust the right hand side
  for i = 1 : size(fixnodes,1)
    ieqn = (fixnodes(i,1)-1)*2 + fixnodes(i,2);  % Find the equation number
    u(ieqn) = fixnodes(i,3);                  % and store the solution in u
    fix(i) = ieqn;                        % and mark the eq. as a fix value
  end
  
  force1 = force - StifMat * u;      % Adjust the rhs with the known values

% Compute the solution by solving StifMat * u = force for the remaining
% unknown values of u
  FreeNodes = setdiff( 1:nndof , fix );           % Find the free node list
                                                  % and solve for it
  u(FreeNodes) = StifMat(FreeNodes,FreeNodes) \ force1(FreeNodes);

% Compute the reactions on the fixed nodes as R = StifMat * u - F
  reaction(fix) = StifMat(fix,1:nndof) * u(1:nndof) - force(fix);
  
  ttim = timing('Time to solve the stiffness matrix',ttim); %Reporting time

% Compute the stresses
  Strnod = Stress_v1_3(dmat,poiss,thick,pstrs,u);

  ttim = timing('Time to  solve the  nodal stresses',ttim); %Reporting time
  
% Graphic representation
  ToGiD_v1_3(file_name,u,reaction,Strnod);
  
% JS and JSON Representation.
  ToJS (file_name, u, reaction, Strnod);
  ToJSON (file_name, u, reaction, Strnod);

  ttim = timing('Time  used to write  the  solution',ttim); %Reporting time
  itim = toc;                                               %Close last tic
  fprintf(1,'\nTotal running time %12.6f \n\n',ttim); %Reporting final time

