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
  pstrs = 1 ;
  thick = 1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    0,    0 ;
    0,    -0.5 ;
    0.5,    0 ;
    0,    0.5 ;
    -0.5,    0 ;
];

%
% Elements
%
global elements
 elements = [
    1,    2,    3 ;
    1,    3,    4 ;
    1,    4,    5 ;
    1,    5,    2 ;
];

%
% Fixed Nodes
%
fixnodes = [
    2,    1,    0 ;
    2,    2,    0 ;
    5,    1,    0 ;
    5,    2,    0 ;
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
    3,    4,    7.5,    7.5 ;
];

