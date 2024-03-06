//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: tileROM.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Mapping for the tile types
// 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: Tiles: counter, stove, trash, floor
//                             vents, plates, cutting board, onion crate, tomato crate
//                             mushroom crate, sink
//////////////////////////////////////////////////////////////////////////////////

// indexing for tile type:
// Cutting Board Counter: 4'd0
// Counter:               4'd1
// Onion Crate:           4'd2
// Stove:                 4'd3
// Tomato Crate:          4'd4
// Mushroom Crate:        4'd5
// Trash:                 4'd6
// Floor:                 4'd7
// Vents:                 4'd8
// Plate Counter:         4'd9
// Sink:                  4'd10

module tileROM (
    input logic [6:0] tileIndex,
    output logic [3:0] tileType
);

    parameter ADDR_WIDTH = 7;
    parameter DATA_WIDTH =  4;
	logic [ADDR_WIDTH-1:0] addr_reg;

    assign tileType = ROM[tileIndex];

    parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {

        // start at top left corner
        // row 0
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd2, // Onion Crate
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd3, // Stove
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter

        // row 1
        4'd1, // Counter
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd1, // Counter

        // row 2
        4'd1, // Counter
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd10, //Sink

        // row 3
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd10, //Sink

        // row 4
        4'd9, //Plate
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd1, // Counter

        // row 5
        4'd8, // Vent
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd1, // Counter

        // row 6
        4'd8, // Vent
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd6, // trash now :)

        // row 7
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd0, // Cutting Board
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter
        4'd1, // Counter

        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7, // Floor
        4'd7 // Floor
    };
    
endmodule