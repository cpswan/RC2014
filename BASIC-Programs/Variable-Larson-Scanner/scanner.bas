10 LET DELAY = 5020 PRINT "Push buttons 0..7 to change speed"30 FOR F = 1 TO 640 OUT 0, INT(2^F+0.1) : REM APU +0.1 Fudge50 GOSUB 12060 NEXT F70 FOR F = 7 TO 0 STEP -180 OUT 0, INT(2^F+0.1) : REM APU +0.1 Fudge90 GOSUB 120100 NEXT F110 GOTO 30120 FOR Z = 1 TO DELAY130 IF INP(0) <> 0 THEN LET DELAY = INT(SQR(INP(0))) * 50140 NEXT Z150 RETURN