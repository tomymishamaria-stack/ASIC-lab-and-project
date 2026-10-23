# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.14-s082_1 on Fri Oct 16 12:14:24 IST 2026

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design design_top

create_clock -name "clk" -period 10.0 -waveform {0.0 5.0} [get_ports clk]
set_clock_transition 0.1 [get_clocks clk]
set_false_path -from [get_ports rst_n]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {a[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {b[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[7]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[6]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[5]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[4]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[3]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[2]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[1]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {c[0]}]
set_input_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports sel]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[8]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[7]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[6]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[5]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[4]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[3]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[2]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[1]}]
set_output_delay -clock [get_clocks clk] -add_delay 1.0 [get_ports {y[0]}]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.2 [get_clocks clk]
set_clock_uncertainty -hold 0.2 [get_clocks clk]
