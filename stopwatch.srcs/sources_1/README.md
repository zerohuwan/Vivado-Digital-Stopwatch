# FPGA Digital Stopwatch

A digital stopwatch implementation for FPGA using Verilog HDL.

## Features

- 10ms precision timing
- Time range: 00:00.00 ~ 59:59.90
- Functions:
  - Start/Stop
  - Clear/Reset
  - 6-digit display (MM:SS.CC format)
- 50MHz clock input
- 6-digit 7-segment display output

## Pin Assignments

### Inputs
- `clk`: R4 (50MHz system clock)
- `rst_n`: U2 (Active low reset)
- `start_stop`: T1 (Start/Stop button)
- `clear`: U1 (Clear/Reset button)

### Outputs
- `seg_sel[5:0]`: 6-digit display selector
  - seg_sel[0]: J15
  - seg_sel[1]: H17
  - seg_sel[2]: H13
  - seg_sel[3]: G17
  - seg_sel[4]: H18
  - seg_sel[5]: G18

- `seg_led[7:0]`: 7-segment display control
  - seg_led[0]: H15
  - seg_led[1]: G16
  - seg_led[2]: L13
  - seg_led[3]: G15
  - seg_led[4]: K13
  - seg_led[5]: G13
  - seg_led[6]: H14
  - seg_led[7]: J14

## Usage

1. Press the start/stop button to begin timing
2. Press again to pause
3. Press the clear button to reset the counter
4. Display format: MM:SS.CC (Minutes:Seconds.Centiseconds)

## Implementation Details

- Clock frequency: 50MHz
- Timing precision: 10ms
- Display refresh rate: 1kHz
- Button debouncing implemented
- Edge detection for control signals 