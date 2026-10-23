#!/bin/csh
mkdir -p worklib
ncvlog -work worklib adder4.v tb_adder4.v
ncelab -access +rwc worklib.tb_adder4
ncsim -input sim.tcl worklib.tb_adder4
