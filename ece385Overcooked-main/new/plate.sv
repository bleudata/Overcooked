module plate (
    input logic Reset, frame_clk, // frame_clk is vsync - update position on every vsync
    input logic [7:0] keycode,
    input logic wallFlag,
    input logic [9:0] nearestCounterX, nearestCounterY,
    input logic [9:0] penguinX, penguinY,
    input logic [2:0] spriteIndexIn,
    input logic [2:0] nearestSpriteIndex,
    input logic [3:0] tileType,
    input logic [1:0] potState,
    output logic [2:0] spriteIndexOut,
    output logic [9:0] plateX,
    output logic [9:0] plateY,
    output logic respawnPlate,
    output logic [3:0] score,
    output logic scoreChange,
    output logic [1:0] plateState  // plateState-> onion soup, so if potState[0] == 1, display full onion soup pot
    // plateState - 0: empty
    // plateState - 1: onion soup
    // potState - 2: tomato soup etc
);

    // counters to debounce the switches.
    logic [3:0] counter, next_counter;
    always_ff @ (posedge frame_clk or posedge Reset) begin
        if (Reset) begin
            plateX <= 220;
            plateY <= 220;
            plateState <= 0;
            counter <= 0;
            respawnPlate <= 0;
            spriteIndexOut <= 0;
            
            // correctOrder = 0;
        end
        else if (keycode == 8'h08) begin  // pressed E
            if (counter >= 4'b0011) begin
                counter = 4'b0000;
                if (wallFlag) begin  // touching wall
                    if (spriteIndexIn == 2) begin  // holding a plate
                        if (tileType == 1) begin  // if at the counter
                            if (nearestSpriteIndex == 0) begin  // counter empty
                                plateX <= nearestCounterX;
                                plateY <= nearestCounterY;
                                spriteIndexOut <= 0;
                            end  // else do nothing
                        end else if (tileType == 3) begin  // at the stove
                            if (potState == 1) begin  // pot is full
                                plateState <= 1;
                                spriteIndexOut <= 2;
                                // plateX = penguinX + 20;
                                // plateY = penguinY + 20;
                            end // else do nothing
                        end else if (tileType == 8) begin  // at vent, clean plate next to vent
                            if (plateState == 1) begin  // plate is full, correct order
                                plateX <= 20;
                                plateY <= 260;
                                plateState <= 0;
                                spriteIndexOut <= 0;
                                // correctOrder = 1;
                                score = score + 1;
                                scoreChange = 1;
                            end else begin
                                plateX <= 20;
                                plateY <= 260;
                                plateState <= 0;
                                spriteIndexOut <= 0;
                                // correctOrder = 0;
                            end
                        end
                    end else begin  // not holding a plate, pick up
                        if (nearestSpriteIndex == 2) begin
                            spriteIndexOut <= 2;
                            plateX <= penguinX + 20;
                            plateY <= penguinY + 20;
                        end
                    end
                end else if (spriteIndexIn == 2) begin
                    plateX <= penguinX + 20;
                    plateY <= penguinY + 20;
                    // spriteIndexOut = 2;
                end
            end
        end else begin
            counter = counter + 1;
            if (spriteIndexIn == 2) begin
                plateX <= penguinX + 20;
                plateY <= penguinY + 20;
                // spriteIndexOut = 2;
            end
        end
    end

endmodule