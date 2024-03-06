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
// Description: On a high level, this module controls picking up and dropping sprites.
// Inputs the nearest counter coordinates, keycodes and the penguin's current
// coordinates and outputs the newly generated coordinates for each of the sprites
// (pot, plate and onion) to be drawn on the screen.
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module pickDropSprites (
    input logic Reset, frame_clk,
    input logic [9:0] penguinX, penguinY,
    input logic [7:0] keycode,
    input logic wallFlag,
    input logic [9:0] nearestCounterX, nearestCounterY,
    output logic [2:0] nearestSpriteIndex,
    output logic [2:0] heldSpriteIndex,
    output logic [3:0] tileType,
    output logic [6:0] tileIndex,

    // pot outputs
    output logic [9:0] potX, potY,
    output logic [1:0] potState,

    // onion outputs
    output logic [9:0] onionXarray[1], onionYarray[1],
    output logic [1:0] objectState[1],
    output logic [2:0] qcounter,
    output logic [2:0] onionHeldSpriteIndex,

    // plate outputs
    output logic [9:0] plateX,
    output logic [9:0] plateY,
    output logic [1:0] plateState,
    output logic [2:0] plateHeldSpriteIndex,
    output logic [3:0] score
);

    coordsToTileIndex coordsToTileIndex(.xCoordinate(nearestCounterX),
                                        .yCoordinate(nearestCounterY),
                                        .tileIndex(tileIndex));

    logic writeEn;
    always_comb begin
        if ((keycode == 8'h8 && (wallFlag))) begin
            writeEn = 1'b1;
        end else begin
            writeEn = 1'b0;
        end
    end

    logic [2:0] newNearestSpriteIndex;

    spriteTracker spriteTracker(
        .Reset(Reset), .writeEnable(writeEn), .clk(frame_clk),
        .respawnPlate(respawnPlate),
        .tileIndex(tileIndex),
        .spriteIndexIn(newNearestSpriteIndex),
        .spriteIndex(nearestSpriteIndex)
    );

    logic [3:0] tileTypeMiddle;
    assign tileType = tileTypeMiddle;
    tileROM tileROM (.tileIndex(tileIndex),
                     .tileType(tileTypeMiddle));


    // counters to debounce the switches.
    logic [3:0] counter;
    logic respawnPlate;

    always_ff @ (posedge frame_clk or posedge Reset) begin
        if (Reset) begin
            heldSpriteIndex <= 0;
            newNearestSpriteIndex <= 0;

            counter <= 4'b0000;

            potX <= 460;
            potY <= 100;
            potState <= 0;

            plateX <= 220;
            plateY <= 220;
            plateState <= 0;
            respawnPlate <= 0;

            onionXarray[0] <= 0;
            onionYarray[0] <= 0;
            objectState[0] <= 0;
            qcounter <= 0;

        end else if (keycode == 8'h08) begin  // pressed E
            if (counter >= 4'b0011) begin
                counter = 4'b0000;
                // check wallFlag (are we touching a wall?)
                if (wallFlag) begin
                    if (heldSpriteIndex == 2) begin  // holding a plate
                        if (tileType == 1) begin  // at a counter
                            if (nearestSpriteIndex == 0) begin  // counter empty
                                newNearestSpriteIndex = 2;
                                plateX <= nearestCounterX;
                                plateY <= nearestCounterY;
                                heldSpriteIndex = 0;
                            end // else do nothing
                        end else if (tileType == 3) begin // stove
                            heldSpriteIndex <= 2;
                            if (potState == 1) begin
                                plateState <= 1;
                                potState <= 0;
                            end
                        end else if (tileType == 8) begin  // vent
                            if (plateState == 1) begin  // plate is full, correct order
                                plateX <= 20;
                                plateY <= 260;
                                plateState <= 0;
                                heldSpriteIndex = 0;
                                newNearestSpriteIndex = 2;
                                score = score + 1;
                            end else begin
                                plateX <= 20;
                                plateY <= 260;
                                plateState <= 0;
                                newNearestSpriteIndex = 2;
                            end
                        end

                    end else if (heldSpriteIndex == 3) begin
                        if ((tileType == 10) || (tileType == 8) || (tileType == 9)) begin
                            heldSpriteIndex = heldSpriteIndex;  // at the sink or vents or plates, do nothing
                        end else if (tileType == 6) begin // trash
                            objectState[0] <= 0;
                            heldSpriteIndex <= 0;
                            newNearestSpriteIndex <= 0;
                        end else if (tileType == 3) begin // if at stove
                            if (potState == 0) begin // empty pot
                                if (objectState[0] == 2) begin  // if chopped
                                    objectState[0] <= 0;
                                    heldSpriteIndex <= 0;
                                    potState <= 1; // set pot to full
                                end
                            end
                        end else if ((tileType == 1) || (tileType == 0)) begin // at a counter and holding onion
                            if (nearestSpriteIndex == 0) begin  // if there's nothing on the counter put the object there
                                newNearestSpriteIndex = 3;
                                onionXarray[0] <= nearestCounterX;
                                onionYarray[0] <= nearestCounterY;
                                heldSpriteIndex = 0;
                            end
                        end

                    end else if (heldSpriteIndex == 0) begin // not holding anything, touching a wall
                        if (nearestSpriteIndex == 2) begin // plate at counter - works
                            heldSpriteIndex = 2;
                            plateX <= penguinX + 20;
                            plateY <= penguinY + 20;
                            newNearestSpriteIndex = 0;

                        end else if (nearestSpriteIndex == 3) begin // if there is something on the counter, pick it up
                            heldSpriteIndex = 3;
                            onionXarray[0] <= penguinX + 20;
                            onionYarray[0] <= penguinY + 20;
                            newNearestSpriteIndex = 0;

                        end else if (tileType == 2) begin // crate 
                            newNearestSpriteIndex = 0;
                            objectState[0] <= 1;
                            onionXarray[0] <= penguinX + 20;
                            onionYarray[0] <= penguinY + 20;
                            heldSpriteIndex = 3;
                        end
                    end
                end else begin // not touching a wall
                    if (heldSpriteIndex == 2) begin
                        plateX <= penguinX + 20;
                        plateY <= penguinY + 20;
                    end else if (heldSpriteIndex == 3) begin
                        onionXarray[0] <= penguinX + 20;
                        onionYarray[0] <= penguinY + 20;
                    end
                end
            end

        end else if (keycode == 8'h14) begin
            if (counter >= 4'b0011) begin
                counter = 4'b0000;
                if ((tileType == 0) && (nearestSpriteIndex != 0)) begin // cutting board logic
                    qcounter = qcounter + 1;
                    if (qcounter > 4) begin
                        qcounter = 0;
                        // set zeroth onion to chopped
                        objectState[0] = 2;
                    end
                end
            end

        // not pressing a key
        end else begin
            counter <= counter + 1;
            qcounter <= qcounter;
            objectState[0] = objectState[0];
            if (heldSpriteIndex == 2) begin  // just walking around, carrying plate
                plateX <= penguinX + 20;
                plateY <= penguinY + 20;
            end else if (heldSpriteIndex == 3) begin
                onionXarray[0] <= penguinX + 20;
                onionYarray[0] <= penguinY + 20;
            end
        end
    end
endmodule