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
End Values 
# 
Result "Reaction Force" "Load Analysis"  1  Vector OnNodes 
ComponentNames "Rx", "Ry", "Rz" 
Values 
     1        00000        00000 
     2       -00002       -00002 
     3        00000        00000 
     4        00000        00000 
     5       -00003       -00002 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1        00005        00005  0.0        00004  0.0  0.0 
     2        00005        00005  0.0        00004  0.0  0.0 
     3        00005        00005  0.0        00005  0.0  0.0 
     4        00005        00005  0.0        00005  0.0  0.0 
     5        00006        00005  0.0        00004  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1        00010        00000  0.0 
     2        00009        00001  0.0 
     3        00010        00000  0.0 
     4        00010        00000  0.0 
     5        00010        00001  0.0 
End Values 
