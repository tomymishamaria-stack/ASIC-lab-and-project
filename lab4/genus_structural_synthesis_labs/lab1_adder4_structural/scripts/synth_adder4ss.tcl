set TOP_MODULE "rca_4bit"

# 1. Setup Library and HDL Search Paths
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
read_libs slow.lib

# 2. Read HDL Files & Elaborate
read_hdl {full_adder.v rca_4bit.v}
elaborate $TOP_MODULE

# 3. Read SDC Constraints
read_sdc rca_4bit.sdc

# 4. Create Output Folder Structure
file mkdir output/netlist
file mkdir output/constraints
file mkdir output/reports

# Set Effort Levels
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

# Stage 1: Generic Synthesis
syn_generic
write_hdl > output/netlist/${TOP_MODULE}_generic.v
report_timing > output/reports/${TOP_MODULE}_generic_timing.rpt
report_power > output/reports/${TOP_MODULE}_generic_power.rpt
report_area > output/reports/${TOP_MODULE}_generic_area.rpt
report_qor > output/reports/${TOP_MODULE}_generic_qor.rpt

# Stage 2: Mapped Synthesis
syn_map
write_hdl > output/netlist/${TOP_MODULE}_mapped.v
report_timing > output/reports/${TOP_MODULE}_mapped_timing.rpt
report_power > output/reports/${TOP_MODULE}_mapped_power.rpt
report_area > output/reports/${TOP_MODULE}_mapped_area.rpt
report_qor > output/reports/${TOP_MODULE}_mapped_qor.rpt

# Stage 3: Optimized Synthesis
syn_opt
write_hdl > output/netlist/${TOP_MODULE}_opt.v
write_sdc > output/constraints/${TOP_MODULE}_synth.sdc

# Final Reports
report_timing > output/reports/${TOP_MODULE}_opt_timing.rpt
report_power > output/reports/${TOP_MODULE}_opt_power.rpt
report_area > output/reports/${TOP_MODULE}_opt_area.rpt
report_gates > output/reports/${TOP_MODULE}_opt_gates.rpt
report_qor > output/reports/${TOP_MODULE}_opt_qor.rpt

puts "--- Synthesis completed successfully! Check output/ directory for netlists & reports ---"
