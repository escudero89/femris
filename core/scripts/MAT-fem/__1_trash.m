%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = undefined
%
%  Material Properties
%
  young = 27000000 ;
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
    0.666667,    0 ;
    1.33333,    0 ;
    2,    0 ;
    0,    0.333333 ;
    0.666667,    0.333333 ;
    1.33333,    0.333333 ;
    2,    0.333333 ;
    0,    0.666667 ;
    0.666667,    0.666667 ;
    1.33333,    0.666667 ;
    2,    0.666667 ;
    0,    1 ;
    0.666667,    1 ;
    1.33333,    1 ;
    2,    1 ;
];

%
% Elements
%
global elements
 elements = [
    1,    5,    6,    2 ;
    2,    6,    7,    3 ;
    3,    7,    8,    4 ;
    5,    9,    10,    6 ;
    6,    10,    11,    7 ;
    7,    11,    12,    8 ;
    9,    13,    14,    10 ;
    10,    14,    15,    11 ;
    11,    15,    16,    12 ;
];

%
% Fixed Nodes
%
fixnodes = [
    13,    1,    0 ;
    13,    2,    0 ;
    16,    1,    0 ;
    16,    2,    0 ;
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
    1,    2,    0,    -15 ;
    2,    3,    0,    -30 ;
    3,    4,    0,    -15 ;
];


