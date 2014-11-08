function ToGiD_v1_3(file_name,u,reaction,Strnod)

%% ToGiD Writes the postprocess files
%
%  Parameters:
%
%    Input, file_name : GiD File name
%           u         : Nodal displacements
%           reaction  : Nodal reactions
%           Strnod    : Nodal stresses
%   
%    Output, none

  global coordinates;
  global elements;
 
  nelem = size(elements,1);            % Number of elements
  nnode = size(elements,2);            % Number of nodes per element
  npnod = size(coordinates,1);         % Number of nodes

  if (nnode == 3)
    eletyp = 'Triangle';
  else
    eletyp = 'Quadrilateral';
  end

  msh_file = strcat(file_name,'.flavia.msh');
  res_file = strcat(file_name,'.flavia.res');
  
% Mesh File
  fid = fopen(msh_file,'w');
  fprintf(fid,'### \n');
  fprintf(fid,'# MAT-fem v1.3 \n');
  fprintf(fid,'# \n');
  fprintf(fid,'MESH dimension %3.0f   Elemtype %s   Nnode %2.0f \n \n',2,eletyp,nnode);
  fprintf(fid,'coordinates \n');
  for i = 1 : npnod
    fprintf(fid,'%6.0f %12.5d %12.5d \n',i,coordinates(i,:));
  end
  fprintf(fid,'end coordinates \n \n');
  fprintf(fid,'elements \n');
  if (nnode == 3)
    for i = 1 : nelem
      fprintf(fid,'%6.0f %6.0f %6.0f %6.0f   1 \n',i,elements(i,:));
    end
  else
    for i = 1 : nelem
      fprintf(fid,'%6.0f %6.0f %6.0f %6.0f %6.0f  1 \n',i,elements(i,:));
    end
  end 
  fprintf(fid,'end elements \n \n');
 
  status = fclose(fid);
  
% Results File
  fid = fopen(res_file,'w');
  fprintf(fid,'Gid Post Results File 1.0 \n');
  fprintf(fid,'### \n');
  fprintf(fid,'# MAT-fem v1.3 \n');
  fprintf(fid,'# \n');
  
% Displacement
  fprintf(fid,'Result "Displacement" "Load Analysis"  1  Vector OnNodes \n');
  fprintf(fid,'ComponentNames "X-Displ", "Y-Displ", "Z-Displ" \n');
  fprintf(fid,'Values \n');
  for i = 1 : npnod
    fprintf(fid,'%6.0i %13.5d %13.5d \n',i,full(u(i*2-1)),full(u(i*2)));
  end
  fprintf(fid,'End Values \n');
  fprintf(fid,'# \n');
  
% Reaction Force
  fprintf(fid,'Result "Reaction Force" "Load Analysis"  1  Vector OnNodes \n');
  fprintf(fid,'ComponentNames "Rx", "Ry", "Rz" \n');
  fprintf(fid,'Values \n');
  for i = 1 : npnod
    fprintf(fid,'%6.0f %12.5d %12.5d \n',i,full(reaction(i*2-1)),full(reaction(i*2)));
  end
  fprintf(fid,'End Values \n');
  fprintf(fid,'# \n');
  
% Stress
  fprintf(fid,'Result "Stress" "Load Analysis"  1  Matrix OnNodes \n');
  fprintf(fid,'ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" \n');
  fprintf(fid,'Values \n');
  
  if (size(Strnod,2) == 3) 
    for i = 1 : npnod
      fprintf(fid,'%6.0f %12.5d %12.5d  0.0 %12.5d  0.0  0.0 \n',i,Strnod(i,:));
    end
  else
    for i = 1 : npnod
      fprintf(fid,'%6.0f %12.5d %12.5d %12.5d %12.5d  0.0  0.0 \n',i,Strnod(i,:));
    end
  end  
  fprintf(fid,'End Values \n');

% Principal Stress
  fprintf(fid,'Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes \n');
  fprintf(fid,'ComponentNames "S1", "S2", "S3" \n');
  fprintf(fid,'Values \n');
  
  if (size(Strnod,2) == 3) 
    for i = 1 : npnod
      sc = (Strnod(i,1)+Strnod(i,2))/2;
      rc = sqrt((Strnod(i,1)-sc)^2 + Strnod(i,3)^2);
      fprintf(fid,'%6.0f %12.5d %12.5d  0.0 \n',i,sc+rc,sc-rc);
    end
  else
    for i = 1 : npnod
      fprintf(fid,'%6.0f %12.5d %12.5d %12.5d \n',i,Strnod(i,1),Strnod(i,2),Strnod(i,3));
    end
  end  
  fprintf(fid,'End Values \n');
  
  status = fclose(fid);

