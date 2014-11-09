%=======================================================================
% MAT-fem 1.0  - MAT-fem is a learning tool for undestanding 
%                the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = 
%
%  Material Properties
%
  young = 72000 ;
  poiss = 0.2 ;
  denss = 1 ;
  pstrs = 0 ;
  thick = 1 ;

%
% Coordinates
%
global coordinates
coordinates = [
    0,    nan ;
    0,    -inf ;
    1.5,    nan ;
    0,    inf ;
    -1.5,    nan ;
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
    3,    2,    0 ;
    4,    1,    0 ;
    4,    2,    0 ;
    5,    1,    0 ;
    5,    2,    0 ;
];

%
% Point loads
%
pointload = [
    1,    1,    1 ;
    1,    2,    1 ;
    2,    1,    1 ;
    2,    2,    1 ;
    3,    1,    2 ;
];

%
% Uniform Side loads
%
sideload = [
];




