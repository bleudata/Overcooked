//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: timer.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Generates RGB values for the timer and the score by keeping track
// of time and reading the score from the other modules. Instantiates fontRom to
// draw the numbers.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module timer (
    input logic Reset, vsync,
    input logic [7:0] keycode,
    input logic [9:0] DrawX, DrawY,
    input logic [3:0] score,
    output logic StartFlag, EndFlag,
    output logic [13:0] timerValue,
    output logic [3:0] minuteOnes,
    output logic [3:0] secondTens, secondOnes,
    output logic [3:0] timerRed, timerGreen, timerBlue,
    output logic [3:0] scoreRed, scoreGreen, scoreBlue
);
    logic [13:0] timerMiddle;
    assign timerValue = timerMiddle;
    always_ff @ (posedge vsync or posedge Reset) begin
        if (Reset) begin
            StartFlag = 0;
            EndFlag = 0;
            timerMiddle = 10800;
        end else if (StartFlag) begin
            timerMiddle = timerMiddle - 1;
            if (timerMiddle == 0) begin
                // reached end screen
                EndFlag = 1;
                StartFlag = 0;
                timerMiddle = 10800;
            end
        end else if ((keycode != 0) && (EndFlag != 1)) begin
            // denotes that we are at the start screen
            StartFlag = 1;
            EndFlag = 0;
        end else begin
            StartFlag = StartFlag;
            EndFlag = EndFlag;
            timerMiddle = timerMiddle;
        end
    end

    logic [8:0] address;
    logic [15:0] data;

    always_comb begin
        minuteOnes = timerMiddle / 3600;
        secondTens = ((timerMiddle/60) % 60 )/10;
        secondOnes = ((timerMiddle/60) % 60 ) % 10;

        if ((DrawX >= 16) && (DrawX <= 32) && (DrawY >= 444) && (DrawY <= 476)) begin 
            // draw score tens digit
            address = (score/10)*32 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 16)]) begin
                scoreRed = 4'hF;
                scoreGreen = 4'hF;
                scoreBlue = 4'hF;
            end else begin
                scoreRed = 4'h0;
                scoreGreen = 4'h0;
                scoreBlue = 4'h0;
            end
        end else if ((DrawX >= 32) && (DrawX <= 48) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw score ones digit
            address = (score % 10)*32 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 32)]) begin
                scoreRed = 4'hF;
                scoreGreen = 4'hF;
                scoreBlue = 4'hF;
            end else begin
                scoreRed = 4'h0;
                scoreGreen = 4'h0;
                scoreBlue = 4'h0;
            end
        end else if((DrawX >= 544) && (DrawX <= 560) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw zero
            address = DrawY - 444 - 1;
            if (data[15 - (DrawX - 544)]) begin
                timerRed = 4'hF;
                timerGreen = 4'hF;
                timerBlue = 4'hF;
            end else begin
                timerRed = 4'h0;
                timerGreen = 4'h0;
                timerBlue = 4'h0;
            end
        end else if ((DrawX >= 560) && (DrawX <= 576) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw minuteOnes
            address = minuteOnes * 32 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 560)]) begin
                timerRed = 4'hF;
                timerGreen = 4'hF;
                timerBlue = 4'hF;
            end else begin
                timerRed = 4'h0;
                timerGreen = 4'h0;
                timerBlue = 4'h0;
            end
        end else if ((DrawX >= 576) && (DrawX <= 592) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw colon
            address = 320 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 576)]) begin
                timerRed = 4'hF;
                timerGreen = 4'hF;
                timerBlue = 4'hF;
            end else begin
                timerRed = 4'h0;
                timerGreen = 4'h0;
                timerBlue = 4'h0;
            end
        end else if ((DrawX >= 592) && (DrawX <= 608) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw secondTens
            address = secondTens * 32 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 592)]) begin
                timerRed = 4'hF;
                timerGreen = 4'hF;
                timerBlue = 4'hF;
            end else begin
                timerRed = 4'h0;
                timerGreen = 4'h0;
                timerBlue = 4'h0;
            end
        end else if ((DrawX >= 608) && (DrawX <= 624) && (DrawY >= 444) && (DrawY <= 476)) begin
            // draw secondOnes
            address = secondOnes * 32 + DrawY - 444 - 1;
            if (data[15 - (DrawX - 608)]) begin
                timerRed = 4'hF;
                timerGreen = 4'hF;
                timerBlue = 4'hF;
            end else begin
                timerRed = 4'h0;
                timerGreen = 4'h0;
                timerBlue = 4'h0;
            end
        end else begin
            address = 0;
            timerRed = 0;
            timerGreen = 0;
            timerBlue = 0;
        end
    end

    font_rom font_rom (.addr(address), .data(data));

endmodule