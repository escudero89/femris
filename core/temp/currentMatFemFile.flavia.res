Gid Post Results File 1.0 
### 
# MAT-fem v1.3 
# 
Result "Displacement" "Load Analysis"  1  Vector OnNodes 
ComponentNames "X-Displ", "Y-Displ", "Z-Displ" 
Values 
     1         00000           NaN 
     2           NaN         00000 
     3         00000           NaN 
     4           NaN           NaN 
     5           NaN           NaN 
     6           NaN           NaN 
End Values 
# 
Result "Reaction Force" "Load Analysis"  1  Vector OnNodes 
ComponentNames "Rx", "Ry", "Rz" 
Values 
     1          NaN        00000 
     2        00000          NaN 
     3          NaN        00000 
     4        00000        00000 
     5        00000        00000 
     6        00000        00000 
End Values 
# 
Result "Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "Sx", "Sy", "Sz", "Sxy", "Syz", "Sxz" 
Values 
     1          NaN          NaN  0.0          NaN  0.0  0.0 
     2          NaN          NaN  0.0          NaN  0.0  0.0 
     3          NaN          NaN  0.0          NaN  0.0  0.0 
     4          NaN          NaN  0.0          NaN  0.0  0.0 
     5          NaN          NaN  0.0          NaN  0.0  0.0 
     6          NaN          NaN  0.0          NaN  0.0  0.0 
End Values 
Result "Principal Stress" "Load Analysis"  1  Matrix OnNodes 
ComponentNames "S1", "S2", "S3" 
Values 
     1          NaN          NaN  0.0 
     2          NaN          NaN  0.0 
     3          NaN          NaN  0.0 
     4          NaN          NaN  0.0 
     5          NaN          NaN  0.0 
     6          NaN          NaN  0.0 
End Values 
