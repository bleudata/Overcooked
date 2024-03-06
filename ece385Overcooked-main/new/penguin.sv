//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/12/2023 03:32:27 PM
// Design Name: 
// Module Name: penguin.sv
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Controls the penguin motion by getting the keycode input. Generates
// penguin's new coordinates and nearest counter's coordinates. Instantiates the
// nearestCounter module to calculate the counter nearest to the penguin.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module penguin(input logic Reset, frame_clk,
			   input logic [7:0] keycode,
               input logic [2:0] heldSpriteIndex,
               output logic [9:0] penguinX, penguinY,
               output logic [9:0] nearestCounterXOutput, nearestCounterYOutput,
               output logic wallFlag
               );
               
    logic [9:0] X_Motion, Y_Motion;
	
    parameter [9:0] penguinXSize = 40;
    parameter [9:0] penguinYSize = 60;
    parameter [9:0] X_Min=60;       // Leftmost point on the X axis
    parameter [9:0] X_Max=580;     // Rightmost point on the X axis
    parameter [9:0] Y_Min=140;       // Topmost point on the Y axis
    parameter [9:0] Y_Max=380;     // Bottommost point on the Y axis
    parameter [9:0] X_Step=1;      // Step size on the X axis
    parameter [9:0] Y_Step=1;      // Step size on the Y axis

    parameter [9:0] CounterXMin=380;
    parameter [9:0] CounterYMin = 220;
    parameter [9:0] CounterYMax = 260; 

    logic touchingUpWallFlag, touchingDownWallFlag, touchingRightWallFlag, touchingLeftWallFlag;
    assign wallFlag = touchingLeftWallFlag || touchingDownWallFlag || touchingUpWallFlag || touchingRightWallFlag;

    logic [9:0] nearestCounterXUp, nearestCounterYUp, nearestCounterXDown, nearestCounterYDown;
    logic [9:0] nearestCounterXLeft, nearestCounterYLeft, nearestCounterXRight, nearestCounterYRight;

    touchingUpWall touchingUpWall(.penguinX(penguinX),
                                  .penguinY(penguinY), 
                                  .touchingUpWallFlag(touchingUpWallFlag),
                                  .nearestCounterX(nearestCounterXUp),
                                  .nearestCounterY(nearestCounterYUp));

    touchingDownWall touchingDownWall(.penguinX(penguinX),
                                  .penguinY(penguinY), 
                                  .touchingDownWallFlag(touchingDownWallFlag),
                                  .nearestCounterX(nearestCounterXDown),
                                  .nearestCounterY(nearestCounterYDown));

    touchingRightWall touchingRightWall(.penguinX(penguinX),
                                  .penguinY(penguinY), 
                                  .touchingRightWallFlag(touchingRightWallFlag),
                                  .nearestCounterX(nearestCounterXRight),
                                  .nearestCounterY(nearestCounterYRight));

    touchingLeftWall touchingLeftWall(.penguinX(penguinX),
                                  .penguinY(penguinY), 
                                  .touchingLeftWallFlag(touchingLeftWallFlag),
                                  .nearestCounterX(nearestCounterXLeft),
                                  .nearestCounterY(nearestCounterYLeft));

    logic [6:0] tileIndex;
    // check this, can we connect the outputs from above (nearestCounter) to the inputs below?
    coordsToTileIndex coordsToTileIndex(.xCoordinate(nearestCounterXOutput),
                                        .yCoordinate(nearestCounterYOutput),
                                        .tileIndex(tileIndex));

