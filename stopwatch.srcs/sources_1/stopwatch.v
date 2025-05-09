`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/04/01 14:43:47
// Design Name: 
// Module Name: stopwatch
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module stopwatch(
    input wire clk,              // 50MHz clock input
    input wire rst_n,           // Active low reset
    input wire start_stop,      // Start/Stop control
    input wire clear,           // Clear/Reset the counter
    output reg [5:0] seg_sel,   // Segment display selector
    output reg [7:0] seg_led    // Segment display LED control
);

    // Internal signals for time counting
    reg running;                // Stopwatch running status
    reg [19:0] ms_counter;      // Counter for generating 10ms tick
    wire ms_tick;               // 10ms tick signal
    
    // Button debounce
    reg [1:0] start_stop_r;     // Register for start/stop button
    reg [1:0] clear_r;          // Register for clear button
    wire start_stop_posedge;    // Positive edge of start/stop button
    wire clear_posedge;         // Positive edge of clear button
    
    // BCD counters
    reg [3:0] msec_low;        // 10ms counter (0-9)
    reg [3:0] msec_high;       // 100ms counter (0-9)
    reg [3:0] sec_low;         // seconds counter (0-9)
    reg [3:0] sec_high;        // 10 seconds counter (0-5)
    reg [3:0] min_low;         // minutes counter (0-9)
    reg [3:0] min_high;        // 10 minutes counter (0-5)
    
    // Display scanning
    reg [2:0] scan_cnt;        // Counter for display scanning
    reg [3:0] digit_val;       // Current digit value to display
    reg [16:0] scan_timer;     // Timer for display scanning
    
    // Button edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            start_stop_r <= 2'b00;
            clear_r <= 2'b00;
        end
        else begin
            start_stop_r <= {start_stop_r[0], start_stop};
            clear_r <= {clear_r[0], clear};
        end
    end
    
    assign start_stop_posedge = start_stop_r[0] && !start_stop_r[1];
    assign clear_posedge = clear_r[0] && !clear_r[1];
    
    // Generate 10ms tick from 50MHz clock
    // 50MHz = 50,000,000 Hz
    // For 10ms we need: 50,000,000 * 0.01 = 500,000 cycles
    assign ms_tick = (ms_counter == 20'd499_999);
    
    // Control running state with edge detection
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            running <= 1'b0;
        else if (clear_posedge)
            running <= 1'b0;
        else if (start_stop_posedge)
            running <= ~running;
    end
    
    // 10ms counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            ms_counter <= 20'd0;
        else if (running) begin
            if (ms_tick)
                ms_counter <= 20'd0;
            else
                ms_counter <= ms_counter + 1'b1;
        end
    end
    
    // Time counting logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            msec_low <= 4'd0;
            msec_high <= 4'd0;
            sec_low <= 4'd0;
            sec_high <= 4'd0;
            min_low <= 4'd0;
            min_high <= 4'd0;
        end
        else if (clear_posedge) begin
            msec_low <= 4'd0;
            msec_high <= 4'd0;
            sec_low <= 4'd0;
            sec_high <= 4'd0;
            min_low <= 4'd0;
            min_high <= 4'd0;
        end
        else if (running && ms_tick) begin
            if (msec_low == 4'd9) begin
                msec_low <= 4'd0;
                if (msec_high == 4'd9) begin
                    msec_high <= 4'd0;
                    if (sec_low == 4'd9) begin
                        sec_low <= 4'd0;
                        if (sec_high == 4'd5) begin
                            sec_high <= 4'd0;
                            if (min_low == 4'd9) begin
                                min_low <= 4'd0;
                                if (min_high == 4'd5)
                                    min_high <= 4'd0;
                                else
                                    min_high <= min_high + 1'b1;
                            end
                            else
                                min_low <= min_low + 1'b1;
                        end
                        else
                            sec_high <= sec_high + 1'b1;
                    end
                    else
                        sec_low <= sec_low + 1'b1;
                end
                else
                    msec_high <= msec_high + 1'b1;
            end
            else
                msec_low <= msec_low + 1'b1;
        end
    end
    
    // Display scanning counter
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            scan_timer <= 17'd0;
        else
            scan_timer <= scan_timer + 1'b1;
    end
    
    // Scan counter update (slower scanning)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            scan_cnt <= 3'd0;
        else if (scan_timer == 17'd49_999) // Update every 1ms (50MHz/1000)
            scan_cnt <= scan_cnt + 1'b1;
    end
    
    // Digit multiplexing
    always @(*) begin
        case (scan_cnt)
            3'd0: begin
                seg_sel = 6'b111110;  // Enable digit 0 (msec_low)
                digit_val = msec_low;
            end
            3'd1: begin
                seg_sel = 6'b111101;  // Enable digit 1 (msec_high)
                digit_val = msec_high;
            end
            3'd2: begin
                seg_sel = 6'b111011;  // Enable digit 2 (sec_low)
                digit_val = sec_low;
            end
            3'd3: begin
                seg_sel = 6'b110111;  // Enable digit 3 (sec_high)
                digit_val = sec_high;
            end
            3'd4: begin
                seg_sel = 6'b101111;  // Enable digit 4 (min_low)
                digit_val = min_low;
            end
            3'd5: begin
                seg_sel = 6'b011111;  // Enable digit 5 (min_high)
                digit_val = min_high;
            end
            default: begin
                seg_sel = 6'b111111;  // All off
                digit_val = 4'd0;
            end
        endcase
    end
    
    // 7-segment decoder with decimal point
    always @(*) begin
        case (digit_val)
            4'd0: seg_led = 8'b11000000;  // 0
            4'd1: seg_led = 8'b11111001;  // 1
            4'd2: seg_led = 8'b10100100;  // 2
            4'd3: seg_led = 8'b10110000;  // 3
            4'd4: seg_led = 8'b10011001;  // 4
            4'd5: seg_led = 8'b10010010;  // 5
            4'd6: seg_led = 8'b10000010;  // 6
            4'd7: seg_led = 8'b11111000;  // 7
            4'd8: seg_led = 8'b10000000;  // 8
            4'd9: seg_led = 8'b10010000;  // 9
            default: seg_led = 8'b11111111; // All segments off
        endcase
        
        // Add decimal point after seconds
        if (scan_cnt == 3'd2)  // After seconds display
            seg_led[7] = 1'b0;  // Turn on decimal point
    end

endmodule
