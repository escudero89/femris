%=======================================================================
% MAT-fem 1.3  - MAT-fem is a learning tool for undestanding
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example2.json
%
%  Material Properties
%
  young = 27000000 ;
  poiss = 0.2 ;
  denss = 1 ;
  pstrs = 1 ;
  thick = 1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    -0.5,    -0.5 ;
    0,    -0.5 ;
    0.5,    -0.5 ;
    0.5,    0.5 ;
    0,    0.5 ;
    -0.5,    0.5 ;
];

%
% Elements
%
global elements
elements = [
    1,    2,    5,    6 ;
    2,    3,    4,    5 ;
];

%
% Fixed Nodes
%
fixnodes = [
    1,    1,    0 ;
    1,    2,    0 ;
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
    4,    5,    0,    0 ;
    5,    6,    0,    0 ;
];


