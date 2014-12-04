Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1         00000         00000 
     2         00000         00000 
     3         00000         00000 
     4         00000         00000 
     5         00000         00000 
     6         00000         00000 
     7         00000         00000 
     8         00000         00000 
     9         00000         00000 
End Values 
# 
Result "Reaction Force" "Load Analysis"  1  Vector OnNodes 
ComponentNames "Rx", "Ry", "Rz" 
Values 
     1        00000        00000 
     2        00000        00000 
     3        00000        00000 
     4        00000        00000 
     5        00000        00000 
     6        00000        00000 
     7        00000        00003 
     8        00000        00006 
     9        00000        00003 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1        00000       -00014        00002        00000  0.0  0.0 
     2        00000       -00015        00002        00000  0.0  0.0 
     3        00000       -00014        00002        00000  0.0  0.0 
     4        00000       -00014        00002        00000  0.0  0.0 
     5        00000       -00014        00002        00000  0.0  0.0 
     6        00000       -00014        00002        00000  0.0  0.0 
     7       -00003       -00015        00003        00001  0.0  0.0 
     8       -00003       -00014        00003        00000  0.0  0.0 
     9       -00003       -00015        00003       -00001  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1        00000       -00014        00002 
     2        00000       -00015        00002 
     3        00000       -00014        00002 
     4        00000       -00014        00002 
     5        00000       -00014        00002 
     6        00000       -00014        00002 
     7       -00003       -00015        00003 
     8       -00003       -00014        00003 
     9       -00003       -00015        00003 
End Values 
