vlib work
vlog RAM.v SPI_tb.v SPI.v SPI_SLAVE.v 
vsim -voptargs=+acc work.SPI_tb
add wave *
add wave -position insertpoint  \
sim:/SPI_tb/DUT/tx_valid \
sim:/SPI_tb/DUT/rx_valid \
sim:/SPI_tb/DUT/tx_data \
sim:/SPI_tb/DUT/rx_data\
sim:/SPI_tb/DUT/M2/din \
sim:/SPI_tb/DUT/M2/dout \
sim:/SPI_tb/DUT/M2/mem \
sim:/SPI_tb/DUT/M2/write_address \
sim:/SPI_tb/DUT/M2/read_address \
sim:/SPI_tb/DUT/M1/out_reg \
sim:/SPI_tb/DUT/M1/counter_1
run -all
#quit -sim
