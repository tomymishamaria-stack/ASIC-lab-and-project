# Define your clock (adjust period and port name to match your design)
create_clock -name clk -period 10.0 [get_ports clk]

# Your existing constraints
set_max_delay 5.0 -from [all_inputs] -to [all_outputs]
set_driving_cell -lib_cell BUFX2 [all_inputs]
set_load 5.0 [all_outputs]
