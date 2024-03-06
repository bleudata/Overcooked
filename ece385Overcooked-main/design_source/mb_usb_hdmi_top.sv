`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zuofu Cheng
// 
// Create Date: 12/11/2022 10:48:49 AM
// Design Name: 
// Module Name: mb_usb_hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Wrapper for the block diagram. Instantiates backgroundImage_example.
//
// Dependencies: microblaze block design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
    );
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    
    assign reset_ah = reset_rtl_0;
    
    logic [9:0] penguinX, penguinY;
    logic [9:0] nearestCounterX, nearestCounterY;
    logic [3:0] tileType;
    logic [6:0] tileIndex;

    logic [2:0] heldSpriteIndex;
    logic [2:0] nearestSpriteIndex;
    logic [1:0] presentMask[1];
    logic [9:0] onionXarray[1];
    logic [9:0] onionYarray[1];
    logic [2:0] onionHeldSpriteIndex, plateHeldSpriteIndex;
    logic [3:0] score;
    
    backgroundImage_example backgroundImage_example (
	.vga_clk(clk_25MHz), .Reset(reset_ah),
    .keycode(keycode0_gpio[7:0]),
	.DrawX(drawX), .DrawY(drawY),
	.blank(vde), .vsync(vsync),
	.red, .green, .blue,
	.penguinXOut(penguinX), .penguinYOut(penguinY),
    .tileType(tileType),
    .tileIndex(tileIndex),
    .nearestCounterX(nearestCounterX), .nearestCounterY(nearestCounterY),
    .heldSpriteIndex(heldSpriteIndex), .nearestSpriteIndex(nearestSpriteIndex),
    .presentMask(presentMask), .onionXarray(onionXarray), .onionYarray(onionYarray),
    .onionHeldSpriteIndex(onionHeldSpriteIndex), .score(score),
    .plateHeldSpriteIndex(plateHeldSpriteIndex)
    );

    logic StartFlag, EndFlag;
    logic [13:0] timerValue;
    logic [3:0] minutes, secondTens, secondOnes;
    timer timer(.Reset(reset_ah), .vsync(vsync),
                .keycode(keycode0_gpio[7:0]),
                .StartFlag(StartFlag), .EndFlag(EndFlag),
                .timerValue(timerValue),
                .minuteOnes(minutes), .secondOnes(secondOnes), .secondTens(secondTens));

    //Keycode HEX drivers
    HexDriver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({{1'b0, heldSpriteIndex}, {1'b0, onionHeldSpriteIndex}, {1'b0, plateHeldSpriteIndex}, onionXarray[0][3:0]}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    HexDriver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({{1'b0, nearestSpriteIndex}, onionYarray[0][9:8], onionYarray[0][7:4], {score}}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    lab6_2 mb_block_i(
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

endmodule
