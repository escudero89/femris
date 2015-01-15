%=======================================================================
% MAT-fem 1.3  - MAT-fem is a learning tool for undestanding
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example1.json
%
%  Material Properties
%
  young = 2700000 ;
  poiss = 0.2 ;
  denss = 1 ;
  pstrs = 0 ;
  thick = 1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    0,    0 ;
    0.5,    0 ;
    1,    0 ;
    0,    0.5 ;
    0.5,    0.5 ;
    1,    0.5 ;
    0,    1 ;
    0.5,    1 ;
    1,    1 ;
];

%
% Elements
%
global elements
elements = [
    1,    4,    5,    2 ;
    2,    5,    6,    3 ;
    4,    7,    8,    5 ;
    5,    8,    9,    6 ;
];

%
% Fixed Nodes
%
fixnodes = [
    1,    1,    0 ;
    1,    2,    0 ;
    7,    1,    0 ;
    7,    2,    0 ;
];

%
% Point loads
%
pointload = [
];

%
% Uniform Side loads
%
sideload = [
    1,    2,    0,    0 ;
    2,    3,    0,    0 ;
    1,    4,    0,    0 ;
    4,    7,    0,    0 ;
    7,    8,    0,    0 ;
    8,    9,    0,    0 ;
];


