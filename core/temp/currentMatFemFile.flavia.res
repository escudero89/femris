Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1         00000         00000 
     2         00000 %13.5.f 
     3         00000 %13.5.f 
     4 %13.5.f         00000 
     5 %13.5.f %13.5.f 
     6 %13.5.f %13.5.f 
     7 %13.5.f         00000 
     8 %13.5.f %13.5.f 
     9 %13.5.f %13.5.f 
End Values 
# 
Result "Reaction Force" "Load Analysis"  1  Vector OnNodes 
ComponentNames "Rx", "Ry", "Rz" 
Values 
     1       -00003       -00008 
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
     1       -00011       -00019        00004       -00015  0.0  0.0 
     2       -00001        00013       -00001       -00005  0.0  0.0 
     3        00001        00013       -00002        00000  0.0  0.0 
     4       -00003       -00010        00002       -00002  0.0  0.0 
     5       -00001        00007        00000       -00001  0.0  0.0 
     6       -00003        00008        00000        00000  0.0  0.0 
     7        00000       -00002        00000        00000  0.0  0.0 
     8        00001        00003        00000       -00001  0.0  0.0 
     9        00000        00000        00000        00000  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1       -00011       -00019        00004 
     2       -00001        00013       -00001 
     3        00001        00013       -00002 
     4       -00003       -00010        00002 
     5       -00001        00007        00000 
     6       -00003        00008        00000 
     7        00000       -00002        00000 
     8        00001        00003        00000 
     9        00000        00000        00000 
End Values 