logic [1:0] lastPressed = 2'b00;
// W up - 00
// S down - 01
// A left - 10
// D right - 11

    always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
    begin: Move_Penguin
        if (Reset)  // asynchronous Reset
        begin 
            Y_Motion <= 10'd0;
			X_Motion <= 10'd0;
			penguinY <= 10'd300; // starting at bottom left corner of the tiled floor
			penguinX <= 10'd120;
            nearestCounterXOutput = 0;
            nearestCounterYOutput = 0;
        end
        else 
        begin
            case ({touchingUpWallFlag, touchingDownWallFlag, touchingLeftWallFlag, touchingRightWallFlag})
            4'b1000: // W up, lastPressed = 0
            begin
                nearestCounterXOutput = nearestCounterXUp;
                nearestCounterYOutput = nearestCounterYUp;
            end
            4'b0100: // S Down, lastPressed = 1
            begin
                nearestCounterXOutput = nearestCounterXDown;
                nearestCounterYOutput = nearestCounterYDown;
            end
            4'b0010: // A left, lastPressed = 2
            begin
                nearestCounterXOutput = nearestCounterXLeft;
                nearestCounterYOutput = nearestCounterYLeft;
            end
            4'b0001: // D right, lastPressed = 3
            begin
                nearestCounterXOutput = nearestCounterXRight;
                nearestCounterYOutput = nearestCounterYRight;
            end
            // W up - 00
            // S down - 01
            // A left - 10
            // D right - 11
            4'b1010: // top left
                case (lastPressed) 
                    2'b00: // go up
                    begin
                        nearestCounterXOutput = nearestCounterXUp;
                        nearestCounterYOutput = nearestCounterYUp;
                    end
                    2'b10: // go left
                    begin
                        nearestCounterXOutput = nearestCounterXLeft;
                        nearestCounterYOutput = nearestCounterYLeft;
                    end
                    default:
                    begin
                        nearestCounterXOutput = nearestCounterXOutput;
                        nearestCounterYOutput = nearestCounterYOutput;
                    end
                endcase
            4'b1001: // top right
            begin
                case (lastPressed) 
                    2'b00: // go up
                    begin
                        nearestCounterXOutput = nearestCounterXUp;
                        nearestCounterYOutput = nearestCounterYUp;
                    end
                    2'b11: // go right
                    begin
                        nearestCounterXOutput = nearestCounterXRight;
                        nearestCounterYOutput = nearestCounterYRight;
                    end
                    default:
                    begin
                        nearestCounterXOutput = nearestCounterXOutput;
                        nearestCounterYOutput = nearestCounterYOutput;
                    end
                endcase
            end
            4'b0110: // bottom left
            begin
                case (lastPressed) 
                    2'b01: // go down
                    begin
                        nearestCounterXOutput = nearestCounterXDown;
                        nearestCounterYOutput = nearestCounterYDown;
                    end
                    2'b10: // go left
                    begin
                        nearestCounterXOutput = nearestCounterXLeft;
                        nearestCounterYOutput = nearestCounterYLeft;
                    end
                    default:
                    begin
                        nearestCounterXOutput = nearestCounterXOutput;
                        nearestCounterYOutput = nearestCounterYOutput;
                    end
                endcase
            end
            4'b0101: // bottom right
            begin
                case (lastPressed) 
                    2'b01: // go down
                    begin
                        nearestCounterXOutput = nearestCounterXDown;
                        nearestCounterYOutput = nearestCounterYDown;
                    end
                    2'b11: // go right
                    begin
                        nearestCounterXOutput = nearestCounterXRight;
                        nearestCounterYOutput = nearestCounterYRight;
                    end
                    default:
                    begin
                        nearestCounterXOutput = nearestCounterXOutput;
                        nearestCounterYOutput = nearestCounterYOutput;
                    end
                endcase
            end
            default:
            begin
                nearestCounterXOutput = 0;
                nearestCounterYOutput = 0;
            end
        endcase
        if (keycode == 8'h1A) begin // W up 
            lastPressed = 2'b00;
            if((penguinX <= (CounterXMin-1)) && ((penguinY + penguinYSize) <= (CounterYMax+40)) && ((penguinY + penguinYSize) >= CounterYMax)) // check if hitting middle counter strip
                penguinY = penguinY; 
            else if((penguinY+20) > Y_Min) // give room for hat to slightly go above the counter
                penguinY = penguinY - 2;
            else 
                penguinY = penguinY;
        end
        else if (keycode == 8'h16) // S down
        begin
            lastPressed = 2'b01;
            if((penguinX <= (CounterXMin-1)) && ((penguinY + penguinYSize) <= CounterYMax) && ((penguinY + penguinYSize) >= CounterYMin)) // check if hitting middle counter strip
                penguinY = penguinY;
            else if((penguinY + penguinYSize) < Y_Max)
                penguinY = penguinY + 2;
            else
                penguinY = penguinY;
        end
        else if (keycode == 8'h04)   // A left
        begin
            lastPressed = 2'b10;
            if((penguinX <= CounterXMin) && ((penguinY + penguinYSize) <= (CounterYMax + 40-1)) && ((penguinY + penguinYSize) >= CounterYMin+1))
                penguinX = penguinX;
            else if(penguinX > X_Min)
                penguinX = penguinX - 2;
            else 
                penguinX = penguinX;
        end
        else if (keycode == 8'h07)   // D right
        begin
            lastPressed = 2'b11;
            if((penguinX + penguinXSize) < X_Max)
                penguinX = penguinX + 2;
            else 
                penguinX = penguinX;
        end
    end
end
endmodule