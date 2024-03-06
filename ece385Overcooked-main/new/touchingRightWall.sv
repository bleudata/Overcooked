//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: touchingRightWall.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Takes penguin's current coordinates to determine if it is touching
// any walls to the right of it.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module touchingRightWall(input logic [9:0] penguinX, penguinY,
                    output logic touchingRightWallFlag,
                    output logic [9:0] nearestCounterX, nearestCounterY);
    always_comb begin
        touchingRightWallFlag = 1'b0;
        if (penguinX >= 540) begin
            touchingRightWallFlag = 1'b1;
            nearestCounterX = 10'd580;
            if (penguinY < 140) begin
                nearestCounterY = 140;
            end else if (penguinY >= 300) begin 
                nearestCounterY = 340;
            end else if ((penguinY % 40) > 20) begin
                nearestCounterY = penguinY - (penguinY % 40) + 20;
            end else if ((penguinY % 40) == 20) begin
                nearestCounterY = penguinY;
            end else if ((penguinY % 40) == 0) begin
                nearestCounterY = penguinY - 20;
            end else begin
                nearestCounterY = penguinY - (penguinY % 40) + 20;
            end
        end else begin 
            touchingRightWallFlag = 1'b0;
            nearestCounterY = 10'd0;
            nearestCounterX = 10'd0;
        end
    end
endmodule