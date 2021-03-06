%=======================================================================
% MAT-femcCal 1.0  - MAT-femCal is a learning tool for undestanding 
%                    the Finite Element Method with MATLAB and GiD
%=======================================================================
% PROBLEM TITLE = Titulo del problema
%
%  Material Properties
%
  kx =              1.00000 ;
  ky =              1.00000 ;
 heat=              0.00000 ;
%
% Coordinates
%
global coordinates
coordinates = [
         0.00000   ,        10.00000  ;
         2.00000   ,        10.00000  ;
         0.00000   ,         8.00000  ;
         1.77671   ,         7.16667  ;
         4.00000   ,        10.00000  ;
         0.00000   ,         6.00000  ;
         3.46410   ,         8.00000  ;
         3.46410   ,         6.00000  ;
         1.73205   ,         5.00000  ;
         6.00000   ,        10.00000  ;
         0.00000   ,         4.00000  ;
         5.33013   ,         7.16667  ;
         3.46410   ,         4.00000  ;
         6.93555   ,         8.06667  ;
         5.19615   ,         5.00000  ;
         1.77671   ,         2.83333  ;
         0.00000   ,         2.00000  ;
         8.00000   ,        10.00000  ;
         6.92820   ,         6.00000  ;
         3.46410   ,         2.00000  ;
         8.41944   ,         7.16667  ;
         5.14011   ,         2.42857  ;
         6.92820   ,         4.00000  ;
        10.00000   ,        10.00000  ;
         0.00000   ,         0.00000  ;
         8.66025   ,         5.00000  ;
         2.00000   ,         0.00000  ;
        10.00000   ,         8.00000  ;
         6.89653   ,         1.84746  ;
         4.00000   ,         0.00000  ;
        10.00000   ,         6.00000  ;
         8.41433   ,         2.80873  ;
        10.00000   ,         4.00000  ;
         6.00000   ,         0.00000  ;
        10.00000   ,         2.00000  ;
         8.00000   ,         0.00000  ;
        10.00000   ,         0.00000  ] ; 
%
% Elements
%
global elements
elements = [
     31   ,     28   ,     21   ; 
      3   ,      6   ,      4   ; 
     21   ,     28   ,     18   ; 
      4   ,      6   ,      9   ; 
      9   ,      6   ,     11   ; 
      9   ,     11   ,     16   ; 
     16   ,     11   ,     17   ; 
     25   ,     27   ,     17   ; 
      4   ,      9   ,      8   ; 
      8   ,      9   ,     13   ; 
      4   ,      8   ,      7   ; 
      7   ,      8   ,     12   ; 
     12   ,      8   ,     15   ; 
     13   ,      9   ,     16   ; 
     13   ,     16   ,     20   ; 
     20   ,     16   ,     27   ; 
     15   ,      8   ,     13   ; 
     15   ,     13   ,     22   ; 
     22   ,     13   ,     20   ; 
     15   ,     22   ,     23   ; 
     23   ,     22   ,     29   ; 
     29   ,     22   ,     34   ; 
     15   ,     23   ,     19   ; 
     19   ,     23   ,     26   ; 
     15   ,     19   ,     12   ; 
     12   ,     19   ,     14   ; 
     12   ,     14   ,     10   ; 
     26   ,     23   ,     32   ; 
     19   ,     26   ,     21   ; 
     19   ,     21   ,     14   ; 
     14   ,     21   ,     18   ; 
     32   ,     23   ,     29   ; 
     26   ,     32   ,     33   ; 
     26   ,     33   ,     31   ; 
     33   ,     32   ,     35   ; 
     35   ,     32   ,     36   ; 
     26   ,     31   ,     21   ; 
     22   ,     30   ,     34   ; 
     10   ,      7   ,     12   ; 
     36   ,     37   ,     35   ; 
     30   ,     22   ,     20   ; 
     16   ,     17   ,     27   ; 
     24   ,     18   ,     28   ; 
      7   ,     10   ,      5   ; 
      2   ,      1   ,      3   ; 
     32   ,     29   ,     36   ; 
     27   ,     30   ,     20   ; 
      5   ,      2   ,      7   ; 
      3   ,      4   ,      2   ; 
     18   ,     10   ,     14   ; 
     34   ,     36   ,     29   ; 
      4   ,      7   ,      2   ] ; 
%
% Fixed Nodes
%
fixnodes = [
      1  , 1 ,    0.00000  ;
      3  , 1 ,    0.00000  ;
      6  , 1 ,    0.00000  ;
     11  , 1 ,    0.00000  ;
     17  , 1 ,    0.00000  ;
     24  , 1 ,  100.00000  ;
     25  , 1 ,    0.00000  ;
     28  , 1 ,  100.00000  ;
     31  , 1 ,  100.00000  ;
     33  , 1 ,  100.00000  ;
     35  , 1 ,  100.00000  ;
     37  , 1 ,  100.00000  ] ;
%
% Punctual Fluxes
%
pointload = [ ] ;
%
% Side loads
%
sideload = [ ];

