%=======================================================================
% MAT-fem 1.3  - MAT-fem is a learning tool for undestanding
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example1.json
%
%  Material Properties
%
  young = false ;
  poiss = false ;
  denss = false ;
  pstrs = 0 ;
  thick = false ;

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
];


