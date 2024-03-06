module onion #(
    parameter coordinateSize = 10,
    parameter numberOfOnions = 1,
    parameter onionBits = 1
) (input logic Reset, frame_clk, // frame_clk is vsync - update position on every vsync
			   input logic [7:0] keycode,
               input logic wallFlag,
               input logic [9:0] nearestCounterX, nearestCounterY,
               input logic [9:0] penguinX, penguinY,
               input logic [2:0] heldSpriteIndexIn,
               input logic [2:0] nearestSpriteIndex,
               input logic [3:0] tileType,
               input logic potOnionPresent,
               input logic [1:0] potState,
               output logic [2:0] heldSpriteIndexOut,
               output logic [coordinateSize - 1 : 0] onionXarray[numberOfOnions],
               output logic [coordinateSize - 1:0] onionYarray[numberOfOnions],
               output logic [1:0] presentMask[numberOfOnions], // more bits, one for each onion
               output logic [2:0] qcounter // counts how many times q is pressed
               );

    parameter [9:0] onionXSize = 40;
    parameter [9:0] onionYSize = 40;
    parameter [9:0] X_Min=60;       // Leftmost point on the X axis
    parameter [9:0] X_Max=579;     // Rightmost point on the X axis
    parameter [9:0] Y_Min=140;       // Topmost point on the Y axis
    parameter [9:0] Y_Max=379;     // Bottommost point on the Y axis
    parameter [9:0] X_Step=1;      // Step size on the X axis
    parameter [9:0] Y_Step=1;      // Step size on the Y axis

    parameter [9:0] CounterXMin=380;
    parameter [9:0] CounterYMin = 220;
    parameter [9:0] CounterYMax = 260;

    // counters to debounce the switches.
    logic [3:0] counter, next_counter;

    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin
        // qcounter = 0;
        // heldSpriteIndexOut = 0;
        // presentMask[0] = 0;
        // counter = 0;
        // onionXarray[0] = 0;
        // onionYarray[0] = 0;
        if (Reset)  // asynchronous Reset
            begin
                onionXarray[0] <= 0;
                onionYarray[0] <= 0;
                // set zeroth onion to not present
                presentMask[0] <= 0;
                heldSpriteIndexOut <= 0;
                counter <= 4'b0000;
                qcounter <= 0;
            end
        else if (keycode == 8'h08) // E to pick things up
            begin
                if (counter >= 4'b0011) begin
                    counter = 4'b0000;
                    if (wallFlag) begin         // are we touching a wall?
                        if (heldSpriteIndexIn == 3) begin  // we are holding an onion, want to put it down
                            if ((tileType == 10) || (tileType == 8) || (tileType == 9)) begin
                                heldSpriteIndexOut = heldSpriteIndexIn;  // at the sink or vents or plates, do nothing
                            end else if (tileType == 6) begin // trash
                                presentMask[0]<= 0;
                                heldSpriteIndexOut <= 0;
                            end else if (tileType == 3) begin // if at stove
                                if (potState[0] == 0) begin // empty pot
                                    if (presentMask[0] == 2) begin  // if chopped
                                        presentMask[0] <= 0;
                                        heldSpriteIndexOut <= 0;
                                        // TO DO EDIT SO THAT SPRITE TRACKER IS EDITED
                                    end
                                end
                            end else if ((tileType == 1) || (tileType == 0)) begin // at a counter and holding onion
                                if (nearestSpriteIndex == 0) begin  // if there's nothing on the counter put the object there
                                    onionXarray[heldSpriteIndexIn - 3] <= nearestCounterX;
                                    onionYarray[heldSpriteIndexIn - 3] <= nearestCounterY;
                                    heldSpriteIndexOut <= 0;
                                end 
                                // else begin 
                                //     heldSpriteIndexOut = heldSpriteIndexIn;
                                // end
                                // else do nothing
                            end
                             
                        end else begin // not holding an onion
                            if (nearestSpriteIndex == 3) begin // if there is something on the counter, pick it up
                                heldSpriteIndexOut <= nearestSpriteIndex;
                                onionXarray[heldSpriteIndexOut - 3] <= penguinX + 20;
                                onionYarray[heldSpriteIndexOut - 3] <= penguinY + 20;
                            end else begin
                                if (tileType == 2) begin // if the penguin is at the crate, generate onion
                                    // set presentMask here and also do everything
                                    // set zeroth onion to present
                                    presentMask[0] <= 1;
                                    heldSpriteIndexOut <= 3;
                                    onionXarray[0] <= penguinX + 20;
                                    onionYarray[0] <= penguinY + 20;
                                end
                            end
                        end
                    end else if (heldSpriteIndexIn == 3) begin
                        onionXarray[0] <= penguinX + 20;
                        onionYarray[0] <= penguinY + 20;
                    end else begin

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
                        presentMask[0] = 2;
                    end
                end
            end
        end else begin
            counter = counter + 1;
            qcounter = qcounter;
            // heldSpriteIndexOut = heldSpriteIndexIn;
            presentMask[0] = presentMask[0];
            if (heldSpriteIndexIn == 3) begin
                onionXarray[0] <= penguinX + 20;
                onionYarray[0] <= penguinY + 20;
            end else begin
                onionXarray[0] <= onionXarray[0];
                onionYarray[0] <= onionYarray[0];
            end
        end
    end
endmodule