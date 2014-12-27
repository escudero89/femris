%=======================================================================
% MAT-femcCal 1.3  - MAT-femCal is a learning tool for undestanding
%                    the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example1.json
%
%  Material Properties
%
  kx   = 1 ;
  ky   = 1 ;
  heat = 100 ;

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
    1,    0 ;
    3,    0 ;
    7,    0 ;
    9,    0 ;
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


