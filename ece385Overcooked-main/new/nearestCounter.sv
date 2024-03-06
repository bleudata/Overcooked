//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: nearestCounter.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Outputs the coordinates of the nearest counter.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module nearestCounter (
    input logic [9:0] penguinX, penguinY,
    input logic touchingWallFlag,
    input logic [1:0] wallIndex,
    output logic [9:0] nearestCounterX, nearestCounterY
);

    always_comb begin
        if (!touchingWallFlag) begin
            nearestCounterX = 10'dF;
            nearestCounterY = 10'dF;
        end else begin
            if (wallIndex == 2'b10) begin
                nearestCounterX = (penguinX + 20) - ((penguinX - 20) % 40);
                nearestCounterY = 100;
            end
        end
    end
endmodule