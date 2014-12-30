Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1         00000         00000 
     2         00000         17543 
     3         00000         35087 
     4        -17543         00000 
     5        -17543         17543 
     6        -17543         35087 
     7        -35087         00000 
     8        -35087         17543 
     9        -35087         35087 
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
     7        00000        00000 
     8        00000        00000 
     9        00000        00000 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1        00000        00001  0.0        00000  0.0  0.0 
     2        00000        00000  0.0        00000  0.0  0.0 
     3        00000        00000  0.0        00000  0.0  0.0 
     4        00000        00000  0.0        00000  0.0  0.0 
     5        00000        00000  0.0        00000  0.0  0.0 
     6        00000        00000  0.0        00000  0.0  0.0 
     7        00000        00000  0.0        00000  0.0  0.0 
     8        00000        00000  0.0        00000  0.0  0.0 
     9        00000        00000  0.0        00000  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1        00001        00000  0.0 
     2        00000        00000  0.0 
     3        00000        00000  0.0 
     4        00000        00000  0.0 
     5        00000        00000  0.0 
     6        00000        00000  0.0 
     7        00000        00000  0.0 
     8        00000        00000  0.0 
     9        00000        00000  0.0 
End Values 
