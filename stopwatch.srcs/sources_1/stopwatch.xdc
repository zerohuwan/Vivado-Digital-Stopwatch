# Clock and Reset
set_property -dict {PACKAGE_PIN R4 IOSTANDARD LVCMOS33} [get_ports clk]
set_property -dict {PACKAGE_PIN U2 IOSTANDARD LVCMOS33} [get_ports rst_n]

# Buttons
set_property -dict {PACKAGE_PIN T1 IOSTANDARD LVCMOS33} [get_ports start_stop]
set_property -dict {PACKAGE_PIN U1 IOSTANDARD LVCMOS33} [get_ports clear]

# Segment Display Select
set_property -dict {PACKAGE_PIN J15 IOSTANDARD LVCMOS33} [get_ports {seg_sel[0]}]
set_property -dict {PACKAGE_PIN H17 IOSTANDARD LVCMOS33} [get_ports {seg_sel[1]}]
set_property -dict {PACKAGE_PIN H13 IOSTANDARD LVCMOS33} [get_ports {seg_sel[2]}]
set_property -dict {PACKAGE_PIN G17 IOSTANDARD LVCMOS33} [get_ports {seg_sel[3]}]
set_property -dict {PACKAGE_PIN H18 IOSTANDARD LVCMOS33} [get_ports {seg_sel[4]}]
set_property -dict {PACKAGE_PIN G18 IOSTANDARD LVCMOS33} [get_ports {seg_sel[5]}]

# Segment Display LED
set_property -dict {PACKAGE_PIN H15 IOSTANDARD LVCMOS33} [get_ports {seg_led[0]}]
set_property -dict {PACKAGE_PIN G16 IOSTANDARD LVCMOS33} [get_ports {seg_led[1]}]
set_property -dict {PACKAGE_PIN L13 IOSTANDARD LVCMOS33} [get_ports {seg_led[2]}]
set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports {seg_led[3]}]
set_property -dict {PACKAGE_PIN K13 IOSTANDARD LVCMOS33} [get_ports {seg_led[4]}]
set_property -dict {PACKAGE_PIN G13 IOSTANDARD LVCMOS33} [get_ports {seg_led[5]}]
set_property -dict {PACKAGE_PIN H14 IOSTANDARD LVCMOS33} [get_ports {seg_led[6]}]
set_property -dict {PACKAGE_PIN J14 IOSTANDARD LVCMOS33} [get_ports {seg_led[7]}]

# Clock constraints
create_clock -period 20.000 -name sys_clk -waveform {0.000 10.000} [get_ports clk] 