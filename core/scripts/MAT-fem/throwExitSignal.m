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

function throwExitSignal(errormsg)

    if ( nargin > 0 )
        fprintf('\n');
        fprintf(1, '------------------------------------------------------------------\n');
        fprintf(1, strcat('Error:\n', errormsg));
        fprintf('\n');
        fprintf(1, '------------------------------------------------------------------\n');
        exit;
    end

    fprintf('\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf(1, 'Reached end of the program...\n');
    fprintf(1, 'Signal (EXIT_PROCESS)\n');
    fprintf(1, '------------------------------------------------------------------\n');
    fprintf('\n');

    exit;



