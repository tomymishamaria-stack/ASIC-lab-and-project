database -open waves -vcd -into vcd/simulation.vcd
probe -create tb_top -depth all -all
run
exit
