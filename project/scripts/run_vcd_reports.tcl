set TOP_MODULE "top"

# 1. Setup Library Search Paths and Load Library
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib
read_libs slow.lib

# 2. Read Synthesized Gate-Level Netlist
read_netlist output/netlist/${TOP_MODULE}_opt.v

# 3. Read SDC Constraints
read_sdc constraints/top.sdc

# 4. Create Output Folder Structure
file mkdir output/reports

puts "--------------------------------------------------------------------"
puts "INFO: Loading Top-Level VCD for Complete Chip Annotation..."
puts "--------------------------------------------------------------------"

if {[catch {read_vcd vcd/tb_top.vcd} err]} {
    puts "ERROR: Failed to read top-level VCD. Reason: $err"
    exit 1
}

# Generate top-level system power report
report_power > output/reports/tb_top_vcd_power.rpt
puts "--> Generated top-level report: output/reports/tb_top_vcd_power.rpt"

# Exact verified sub-instances from your design hierarchy
set sub_instances {
    u_csr
    u_statistics
}

puts "\n--------------------------------------------------------------------"
puts "INFO: Generating Unique Sub-Instance Power Reports..."
puts "--------------------------------------------------------------------"

foreach inst $sub_instances {
    # Strip the leading 'u_' for a clean report filename (e.g., u_csr -> csr_vcd_power.rpt)
    set clean_name [string range $inst 2 end]
    set report_file "output/reports/${clean_name}_vcd_power.rpt"
    
    if {[catch {report_power -inst $inst > $report_file} err]} {
        puts "WARNING: Could not generate report for instance '$inst': $err"
    } else {
        puts "--> Successfully generated: $report_file"
    }
}

puts "--------------------------------------------------------------------"
puts "INFO: All Power Reports Generated Successfully under output/reports/!"
puts "--------------------------------------------------------------------"
exit
