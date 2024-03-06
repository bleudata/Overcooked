//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: touchingUpWall.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Takes penguin's current coordinates to determine if it is touching
// any walls above it.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module touchingUpWall(input logic [9:0] penguinX, penguinY,
                    output logic touchingUpWallFlag,
                    output logic [9:0] nearestCounterX, nearestCounterY);
    always_comb begin
        touchingUpWallFlag = 1'b0;
        // touching top counters (entire row)
        if (penguinY <= 140) begin
            touchingUpWallFlag = 1'b1;
            // top left y coordinate of the top counters
            // check bounds for this
            nearestCounterY = 10'd100;
            if ((penguinX % 40) > 20) begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end else if ((penguinX % 40) == 20) begin
                nearestCounterX = penguinX;
            end else if ((penguinX % 40) == 0) begin
                nearestCounterX = penguinX - 20;
            end else begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end
        // touching middle counters from the bottom
        end else if ((penguinY == 240) && (penguinX >= 60) && (penguinX <= 370)) begin
            touchingUpWallFlag = 1'b1;
            // top left y coordinate of the middle counters
            nearestCounterY = 10'd220;
            if (penguinX >= 340) begin 
                nearestCounterX = 340;
            end else if ((penguinX % 40) > 20) begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end else if ((penguinX % 40) == 20) begin
                nearestCounterX = penguinX;
            end else if ((penguinX % 40) == 0) begin
                nearestCounterX = penguinX - 20;
            end else begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end
        end else begin 
            touchingUpWallFlag = 1'b0;
            nearestCounterY = 10'd0;
            nearestCounterX = 10'd0;
        end
    end
endmodule