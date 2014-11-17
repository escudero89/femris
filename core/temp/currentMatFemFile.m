%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = 
%
%  Material Properties
%
  young = 0 ;
  poiss = 0 ;
  denss = 0 ;
  pstrs = 0 ;
  thick = 0 ;

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




