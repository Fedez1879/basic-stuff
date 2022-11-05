5 RANDOMIZE TIMER: W = 40
10 SCREEN 0: CLS: KEY OFF: WIDTH W
20 DEF SEG = &HB800: DIM SP(1000), SD(3), SV(2)
22 ' SP is the positional array of the snake
25 ' SD contains the position vector plus the snake length
27 ' SV contains the snake velocity XY
30 S = 197: F = 254: BB = 177: WS = 32 ' define ascii code graphic
40 PT = 0: M = 1000 'define points and loop timing
50 GOSUB 1500 ' draw bb
60 GOSUB 1200 ' reset snake data
70 GOSUB 1100 ' draw snake
80 GOSUB 1150 ' draw food
90 GOTO 500 ' game loop
499 END
500 ' game loop
510 K$ = INKEY$ ' get keypressed
520 IF K$ = CHR$(27) THEN GOTO 700 ' if ESC then pause the game
530 IF K$ = CHR$(0) + CHR$(72) THEN SV(0) = 0: SV(1) = -1 ' Up
540 IF K$ = CHR$(0) + CHR$(75) THEN SV(0) = -1: SV(1) = 0 ' Left
550 IF K$ = CHR$(0) + CHR$(77) THEN SV(0) = 1: SV(1) = 0  ' Right
560 IF K$ = CHR$(0) + CHR$(80) THEN SV(0) = 0: SV(1) = 1  ' Down
570 SD(0) = SD(0) + SV(0): SD(1) = SD(1) + SV(1) ' adjust snake position array according to velocity
580 GOSUB 1300 ' get next position bagkground (B)
590 IF B = S OR B = BB THEN GOTO 3000 ' oh no, hit nyself (S) or the boundary(BB)
600 IF B = F THEN GOSUB 1400: GOTO 680 ' food taken!
610 P = SP(0): C = WS: C1 = 15: GOSUB 2020 ' remove last piece of snake from screen
620 FOR I=1 TO SD(2)-1: SP(I-1) = SP(I): NEXT I ' adjust pos array excluding last pos
660 GOSUB 1100: GOSUB 1320: PT = PT + 10 ' draw snake new position, update last pos array
670 IF M < 1 THEN M = 1 ' wait time nust be at least 1
680 COLOR 15: LOCATE 24,3: PRINT "SCORE:";: COLOR 14: PRINT PT;' print score
690 FOR I=1 TO M: NEXT I: GOTO 500 ' wait and repeat game loop
700 ' pause
710 LOCATE 24,W-12: COLOR 19: PRINT "PAUSE (ESC)";
720 B$ = INKEY$: IF B$ <> CHR$(27) THEN GOTO 720
730 LOCATE 24,W-12: COLOR 7: PRINT "           ";
740 GOTO 500
999 END
1000 ' generate random coords
1010 X = INT(RND*38)+2: Y = INT(RND*21)+2: RETURN
1100 ' draw snake
1110 C = S: C1 = 32: X = SD(0): Y = SD(1): GOSUB 2050: RETURN
1150 ' draw food
1160 C = F: C1 = 14
1170 GOSUB 1000: GOSUB 2000: IF B <> 32 THEN GOTO 1170 ' food only on empty spaces
1180 GOSUB 2020: RETURN
1200 ' reset snake speed, position and length
1201 ' SV = snake velocity (0->x-speed, 1->y-speed)
1202 ' SD = snake data (0->x, 1->y, 2->length)
1210 SV(0) = 1: SV (1) = 0 
1220 SD(0) = W/2: SD(1) = 14: SD(2) = 1:
1230 GOSUB 1300: GOSUB 1320
1240 RETURN
1300 ' set snake XY position and get POKE (P) one
1310 X = SD(0): Y = SD(1): GOSUB 2000: RETURN
1320 ' refresh tail with last pos
1330 SP(SD(2)-1) = P
1340 RETURN
1400 ' food taken
1410 PLAY "MBL32N32": M = M - 25: PT = PT + 50: SD(2) = SD(2) + 1
1420 GOSUB 1100: GOSUB 1320: GOSUB 1150: RETURN
1500 ' generate bounding box
1510 C = BB: C1 = 7
1520 Y = 1: GOSUB 1550: Y=23: GOSUB 1550: Y=25: GOSUB 1550
1530 FOR Y = 2 TO 24: X = 1: GOSUB 2040: X = W: GOSUB 2040: NEXT Y
1540 RETURN
1550 ' draw H line at Y
1560 FOR X = 1 TO W: GOSUB 2040: NEXT X: RETURN
2000 ' converts xy coords to poke ones
2010 P = (Y-1)*W*2+(X-1)*2: B = PEEK(P): RETURN
2020 ' poke C stuff with C1 color on xy coords
2030 POKE P,C: POKE P+1,C1: RETURN
2040 ' get p from xy and poke it
2050 GOSUB 2000: GOSUB 2020: RETURN
3000 C = B: C1=64: GOSUB 2030: PLAY "MBL16N8"
3010 COLOR 12: LOCATE 12,W/2-4:PRINT "GAME OVER"
3020 COLOR 15: LOCATE 14,W/2-8:PRINT "PLAY AGAIN ";: COLOR 14: PRINT"(Y/N)";: COLOR 15: PRINT " ?"
3030 C$ = INKEY$
3040 IF C$ <> "Y" AND C$ <> "N" THEN GOTO 3030
3050 CLS
3060 IF C$ = "Y" THEN GOTO 30
3070 COLOR 7: WIDTH 80: END
