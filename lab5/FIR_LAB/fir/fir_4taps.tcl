set TOP_MODULE "fir_4tap"

# Define nodes and corners lists
set nodes {180nm 90nm 45nm}
set corners {slow typical fast}

# Define search paths for each node
array set lib_search_path {
    180nm /home/install/FOUNDRY/digital/180nm/dig/lib
    90nm  /home/install/FOUNDRY/digital/90nm/dig/lib
    45nm  /home/install/FOUNDRY/digital/45nm/dig/lib
}

# Define corner library files
array set lib_files {
    180nm,slow    slow.lib
    180nm,typical typical.lib
    180nm,fast    fast.lib
    90nm,slow     slow.lib
    90nm,typical  typical.lib
    90nm,fast     fast.lib
    45nm,slow     slow.lib
    45nm,typical  typical.lib
    45nm,fast     fast.lib
}

# Outer loop: Technology Nodes
foreach node $nodes {
    # Inner loop: Operating Corners
    foreach corner $corners {
        
        puts "=================================================="
        puts " Starting Synthesis for Node: $node | Corner: $corner"
        puts "=================================================="

        # Clear design database and clear loaded library attributes
        catch { rm designs/* }
        catch { set_db library {} }

        # Define dynamic output directory
        set outdir "output/${node}/${corner}"
        file mkdir "${outdir}/netlist"
        file mkdir "${outdir}/constraints"
        file mkdir "${outdir}/reports"

        # Load specific technology libraries for current loop iteration
        set_db init_lib_search_path $lib_search_path($node)
        read_libs $lib_files($node,$corner)

        # Read Design Files and Elaborate
        read_hdl {DFF.v fir_4tap.v}
        elaborate $TOP_MODULE
        read_sdc fir_4tap.sdc

        # Set Synthesis Efforts
        set_db syn_generic_effort medium
        set_db syn_map_effort medium
        set_db syn_opt_effort medium

        # Run Synthesis Steps
        syn_generic
        write_hdl > ${outdir}/netlist/${TOP_MODULE}_generic.v

        syn_map
        write_hdl > ${outdir}/netlist/${TOP_MODULE}_mapped.v

        syn_opt
        write_hdl > ${outdir}/netlist/${TOP_MODULE}_opt.v

        # Export Constraints and Corner-Specific Reports
        write_sdc > ${outdir}/constraints/${TOP_MODULE}_synth.sdc

        report_timing > ${outdir}/reports/${TOP_MODULE}_timing.rpt
        report_power  > ${outdir}/reports/${TOP_MODULE}_power.rpt
        report_area   > ${outdir}/reports/${TOP_MODULE}_area.rpt
        report_gates  > ${outdir}/reports/${TOP_MODULE}_gates.rpt
        report_qor    > ${outdir}/reports/${TOP_MODULE}_qor.rpt

        puts "Completed run for: $node / $corner"
    }
}

puts "All 9 synthesis runs completed successfully!"
exit
