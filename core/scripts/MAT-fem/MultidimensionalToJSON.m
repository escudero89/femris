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

function [jsonfy] = MultidimensionalToJSON(multidimensional, label, comment, isLastBlock)

    numberOfDimensions = size(multidimensional, 3);

    jsonfy = jsonParser(strcat('_', label), comment);
    jsonfy = strcat(jsonfy, jsonParser(label, '[\r\n', true));

    % We jump up the first value (that's zeros for how it is implemented)
    for k = 2 : numberOfDimensions

        if ( k ~= numberOfDimensions )
            jsonfy = strcat(jsonfy, jsonfyMatrixAsArray(multidimensional(:,:,k)));
        else
            jsonfy = strcat(jsonfy, jsonfyMatrixAsArray(multidimensional(:,:,k), true));
        end

    end

    if ( nargin > 3 )
        jsonfy = strcat(jsonfy, '  ]\r\n');
    else
        jsonfy = strcat(jsonfy, '  ],\r\n');
    end

end