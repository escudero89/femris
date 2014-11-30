%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = undefined
%
%  Material Properties
%
  young = 0 ;
  poiss = 0 ;
  denss = 0 ;
  pstrs = 1 ;
  thick = 0 ;

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


