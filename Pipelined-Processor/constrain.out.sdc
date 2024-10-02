


set_time_format -unit ns -decimal_places 3

# Define the main clock from the input pin
create_clock -name clk -period 14.000 -waveform { 0.000 7.000 } [get_ports {clock}]

# Define the 1 Hz generated clock from clockDevider
create_generated_clock -name clk1HZ -source [get_ports {CLOCK_50}] -divide_by 50000000 [get_pins *clk1HZ*]

# Set input and output delays
set_input_delay  -clock clk 1.000 [get_ports SW[*]]
set_output_delay -clock clk 1.000 [get_ports {HEX0[*] HEX1[*] HEX2[*] HEX3[*] HEX4[*] HEX5[*]}]


set_false_path -from [get_pins {clockDevider|clk1HZ}]
