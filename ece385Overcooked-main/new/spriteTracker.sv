//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Maya and Aarushi :)
// 
// Create Date: 11/14/2023
// Design Name: 
// Module Name: spriteTracker.sv
// Project Name: Overcooked
// Target Devices: 
// Tool Versions: 
// Description: Keeps track of a 120 element array that denotes every tile on the
// screen and any objects present on each tile.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

// 1 Pot, 1 Plate, 3 Onions, 1 Onion Soup, 1 Onion Soup Order
// Sprite Indices:
// Nothing:          3'd0
// Pot:              3'd1
// Plate:            3'd2
// Onion 1:          3'd3
// Onion 2:          3'd4
// Onion 3:          3'd5
// Onion Soup:       3'd6
// Onion Soup Order: 3'd7

module spriteTracker(
    input logic Reset, writeEnable, clk,
    input logic respawnPlate, correctOrder,
    input logic [6:0] tileIndex,
    input logic [2:0] spriteIndexIn,
    output logic [2:0] spriteIndex
);

    // packed unpacked array that stores which sprite is
    // stored at which tile index
    logic [2:0] spriteRegs[120];
    logic [2:0] newSpriteIndex;

    // writing logic - reset and regular write
    always_ff @ (posedge clk or posedge Reset) begin
        if (Reset) begin
            for (integer i = 0; i < 120; i++)
            begin
                spriteRegs[i] = 0;
            end
            newSpriteIndex = 0;
            spriteRegs[50] = 2;
        end

        else if (respawnPlate) begin
            spriteRegs[60] = 2;
            newSpriteIndex = spriteRegs[tileIndex];
        end

        else begin
            if (writeEnable) begin
                spriteRegs[tileIndex] = spriteIndexIn;
            end 
            newSpriteIndex = spriteRegs[tileIndex];
        end
    end

    assign spriteIndex = newSpriteIndex;

endmodule