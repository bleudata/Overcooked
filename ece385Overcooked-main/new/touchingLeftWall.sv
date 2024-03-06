//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: touchingLeftWall.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Takes penguin's current coordinates to determine if it is touching
// any walls to the left of it.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module touchingLeftWall(input logic [9:0] penguinX, penguinY,
                    output logic touchingLeftWallFlag,
                    output logic [9:0] nearestCounterX, nearestCounterY);
    always_comb begin
        touchingLeftWallFlag = 1'b0;
        if (penguinX <= 60) begin
            touchingLeftWallFlag = 1'b1;
            nearestCounterX = 10'd20;
            if (penguinY < 140) begin
                nearestCounterY = 140;
            end else if (penguinY >= 300) begin 
                nearestCounterY = 340;
            end else if (penguinY == 240) begin
                nearestCounterY = 260;
            end else if ((penguinY >= 140) && (penguinY <= 160)) begin
                nearestCounterY = 180;
            end else if ((penguinY % 40) > 20) begin
                nearestCounterY = penguinY - (penguinY % 40) + 20;
            end else if ((penguinY % 40) == 20) begin
                nearestCounterY = penguinY;
            end else if ((penguinY % 40) == 0) begin
                nearestCounterY = penguinY - 20;
            end else begin
                nearestCounterY = penguinY - (penguinY % 40) + 20;
            end
        // accessing the rightmost middle counter
        end else if ((penguinX == 380) && (penguinY >= 180) && (penguinY <= 220)) begin
            touchingLeftWallFlag = 1'b1;
            nearestCounterX = 10'd340;
            nearestCounterY = 10'd220;
        end else begin 
            touchingLeftWallFlag = 1'b0;
            nearestCounterY = 10'd0;
            nearestCounterX = 10'd0;
        end
    end
endmodule