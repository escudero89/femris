%=======================================================================
% MAT-femcCal 1.3  - MAT-femCal is a learning tool for undestanding
%                    the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example7.json
%
%  Material Properties
%
  kx   = 11 ;
  ky   = 1 ;
  heat = 1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    0,    0 ;
    1,    0 ;
    0.333333,    0.333333 ;
    0.666667,    0.333333 ;
    0.333333,    0.666667 ;
    0.666667,    0.666667 ;
    0,    1 ;
    1,    1 ;
];

%
% Elements
%
global elements
elements = [
    1,    3,    4,    2 ;
    1,    7,    5,    3 ;
    2,    4,    6,    8 ;
    5,    7,    8,    6 ;
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

