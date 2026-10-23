# 1. Virtual Clock definition (10 ns period / 100 MHz)
create_clock -name vclk -period 10.000

# 2. Virtual Clock Quality Constraints (Jitter/Skew & Transition)
set_clock_uncertainty 0.200 [get_clocks vclk]
set_clock_transition 0.050 [get_clocks vclk]

# 3. Input and Output Delays (Referenced to Virtual Clock)
set_input_delay 1.000 -clock vclk [all_inputs]
set_output_delay 1.000 -clock vclk [all_outputs]

# 4. External Loading and Input Transition Constraints
set_input_transition 0.050 [all_inputs]
set_load 0.050 [all_outputs]
