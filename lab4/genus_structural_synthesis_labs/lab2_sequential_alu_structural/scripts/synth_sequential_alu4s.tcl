###########################################################################
# CADENCE GENUS SYNTHESIS SCRIPT
# 4-BIT SEQUENTIAL ALU
#
# Generic -> Mapped -> Optimized
###########################################################################


###############################
# PROJECT DIRECTORIES
###############################

# Automatically find the directory containing this Tcl script
set SCRIPT_DIR [file dirname [file normalize [info script]]]

# Project directory = one level above scripts/
set PROJECT_DIR [file normalize "$SCRIPT_DIR/.."]

set RTL_DIR "$PROJECT_DIR/rtl"
set CONSTRAINT_DIR "$PROJECT_DIR/constraints"
set OUTPUT_DIR "$PROJECT_DIR/op_new"

set REPORT_DIR "$OUTPUT_DIR/reports"
set NETLIST_DIR "$OUTPUT_DIR/netlist"
set OUTPUT_SDC_DIR "$OUTPUT_DIR/constraints"
set LOG_DIR "$OUTPUT_DIR/logs"


###############################
# DESIGN CONFIGURATION
###############################

set TOP_MODULE "sequential_alu4_structural"


###############################
# TECHNOLOGY LIBRARY
###############################

set LIB_DIR "/home/install/FOUNDRY/digital/90nm/dig/lib"
set LIB_FILE "slow.lib"


###############################
# CONSTRAINT FILE
###############################

set SDC_FILE "$CONSTRAINT_DIR/sequential_alu4_constraints.sdc"


###############################
# OPTIONAL VCD
###############################

set VCD_FILE "$OUTPUT_DIR/sequential_alu4.vcd"


###############################
# RTL FILES
###############################

set RTL_FILES {
    full_adder.v
    ripple_adder4.v
    mux2_1.v
    mux4_1.v
    dff_async_reset.v
    alu4_comb_structural.v
    sequential_alu4_structural.v
}


###########################################################################
# CREATE OUTPUT DIRECTORIES
###########################################################################

file mkdir $OUTPUT_DIR
file mkdir $REPORT_DIR
file mkdir $NETLIST_DIR
file mkdir $OUTPUT_SDC_DIR
file mkdir $LOG_DIR


###########################################################################
# PRINT PROJECT INFORMATION
###########################################################################

puts ""
puts "==========================================================="
puts " GENUS SYNTHESIS STARTED"
puts "==========================================================="
puts "Script Directory : $SCRIPT_DIR"
puts "Project Directory: $PROJECT_DIR"
puts "RTL Directory : $RTL_DIR"
puts "Constraint Dir : $CONSTRAINT_DIR"
puts "Output Directory : $OUTPUT_DIR"
puts "Top Module : $TOP_MODULE"
puts "Library : $LIB_FILE"
puts "==========================================================="
puts ""


###########################################################################
# SEARCH PATHS
###########################################################################

set_db init_lib_search_path $LIB_DIR
set_db init_hdl_search_path $RTL_DIR


###########################################################################
# READ LIBRARY
###########################################################################

puts "------------------------------------------"
puts "Reading Technology Library"
puts "------------------------------------------"

read_libs $LIB_FILE


###########################################################################
# CHECK RTL FILES
###########################################################################

puts ""
puts "------------------------------------------"
puts "Checking RTL Files"
puts "------------------------------------------"

foreach rtl_file $RTL_FILES {

    set rtl_path "$RTL_DIR/$rtl_file"

    if {[file exists $rtl_path]} {

        puts "FOUND : $rtl_path"

    } else {

        puts "ERROR : RTL FILE NOT FOUND"
        puts " $rtl_path"
        error "Required RTL file is missing."
    }
}


###########################################################################
# READ RTL
###########################################################################

puts ""
puts "------------------------------------------"
puts "Reading RTL"
puts "------------------------------------------"

foreach rtl_file $RTL_FILES {

    read_hdl "$RTL_DIR/$rtl_file"
}


###########################################################################
# ELABORATE DESIGN
###########################################################################

puts ""
puts "------------------------------------------"
puts "Elaborating Design"
puts "------------------------------------------"

elaborate $TOP_MODULE


###########################################################################
# READ CONSTRAINTS
###########################################################################

puts ""
puts "------------------------------------------"
puts "Reading SDC Constraints"
puts "------------------------------------------"

