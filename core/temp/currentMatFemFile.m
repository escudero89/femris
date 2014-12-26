%=======================================================================
% MAT-femcCal 1.3  - MAT-femCal is a learning tool for undestanding
%                    the Finite Element Method with MATLAB and GiD
%=======================================================================
% EXAMPLE SELECTED = example2.json
%
%  Material Properties
%
  kx   = 1 ;
  ky   = 1 ;
  heat = 0 ;

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
    1,    0 ;
    2,    0 ;
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


