# ==========================================================================
# Cadence Genus Automation Script for PPA Analysis (Updated Directory Structure)
# ==========================================================================

# 1. Setup Output Directory
set report_dir "./reports_24BVD1041"
file mkdir $report_dir

# 2. Define Configurations
# Mapping: Architecture -> {Folder_Name RTL_Filename SDC_Filename Top_Module_Name}
# PLACEHOLDER: Fill in the exact filenames and top module names for the pipelined and area-optimized designs.
array set configs {
    "Normal"        {"fir" "fir_4tap.v" "fir_4tap.sdc" "fir_4tap"}
    "AreaOptimized"     {"fir_area_optimized" "fir_4tap_shared_mult.v" "fir_4tap_shared_mult.sdc" "fir_4tap_shared_mult"}
    "Pipelined" {"fir_piplined" "fir_4tap_pipelined.v" "fir_4tap_pipelined.sdc" "fir_4tap_pipelined"}
}

set architectures [list "Normal" "AreaOptimized" "Pipelined"]
set tech_nodes [list "45nm" "90nm" "180nm"]
set corners [list "slow" "fast" "typical"]

# ==========================================================================
# 3. Execution Loops
# ==========================================================================

foreach arch $architectures {
    # Extract configuration details for the current architecture
    set folder_name [lindex $configs($arch) 0]
    set rtl_file    [lindex $configs($arch) 1]
    set sdc_file    [lindex $configs($arch) 2]
    set top_module  [lindex $configs($arch) 3]
    
    foreach node $tech_nodes {
        foreach corner $corners {
            
            puts "========================================================"
            puts " Starting Synthesis: $arch | Node: $node | Corner: $corner"
            puts "========================================================"

            # --- A. Define Library Path ---
            # PLACEHOLDER: Update this path to where the GPDK/TSMC standard cell libraries 
            # are located on the cad312vitcc server. 
            # Example: /home/install/foundry/${node}/${corner}.lib
            set lib_file "/home/install/FOUNDRY/digital/${node}/dig/lib/${corner}.lib"
            
            set_db library $lib_file

            # --- B. Read and Elaborate RTL ---
            # Reads from the specific subfolder (e.g., ./fir/fir_4tap.v)
            read_hdl ./${folder_name}/${rtl_file}
            elaborate $top_module

            # --- C. Read Constraints ---
            read_sdc ./${folder_name}/${sdc_file}

            # --- D. Synthesis ---
            syn_generic
            syn_map
            syn_opt

            # --- E. Report Generation ---
            set run_name "${arch}_${node}_${corner}"
            
            report_area > ${report_dir}/${run_name}_area.rpt
            report_power > ${report_dir}/${run_name}_power.rpt
            report_timing > ${report_dir}/${run_name}_timing.rpt

            write_hdl > ${report_dir}/${run_name}_netlist.v
            write_sdc > ${report_dir}/${run_name}_out.sdc

            # --- F. Clean Database ---
            # Clears the Genus database so the next loop starts fresh
            delete_obj [get_db designs *]
            
            puts "Finished $run_name. Reports saved to $report_dir"
        }
    }
}

puts "All 27 synthesis runs completed successfully!"
