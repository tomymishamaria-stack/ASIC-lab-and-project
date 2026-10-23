# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Thu Oct 15 19:34:22 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design alu_expr

set_load -pin_load 5.0 [get_ports {Y[10]}]
set_load -pin_load 5.0 [get_ports {Y[9]}]
set_load -pin_load 5.0 [get_ports {Y[8]}]
set_load -pin_load 5.0 [get_ports {Y[7]}]
set_load -pin_load 5.0 [get_ports {Y[6]}]
set_load -pin_load 5.0 [get_ports {Y[5]}]
set_load -pin_load 5.0 [get_ports {Y[4]}]
set_load -pin_load 5.0 [get_ports {Y[3]}]
set_load -pin_load 5.0 [get_ports {Y[2]}]
set_load -pin_load 5.0 [get_ports {Y[1]}]
set_load -pin_load 5.0 [get_ports {Y[0]}]
set_max_delay 5 -from [list \
  [get_ports {A[7]}]  \
  [get_ports {A[6]}]  \
  [get_ports {A[5]}]  \
  [get_ports {A[4]}]  \
  [get_ports {A[3]}]  \
  [get_ports {A[2]}]  \
  [get_ports {A[1]}]  \
  [get_ports {A[0]}]  \
  [get_ports {B[7]}]  \
  [get_ports {B[6]}]  \
  [get_ports {B[5]}]  \
  [get_ports {B[4]}]  \
  [get_ports {B[3]}]  \
  [get_ports {B[2]}]  \
  [get_ports {B[1]}]  \
  [get_ports {B[0]}]  \
  [get_ports {C[7]}]  \
  [get_ports {C[6]}]  \
  [get_ports {C[5]}]  \
  [get_ports {C[4]}]  \
  [get_ports {C[3]}]  \
  [get_ports {C[2]}]  \
  [get_ports {C[1]}]  \
  [get_ports {C[0]}]  \
  [get_ports {D[7]}]  \
  [get_ports {D[6]}]  \
  [get_ports {D[5]}]  \
  [get_ports {D[4]}]  \
  [get_ports {D[3]}]  \
  [get_ports {D[2]}]  \
  [get_ports {D[1]}]  \
  [get_ports {D[0]}] ] -to [list \
  [get_ports {Y[10]}]  \
  [get_ports {Y[9]}]  \
  [get_ports {Y[8]}]  \
  [get_ports {Y[7]}]  \
  [get_ports {Y[6]}]  \
  [get_ports {Y[5]}]  \
  [get_ports {Y[4]}]  \
  [get_ports {Y[3]}]  \
  [get_ports {Y[2]}]  \
  [get_ports {Y[1]}]  \
  [get_ports {Y[0]}] ]
set_clock_gating_check -setup 0.0 
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[7]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[6]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[5]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[4]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[3]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[2]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[1]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {A[0]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[7]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[6]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[5]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[4]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[3]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[2]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[1]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {B[0]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[7]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[6]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[5]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[4]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[3]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[2]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[1]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {C[0]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[7]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[6]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[5]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[4]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[3]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[2]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[1]}]
set_driving_cell -lib_cell BUFX2 -library slow -pin "Y" [get_ports {D[0]}]
set_wire_load_mode "enclosed"
