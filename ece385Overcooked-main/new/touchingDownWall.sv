//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: touchingDownWall.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Takes penguin's current coordinates to determine if it is touching
// any walls below it.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module touchingDownWall(input logic [9:0] penguinX, penguinY,
                    output logic touchingDownWallFlag,
                    output logic [9:0] nearestCounterX, nearestCounterY);
    always_comb begin
        touchingDownWallFlag = 1'b0;
        // touching bottom counters (entire row)
        if (penguinY >= 320) begin
            touchingDownWallFlag = 1'b1;
            // top left y coordinate of the bottom counters
            nearestCounterY = 10'd380;
            if ((penguinX % 40) > 20) begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end else if ((penguinX % 40) == 20) begin
                nearestCounterX = penguinX;
            end else if ((penguinX % 40) == 0) begin
                nearestCounterX = penguinX - 20;
            end else begin
                nearestCounterX = penguinX - (penguinX % 40) + 20;
            end
        // touching middle counters from above
        end else if ((penguinY == 160) && (penguinX >= 60) && (penguinX <= 370)) begin
            touchingDownWallFlag = 1'b1;
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
            touchingDownWallFlag = 1'b0;
            nearestCounterY = 10'd0;
            nearestCounterX = 10'd0;
        end
    end
endmodule