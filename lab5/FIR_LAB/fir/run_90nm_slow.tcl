puts ""
puts "============================================================"
puts " RUNNING 90nm - SLOW"
puts "============================================================"

set TOP_MODULE "fir_4tap"
set RTL_FILE "fir_4tap.v"
set SDC_FILE "fir_4tap.sdc"

# Set library search path and load target library
set_db init_lib_search_path {/home/install/FOUNDRY/digital/90nm/dig/lib}
set_db library {slow.lib}

# Read RTL and Elaborate
read_hdl $RTL_FILE
elaborate $TOP_MODULE

# Read SDC Constraints
read_sdc $SDC_FILE

# Synthesis Settings
set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium

puts "Running syn_generic..."
syn_generic
write_hdl > output/90nm/slow/netlist/${TOP_MODULE}_generic.v

puts "Running syn_map..."
syn_map
write_hdl > output/90nm/slow/netlist/${TOP_MODULE}_mapped.v

puts "Running syn_opt..."
syn_opt
write_hdl > output/90nm/slow/netlist/${TOP_MODULE}_opt.v

puts "Writing SDC..."
write_sdc > output/90nm/slow/constraints/${TOP_MODULE}_synth.sdc

# Generating Reports
puts "Generating timing report..."
report_timing > output/90nm/slow/reports/${TOP_MODULE}_timing.rpt

puts "Generating power report..."
report_power > output/90nm/slow/reports/${TOP_MODULE}_power.rpt

puts "Generating area report..."
report_area > output/90nm/slow/reports/${TOP_MODULE}_area.rpt

puts "Generating gate report..."
report_gates > output/90nm/slow/reports/${TOP_MODULE}_gates.rpt

puts "Generating QoR report..."
report_qor > output/90nm/slow/reports/${TOP_MODULE}_qor.rpt

puts "============================================================"
puts " 90nm - SLOW COMPLETED"
puts "============================================================"
exit
