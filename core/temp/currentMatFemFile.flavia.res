Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1         00000         00000 
     2         00000    -268435456 
     3         00000    -536870912 
     4     536870912    -536870912 
     5     536870912    -268435456 
     6     536870912         00000 
End Values 
# 
Result "Reaction Force" "Load Analysis"  1  Vector OnNodes 
ComponentNames "Rx", "Ry", "Rz" 
Values 
     1        00003        00005 
     2        00000        00000 
     3        00000        00000 
     4        00000        00000 
     5        00000        00000 
     6        00000        00000 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1       -00005       -00010  0.0       -00007  0.0  0.0 
     2       -00001        00000  0.0       -00007  0.0  0.0 
     3       -00004        00001  0.0       -00003  0.0  0.0 
     4        00000       -00003  0.0       -00002  0.0  0.0 
     5       -00005        00000  0.0       -00001  0.0  0.0 
     6       -00010       -00012  0.0        00000  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1        00000       -00016  0.0 
     2        00006       -00008  0.0 
     3        00002       -00005  0.0 
     4        00001       -00004  0.0 
     5        00000       -00005  0.0 
     6       -00010       -00012  0.0 
End Values 
