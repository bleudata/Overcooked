//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: pickDropSprites.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Generates the tile number we are at by reading the x and y coordinates.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module coordsToTileIndex (
    input logic [9:0] xCoordinate, yCoordinate,
    output logic [6:0] tileIndex
);
    
    logic [6:0] rowIndex, colIndex;

    assign colIndex = (xCoordinate - 20) / 40;
    assign rowIndex = (yCoordinate - 100) / 40;
    assign tileIndex = colIndex + (rowIndex * 15);

endmodule