if {[file exists $SDC_FILE]} {

    puts "FOUND : $SDC_FILE"
    read_sdc $SDC_FILE

} else {

    puts "ERROR : SDC FILE NOT FOUND"
    puts " $SDC_FILE"
    error "Constraint file is missing."
}


###########################################################################
# OPTIONAL VCD
###########################################################################

puts ""
puts "------------------------------------------"
puts "Checking VCD"
puts "------------------------------------------"

if {[file exists $VCD_FILE]} {

    puts "VCD Found : $VCD_FILE"
    puts "Reading Switching Activity"

    read_vcd $VCD_FILE

} else {

    puts "VCD Not Found"
    puts "Using vectorless power estimation"
}


###########################################################################
# SYNTHESIS SETTINGS
###########################################################################

set_db syn_generic_effort medium
set_db syn_map_effort medium
set_db syn_opt_effort medium


###########################################################################
# DESIGN CHECK
###########################################################################

puts ""
puts "------------------------------------------"
puts "Checking Design"
puts "------------------------------------------"

check_design -unresolved \
> "$REPORT_DIR/${TOP_MODULE}_check_design.rpt"


###########################################################################
# GENERIC SYNTHESIS
###########################################################################

puts ""
puts "==========================================================="
puts " GENERIC SYNTHESIS"
puts "==========================================================="

syn_generic

puts "Generic synthesis completed."


###############################
# GENERIC NETLIST
###############################

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_generic.v"


###############################
# GENERIC REPORTS
###############################

report_timing \
> "$REPORT_DIR/${TOP_MODULE}_generic_timing.rpt"

report_area \
> "$REPORT_DIR/${TOP_MODULE}_generic_area.rpt"

report_power \
> "$REPORT_DIR/${TOP_MODULE}_generic_power.rpt"

report_qor \
> "$REPORT_DIR/${TOP_MODULE}_generic_qor.rpt"


###########################################################################
# MAPPED SYNTHESIS
###########################################################################

puts ""
puts "==========================================================="
puts " MAPPED SYNTHESIS"
puts "==========================================================="

syn_map

puts "Mapped synthesis completed."


###############################
# MAPPED NETLIST
###############################

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_mapped.v"


###############################
# MAPPED REPORTS
###############################

report_timing \
> "$REPORT_DIR/${TOP_MODULE}_mapped_timing.rpt"

report_area \
> "$REPORT_DIR/${TOP_MODULE}_mapped_area.rpt"

report_power \
> "$REPORT_DIR/${TOP_MODULE}_mapped_power.rpt"

report_qor \
> "$REPORT_DIR/${TOP_MODULE}_mapped_qor.rpt"


###########################################################################
# OPTIMIZED SYNTHESIS
###########################################################################

puts ""
puts "==========================================================="
puts " OPTIMIZED SYNTHESIS"
puts "==========================================================="

syn_opt

puts "Optimized synthesis completed."


###############################
# OPTIMIZED NETLIST
###############################

write_hdl \
> "$NETLIST_DIR/${TOP_MODULE}_optimized.v"


###############################
# OPTIMIZED REPORTS
###############################

report_timing \
> "$REPORT_DIR/${TOP_MODULE}_optimized_timing.rpt"

report_area \
> "$REPORT_DIR/${TOP_MODULE}_optimized_area.rpt"

report_power \
> "$REPORT_DIR/${TOP_MODULE}_optimized_power.rpt"

report_qor \
> "$REPORT_DIR/${TOP_MODULE}_optimized_qor.rpt"


###########################################################################
# FINAL SDC
###########################################################################

write_sdc \
> "$OUTPUT_SDC_DIR/${TOP_MODULE}_output_constraints.sdc"


###########################################################################
# COMPLETION MESSAGE
###########################################################################

puts ""
puts ""
puts "==========================================================="
puts " GENUS SYNTHESIS COMPLETED"
puts "==========================================================="
puts ""
puts "Design : $TOP_MODULE"
puts ""
puts "Generic:"
puts " $NETLIST_DIR/${TOP_MODULE}_generic.v"
puts ""
puts "Mapped:"
puts " $NETLIST_DIR/${TOP_MODULE}_mapped.v"
puts ""
puts "Optimized:"
puts " $NETLIST_DIR/${TOP_MODULE}_optimized.v"
puts ""
puts "Reports:"
puts " $REPORT_DIR"
puts ""
puts "==========================================================="
puts " ALL STAGES COMPLETED"
puts "==========================================================="
puts ""


###########################################################################
# EXIT
###########################################################################

exit

