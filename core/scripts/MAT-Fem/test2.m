%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = 
%
%  Material Properties
%
  young =   210000000000.00000 ;
  poiss =              0.20000 ;
  denss =          78000.00000 ;
  pstrs =  1 ;
  thick =  1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    0,    0 ;
    0.333333,    0 ;
    0.666667,    0 ;
    1,    0 ;
    0,    0.333333 ;
    0.333333,    0.333333 ;
    0.666667,    0.333333 ;
    1,    0.333333 ;
    0,    0.666667 ;
    0.333333,    0.666667 ;
    0.666667,    0.666667 ;
    1,    0.666667 ;
    0,    1 ;
    0.333333,    1 ;
    0.666667,    1 ;
    1,    1 ;
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
    9,    13,    14,    10 ;
    10,    14,    15,    11 ;
    11,    15,    16,    12 ;
];

%
% Fixed Nodes
%
fixnodes = [
    1,    1,    0 ;
    1,    2,    0 ;
    2,    1,    0 ;
    2,    2,    0 ;
    3,    1,    0 ;
    3,    2,    0 ;
    4,    1,    0 ;
    4,    2,    0 ;
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
    12,    16,    0,    -30 ;
];





