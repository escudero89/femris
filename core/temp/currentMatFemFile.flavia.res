Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1      30226292         00000 
     2      30226292      15113146 
     3      30226292      30226292 
     4         00000      30226292 
     5         00000      15113146 
     6         00000         00000 
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
     6       -00008        00000 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1       -00010       -00001  0.0       -00002  0.0  0.0 
     2       -00006       -00003  0.0        00002  0.0  0.0 
     3       -00006       -00002  0.0        00000  0.0  0.0 
     4        00009        00000  0.0        00001  0.0  0.0 
     5        00016        00002  0.0        00001  0.0  0.0 
     6        00024        00005  0.0       -00005  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1        00000       -00011  0.0 
     2       -00001       -00008  0.0 
     3       -00002       -00006  0.0 
     4        00010        00000  0.0 
     5        00016        00002  0.0 
     6        00026        00004  0.0 
End Values 
