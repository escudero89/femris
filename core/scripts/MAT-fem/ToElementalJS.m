function ToElementalJS(file_name)

    %% Saves a file as javascript for its proper visualization using femris
    % with the content of all necessary to visualize elemental matrices
    %

    global elements;
    global femris_elemental_matrix;

    numberOfNodesPerElement = size(elements, 2);           % Number of nodes per element

    js_file = strcat(file_name, '_elemental.femris.js');

    fid = fopen( js_file, 'w' );

    fprintf(fid, 'var G_CURRENT_ELEMENTAL_DATA = {\r\n');

    fprintf(fid, MatrixToJSON(femris_elemental_matrix{1}, 'stiffness_matrix', 'This is the matrix of the global stiffness matrix'));
    
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{2}, 'dmat', 'This is the constitutive matrix'));
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{3}, 'young', 'Young Modulus'));
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{4}, 'poiss', 'Poission Ratio'));
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{5}, 'pstrs', '1 indicate Plane Stress; 0 indicate Plane Strain'));

    fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{10}, 'M', 'This is the matrix of the global stiffness matrix'));
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{21}, 'f', 'This is the vector of forces'));
    fprintf(fid, MatrixToJSON(femris_elemental_matrix{22}, 'u', 'This is the vector of the displacements'));

    if (numberOfNodesPerElement == 4)

        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{12}, 'lcffm', 'SF at Gauss point'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{13}, 'lcder', 'SF Local derivatives'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{14}, 'xjacm', 'Jacobian matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{15}, 'ctder', 'SF Cartesian derivates'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{16}, 'darea', 'This is the matrix of the global stiffness matrix'));

    else

        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{16}, 'area', 'This is the matrix of the global stiffness matrix'));

    end

    fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{17}, 'bmat', 'This is the matrix of the global stiffness matrix'));

    fprintf(fid, '};');

    status = fclose(fid);

end