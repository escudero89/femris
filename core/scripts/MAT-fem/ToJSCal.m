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

function ToJSCal (file_name, nodalTemperatures, nodalReactiveFluxes, nodalFluxes)

    %% Saves a file as javascript for its proper visualization using femris
    %
    %  Parameters:
    %
    %    Input,  nodalTemperatures  : Nodal temperatures
    %            nodalReactiveFluxes: Nodal reactive fluxes
    %            nodalFluxes        : Nodal fluxes
    %
    %    Output, none
    %
    global coordinates;
    global elements;

    numberOfElements        = size(elements, 1);           % Number of elements
    numberOfNodesPerElement = size(elements, 2);           % Number of nodes per element
    numberOfNodes           = size(coordinates, 1);        % Number of nodes

    json_file = strcat(file_name, '.femris.js');

    fid = fopen( json_file, 'w' );

    % These are the only lines that are different from ToJSON
    fprintf(fid, 'var G_CURRENT_DOMAIN = {\r\n');
    fprintf(fid, jsonParser('_comment', 'This file was generated automatically usign ToJS.m for its use in FEMRIS'));

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

    %% temperature

    fprintf(fid, jsonParser('_temperatures', 'The values are [ temperature-value ]'));
    fprintf(fid, jsonParser('temperatures', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, ['%13.5e'], nodalTemperatures(i)));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %% reactive

    fprintf(fid, jsonParser('_nodalReactiveFluxes', 'The values are [ reactive-flux-value ]'));
    fprintf(fid, jsonParser('nodalReactiveFluxes', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, [ '%13.5e' ], nodalReactiveFluxes(i));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ],\r\n');

    %% fluxes

    fprintf(fid, jsonParser('_fluxes', 'The values are [ Sx Sy Sz Sxy Syz Sxz ]'));
    fprintf(fid, jsonParser('fluxes', '[\r\n', true));

    for i = 1 : numberOfNodes
        fprintf(fid, '    [');
        fprintf(fid, ['%12.5e, %12.5e, 0.0'], nodalFluxes(i, :));

        if (i ~= numberOfNodes)
            fprintf(fid, '],\r\n');
        else
            fprintf(fid, ']\r\n');
        end
    end

    fprintf(fid, '  ]\r\n');

    fprintf(fid, '};');

    status = fclose(fid);

end
