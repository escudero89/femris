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

    if (numberOfNodesPerElement == 4)

        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{12}, 'lcffm', 'This is the matrix of the global stiffness matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{13}, 'lcder', 'This is the matrix of the global stiffness matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{14}, 'xjacm', 'This is the matrix of the global stiffness matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{15}, 'ctder', 'This is the matrix of the global stiffness matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{16}, 'darea', 'This is the matrix of the global stiffness matrix'));
        fprintf(fid, MultidimensionalToJSON(femris_elemental_matrix{17}, 'bmat', 'This is the matrix of the global stiffness matrix'));

    end

    fprintf(fid, '};');

    status = fclose(fid);

end