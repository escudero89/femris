%%====================================================================%%
%%  ----------------------------------------------------------------  %%
%%  |   ~ FEMRIS 1.0 ~ Finite Element Method leaRnIng Software ~   |  %%
%%  |                                                              |  %%
%%  |         Copyright (C) 2014-2015 | Cristian Escudero          |  %%
%%  |                                                              |  %%
%%  | This program is free software; you can redistribute it       |  %%
%%  | and/or modify it under the terms of the GNU Lesser General   |  %%
%%  | Public License (LGPL) as published by the Free Software      |  %%
%%  | Foundation; either version 2.1 of the License, or (at your   |  %%
%%  | option) any later version.                                   |  %%
%%  |                                                              |  %%
%%  | This program is distributed in the hope that it will be      |  %%
%%  | useful, but WITHOUT ANY WARRANTY; without even the implied   |  %%
%%  | warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR      |  %%
%%  | PURPOSE. See the GNU Library General Public License for      |  %%
%%  | more details.                                                |  %%
%%  |                                                              |  %%
%%  | License File: http://www.gnu.org/licenses/lgpl.txt           |  %%
%%  ----------------------------------------------------------------  %%
%%====================================================================%%

function ToJSON (file_name, nodalDisplacements, reactions, nodalStresses)

    %% Saves a file in JSON format for its proper visualization using Femris
    %
    %  Parameters:
    %
    %    Input,  nodalDisplacements : Nodal displacements
    %            reactions          : Reactions on fixed nodes
    %            nodalStresses      : Nodal Stresses
    %
    %    Output, none
    %
    global coordinates;
    global elements;

    numberOfElements        = size(elements, 1);           % Number of elements
    numberOfNodesPerElement = size(elements, 2);           % Number of nodes per element
    numberOfNodes           = size(coordinates, 1);        % Number of nodes

    json_file = strcat(file_name, '.femris.json');

    fid = fopen( json_file, 'w' );

    fprintf(fid, '{\r\n');
    fprintf(fid, jsonParser('_comment', 'This file was generated automatically usign ToJSON.m for its use in FEMRIS'));

    %%

    fprintf(fid, jsonParser('_coordinates', 'The values are [ x-coord y-coord ]'));
    fprintf(fid, jsonParser('coordinates', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, ['%13.5e, %13.5e'], coordinates(i,:));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %%

    fprintf(fid, jsonParser('_elements', 'The values are [ indx-node1 ... indx-nodeN ]'));
    fprintf(fid, jsonParser('elements', '[\r\n', true));

    stringForNodesPerElement = ['%6.0i, %6.0i, %6.0i'];

    if (numberOfNodesPerElement == 4)
        stringForNodesPerElement = [ stringForNodesPerElement ', %6.0i'];
    end

    for i = 1 : numberOfElements

        fprintf(fid, '    [');
        fprintf(fid, stringForNodesPerElement, elements(i,:));

        if (i ~= numberOfElements)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %%

    fprintf(fid, jsonParser('_displacements', 'The values are [ x-displacement y-displacement ]'));
    fprintf(fid, jsonParser('displacements', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, ['%13.5e, %13.5e'], full(nodalDisplacements(i * 2 - 1)), full(nodalDisplacements(i * 2)));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %%

    fprintf(fid, jsonParser('_reactions', 'The values are [ x-reaction y-reaction ]'));
    fprintf(fid, jsonParser('reactions', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, [ '%13.5e, %13.5e'], full(reactions(i * 2 - 1)), full(reactions(i * 2)));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %%

    fprintf(fid, jsonParser('_stresses', 'The values are [ Sx Sy Sz Sxy Syz Sxz ]'));
    fprintf(fid, jsonParser('stresses', '[\r\n', true));

    if (size(nodalStresses, 2) == 3)
        for i = 1 : numberOfNodes
            fprintf(fid, '    [');
            fprintf(fid, ['%12.5e, %12.5e,  0.0, %12.5e,  0.0,  0.0'], nodalStresses(i, :));

            if (i ~= numberOfNodes)
                fprintf(fid, '],\r\n');
            else
                fprintf(fid, ']\r\n');
            end
        end
    else
        for i = 1 : numberOfNodes
            fprintf(fid, '    [');
            fprintf(fid, ['%12.5e, %12.5e,  %12.5e, %12.5e,  0.0,  0.0'], nodalStresses(i, :));

            if (i ~= numberOfNodes)
                fprintf(fid, '],\r\n');
            else
                fprintf(fid, ']\r\n');
            end

        end
    end

    fprintf(fid, '  ]\r\n');

    fprintf(fid, '}');

    status = fclose(fid);

end