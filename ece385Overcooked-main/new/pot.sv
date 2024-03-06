module pot (
    input logic Reset, frame_clk, // frame_clk is vsync - update position on every vsync
    input logic [7:0] keycode,
    input logic wallFlag,
    input logic [2:0] heldSpriteIndex,
    input logic [3:0] tileType,
    input logic [1:0] plateState,
    input logic [1:0] objectState[1],
    output logic [9:0] potX,
    output logic [9:0] potY,
    output logic [1:0] potState // potState-> onion soup, so if potState[0] == 1, display full onion soup pot
    // potState - 0: empty
    // potState - 1: onion soup
    // potState - 2: tomato soup etc
    // output logic currentPlateFull
);

always_ff @ (posedge frame_clk or posedge Reset) begin
    if (Reset) begin
        potX <= 460;
        potY <= 100;
        potState <= 0;
    end else if (keycode == 8'h08) begin // E key pressed
        if (wallFlag) begin
            if (tileType == 3) begin
                if (potState == 0) begin // pot is currently empty
                    if (heldSpriteIndex != 0) begin // if holding something, check if chopped
                        if (objectState[heldSpriteIndex - 3] == 2) begin  // thing is chopped, put in pot
                        potState <= 1;
                        end // else do nothing (thing is not chopped)
                    end // pot is empty and we are not holding anything, do nothing
                end else if (potState == 1) begin // pot is full
                    if (heldSpriteIndex == 2) begin // are holding a plate, make pot empty and change plate
                        potState <= 0;
                    end
                end
            end
        end
    end
end
    
endmodule