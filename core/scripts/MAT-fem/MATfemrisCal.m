  % FEMRIS ADDITION >>>>>>>
  %% This file has been modify from the original, MAT-femCal

  global femris_elemental_matrix
  femris_elemental_matrix = cell(30);

  file_name = '../../temp/currentMatFemFile';%'__1_trash'; %

  if (exist('scripts/') == 0)
    cd ..;
  end

  cd 'scripts/';
  cd 'MAT-fem/';

  if ( size(fixnodes, 1) == 0 && size(pointload, 1) == 0 )
    fixnodes
    pointload
    throwExitSignal('Falta definirse alguna condición de contorno.');
  end
  % <<< END FEMRIS ADDITION

% The variables are readed as a MAT-femCal subroutine
% kx   = Heat transfer coeffcient in X direction
% ky   = Heat transfer coeffcient in Y direction
% heat = Heat source per area unit
% coordinates = [ x , y ] coordinate matrix nnode x ndime (2)
% elements    = [ inode , jnode , knode ] element connectivity matrix
%               nelem x nnode; nnode = 3 for triangular elements and
%               nnode = 4 for cuadrilateral elements
% fixnodes    = [ node number , fixed value ] matrix with
%               restricted temperature restrictions
% pointload   = [ node number i , punctual flux ] matrix with
%               punctual fluxes applied
% sideload    = [ node number i , node number j , normal flux ] matrix
%               with line definition and uniform normal flux applied

  tic;                   % Start clock
  ttim = 0;              % Initialize time counter

% Find basic dimensions
  npnod = size(coordinates,1);       % Number of nodes
  nndof = npnod;                     % Number of total DOF
  nelem = size(elements,1);          % Number of elements
  nnode = size(elements,2);          % Number of nodes per element
  neleq = nnode;                     % Number of DOF per element

  ttim = timingCal('Time needed to read the input file',ttim); %Reporting time

% Dimension the global matrices
  StifMat  = sparse( nndof , nndof );  % Create the global stiffness matrix
  force    = sparse( nndof , 1 );      % Create the global force vector
  force1   = sparse( nndof , 1 );      % Create the global force vector
  reaction = sparse( nndof , 1 );      % Create the global reaction vector
  u        = sparse( nndof , 1 );      % Nodal variables

% Material properties (Constant over the domain)
  dmat = consttCal(kx,ky);

  ttim = timingCal('Time needed to  set initial values',ttim); %Reporting time

% Element cycle
  for ielem = 1 : nelem

% Recover element properties
    lnods = elements(ielem,:);                         % Elem. connectivity
    coord(1:nnode,:) = coordinates(lnods(1:nnode),:);  % Elem. coordinates

% Evaluate the elemental stiffnes matrix and mass force vector
    if (nnode == 3)
      [ElemMat,ElemFor] = TrStifCal_v1_2(coord,dmat,heat); % 3 Nds Triangle
    else
      [ElemMat,ElemFor] = QdStifCal_v1_2(coord,dmat,heat); % 4 Nds Quad.
    end

% Find the equation number list for the i-th element
    eqnum = [];                            % Clear the list
    for i =1 : nnode                       % Node cycle
      eqnum = [eqnum,lnods];               % Build the equation number list
    end

% Assemble the force vector and the stiffnes matrix
    for i = 1 : neleq
      force(eqnum(i)) = force(eqnum(i)) + ElemFor(i);
      for j = 1 : neleq
        StifMat(eqnum(i),eqnum(j)) = StifMat(eqnum(i),eqnum(j)) + ...
                                     ElemMat(i,j);
      end
    end

  end  % End element cycle

  ttim = timingCal('Time to assemble the global system',ttim); %Reporting time

% Add side fluxes to the force vector
  for i = 1 : size(sideload,1)
    x = coordinates(sideload(i,1),:) - coordinates(sideload(i,2),:);
    l = sqrt(x*transpose(x));          % Find the lenght of the side
    ieqn = sideload(i,1);              % Find eq. number for the first node
    force(ieqn) = force(ieqn) + l*sideload(i,3)/2;      % Add punctual heat

    ieqn = sideload(i,2);             % Find eq. number for the second node
    force(ieqn) = force(ieqn) + l*sideload(i,3)/2;      % Add punctual heat
  end

% Add punctual flux conditions to the force vector
  for i = 1 : size(pointload,1)
    ieqn = pointload(i,1);                               % Find eq. number
    force(ieqn) = force(ieqn) + pointload(i,2);          % and add the flux
  end

  ttim = timingCal('Time for apply side and point load',ttim); %Reporting time

% Apply the Dirichlet conditions and adjust the right hand side
  for i = 1 : size(fixnodes,1)
    ieqn = fixnodes(i,1);                        % Find the equation number
    u(ieqn) = fixnodes(i,2);                  % and store the solution in u
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

  ttim = timingCal('Time to solve the stiffness matrix',ttim); %Reporting time

% Compute the stresses
  Strnod = StressCal_v1_2(dmat,u);

  ttim = timingCal('Time to  solve the  nodal stresses',ttim); %Reporting time

% Graphic representation
  ToGiDCal_v1_2(file_name,u,reaction,Strnod);

  ttim = timingCal('Time  used to write  the  solution',ttim); %Reporting time

% FEMRIS ADDITION >>>>>>>
  global femris_elemental_matrix;
  femris_elemental_matrix{01} = full(StifMat);
  femris_elemental_matrix{02} = dmat;
  femris_elemental_matrix{03} = false;
  femris_elemental_matrix{04} = false;
  femris_elemental_matrix{05} = false;
  femris_elemental_matrix{06} = kx;
  femris_elemental_matrix{07} = ky;
  femris_elemental_matrix{08} = heat;
  femris_elemental_matrix{21} = full(force1);
  femris_elemental_matrix{22} = u;

% JS and JSON Representation.
  ToJS (file_name, u, reaction, Strnod);
  ToJSON (file_name, u, reaction, Strnod);

  ToElementalJS(file_name);

  ttim = timing('Time  to  write  files for femris',ttim); %Reporting time
% <<< END FEMRIS ADDITION

  itim = toc;                                               %Close last tic
  fprintf(1,'\nTotal running time %12.6f \n\n',ttim); %Reporting final time

% FEMRIS ADDITION >>>>>>>
  throwExitSignal();
% <<< END FEMRIS ADDITION