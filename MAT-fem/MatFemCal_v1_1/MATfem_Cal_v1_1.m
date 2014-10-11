%% MAT-femCal
%
% Clear memory and variables.
  clear
  
% The variables are readed as a MAT-femCal subroutine
% kx   = Heat transfer coeffcient in x direction
% kx   = Heat transfer coeffcient in x direction
% heat = Heat source per area unit
% coordinates = [ x , y ] coordinate matrix nnode x ndime (2)
% elements    = [ inode, jnode, knode ] element conectivities matrix
%               nelem x nnode; nnode = 3 for triangular elements and 
%               nnode = 4 for cuadrilateral elements
% fixnodes    = [node number, fixed value] matrix with 
%               restricted temperatures restrictions.
% pointload   = [node number load value] matrix with 
%               flux load.
% SideLoad    = [node number i, node number j, normal flux] matrix with 
%               line definition and uniform normal flux applied

  file_name = input('Enter the file name :','s');

  tic;                   % Start clock
  ttim = 0;              % Initialize time counter
  eval (file_name);      % Read input file

% Finds basics dimentions
  npnod  = size(coordinates,1);      % Number of nodes
  nndof  = npnod;                    % Number of total DOF
  nelem  = size(elements,1);         % Number of elements
  nnode  = size(elements,2);         % Number of nodes per element
  neleq  = nnode;                    % Number of DOF per element

  ttim = timingCal('Time needed to read the input file',ttim); %Reporting time

% Dimension the global matrices.
  StifMat = sparse ( nndof , nndof );  % Create the global stiffness matrix
  force   = sparse ( nndof , 1 );      % Create the global force vector

%  Material properties (Constant over the domain).
  dmat = consttCal(kx,ky);

  ttim = timingCal('Time needed to  set initial values',ttim); %Reporting time

%  Element cycle.
  for ielem = 1 : nelem

% Recover element properties
    lnods = elements(ielem,:);                        % Elem. conectivities
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:); % Elem. coordinates
 
% Evaluates the elemental stiffnes matrix and mass force vector.
    if (nnode == 3)
      [ElemMat,ElemFor] = TrStifCal(coord,dmat,heat); % 3 Nds Triangle
    else 
      [ElemMat,ElemFor] = QdStifCal(coord,dmat,heat); % 4 Nds Quad.
    end
    
% Finds the equation number list for the i-th element
    eqnum = [];                                  % Clear the list
    for i =1 : nnode                             % Node cicle
      eqnum = [eqnum,lnods];                     % Build the equation 
    end                                          % number list

% Assamble the force vector and the stiffnes matrix
    for i = 1 : neleq
      force(eqnum(i)) = force(eqnum(i)) + ElemFor(i);
      for j = 1 : neleq
         StifMat(eqnum(i),eqnum(j)) = StifMat(eqnum(i),eqnum(j)) + ...
                                      ElemMat(i,j);
      end
    end

  end  % End element cicle

  ttim = timingCal('Time to assamble the global system',ttim); %Reporting time

%  Add side forces to the force vector
  for i = 1 : size(sideload,1)
      x=coordinates(sideload(i,1),:)-coordinates(sideload(i,2),:);
      l = sqrt(x*transpose(x));       % Finds the lenght of the side
      ieqn = sideload(i,1);           % Finds eq. number for the first node
      force(ieqn) = force(ieqn) + l*sideload(i,3)/2;     % add puntual heat 

     ieqn = sideload(i,2);            % Finds eq. number for the second node
     force(ieqn) = force(ieqn) + l*sideload(i,3)/2;      % add puntual heat 
  end

%  Add point loads conditions to the force vector
  for i = 1 : size(pointload,1)
    ieqn = pointload(i,1);                              % Finds eq. number
    force(ieqn) = force(ieqn) + pointload(i,2);         % add the force
  end

  ttim = timingCal('Time for apply side and point load',ttim); %Reporting time

 %  Applies the Dirichlet conditions and adjust the right hand side.
  u = sparse ( nndof, 1 );
  for i = 1 : size(fixnodes,1)
    ieqn = fixnodes(i,1);                      %Finds the equation number
    u(ieqn) = fixnodes(i,2);                   %and store the solution in u
    fix(i) = ieqn;                         % and mark the eq as a fix value
  end
  force = force - StifMat * u;       % adjust the rhs with the known values

%  Compute the solution by solving StifMat * u = force for the 
%  remaining unknown values of u.
  FreeNodes = setdiff ( 1:nndof, fix ); % Finds the free node list and
                                        % solve for it.
  u(FreeNodes) = StifMat(FreeNodes,FreeNodes) \ force(FreeNodes);

%  Compute the reactions on the fixed nodes as a R = StifMat * u - F
  reaction = sparse(nndof,1);
  reaction(fix) = StifMat(fix,1:nndof) * u(1:nndof) - force(fix);
  
  ttim = timingCal('Time  to solve the stifness matrix',ttim); %Reporting time

% Compute the stresses
  Strnod = StressCal(dmat,u);

  ttim = timingCal('Time to  solve the  nodal stresses',ttim); %Reporting time
  
% Graphic representation.
  ToGiDCal (file_name,u,reaction,Strnod);

  ttim = timingCal('Time  used to write  the  solution',ttim); %Reporting time
  itim = toc;                                               %Close last tic
  fprintf(1,'\n Total running time %12.6f \n',ttim);  %Reporting final time
