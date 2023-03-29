01   REM Copywrite feilipu 2023
02   REM MIT LICENCE

10   LET T=0: LET D=0
20   DIM COMND$(16): REM 16 character input string
30   DIM H$(4): REM 4 character hex string

40   REM !!! SET UADDR TO THE USRLOC ADDRESS FOR YOUR BASIC ROM !!!
50   LET UADDR=&H8204

100  REM Command Loop
120  LET FUNCT=0: REM required function as ascii code
130  LET SRC=0: LET DESTN=0: LET LGTH=0: REM input parameters
140  INPUT "Command: ";COMND$
150  FUNCT=ASC(COMND$)
160  IF FUNCT>90 THEN FUNCT=FUNCT-32: REM allow lower case command

200  IF FUNCT=65 THEN GOTO 1000: REM A hex arithmetic
210  IF FUNCT=67 THEN GOTO 2000: REM C copy
220  IF FUNCT=69 THEN GOTO 3000: REM E execute
230  IF FUNCT=73 THEN GOTO 4000: REM I intelligent copy
240  IF FUNCT=77 THEN GOTO 5000: REM M modify store
250  IF FUNCT=81 THEN END: REM Q quit
260  IF FUNCT=84 THEN GOTO 6000: REM T tabulate print
270  PRINT "INVALID COMMAND": GOTO 100

1000 REM A hex arithmetic
1010 GOSUB 8100: REM convert 2 hex strings to 2 signed integers
1020 PRINT HEX$((DESTN+SRC));"h ";HEX$((DESTN-SRC));"h ";SRC-DESTN
1100 GOTO 100

2000 REM C copy
2010 GOSUB 8000: REM convert 3 hex strings to 2 signed int, 1 unsigned
2020 FOR L=LGTH-1 TO 0 STEP -1
2030 POKE DESTN,PEEK(SRC): DESTN=DESTN+1: SRC=SRC+1
2040 NEXT
2100 GOTO 100

3000 REM E execute
3010 GOSUB 8200: REM convert 1 hex string to signed integer
3020 IF LEN(COMND$)<8 THEN GOTO 9700
3030 DESTN=VAL(MID$(COMND$,8))
3040 DOKE UADDR,SRC: REM set usrloc to point to assembly program
3050 REM USR(DESTN): REM run the program
3100 GOTO 100

4000 REM I intelligent copy
4010 GOSUB 8000: REM convert 3 hex strings to signed int, 1 unsigned
4020 IF DESTN >= SRC THEN GOTO 4200
4030 FOR L=LGTH-1 TO 0 STEP -1
4040 POKE DESTN,PEEK(SRC): SRC=SRC+1: DESTN=DESTN+1
4050 NEXT
4100 GOTO 100

4200 REM I copy down
4210 SRC=SRC+LGTH-1: DESTN=DESTN+LGTH-1
4220 FOR L=LGTH-1 TO 0 STEP -1
4230 POKE DESTN,PEEK(SRC): SRC=SRC-1: DESTN=DESTN-1
4240 NEXT
4300 GOTO 100

5000 REM M modify store
5010 GOSUB 8200: REM convert 1 hex string to signed integer
5020 PRINT HEX$(SRC);"h is ";HEX$(PEEK(SRC))
5030 INPUT "New";H$
5040 GOSUB 9000
5050 IF T>=0 AND T<=255 THEN POKE SRC,T
5200 GOTO 100

6000 REM T tabulate print
6010 GOSUB 8300: REM 2 hex strings to 1 signed int, 1 unsigned int
6020 FOR S=SRC TO SRC+LGTH-1 STEP 16
6030 PRINT HEX$(S);"h ";
6040 FOR L=0 TO 15
6050 PRINT " ";HEX$(PEEK(S+L));
6060 NEXT L
6070 PRINT
6080 NEXT S
6100 GOTO 100

8000 REM convert 3 hex strings to 2 signed int, 1 unsigned int
8010 IF LEN(COMND$)<13 THEN GOTO 9700
8020 H$=MID$(COMND$,13)
8030 GOSUB 9000
8040 IF T<0 OR T>65536 THEN GOTO 9700
8050 LGTH=T

8100 REM convert 2 hex strings to 2 signed integers
8110 IF LEN(COMND$)<11 THEN GOTO 9900
8120 H$=MID$(COMND$,8,4)
8130 GOSUB 9000
8140 IF T<0 OR T>65536 THEN GOTO 9900
8150 IF T>=32768 AND T<=65536 THEN T=T-65536
8160 DESTN=T

8200 REM convert 1 hex string to 1 signed integer
8210 IF LEN(COMND$)<6 THEN GOTO 9900
8220 H$=MID$(COMND$,3,4)
8230 GOSUB 9000
8240 IF T<0 OR T>65536 THEN GOTO 9900
8250 IF T>=32768 AND T<=65536 THEN T=T-65536
8260 SRC=T

8290 RETURN

8300 REM 2 hex strings to 1 signed int, 1 unsigned int
8310 IF LEN(COMND$)<8 THEN GOTO 9700
8320 H$=MID$(COMND$,8)
8330 GOSUB 9000
8340 IF T<0 OR T>65536 THEN GOTO 9700
8360 LGTH=T

8390 GOTO 8200

9000 REM convert hex string to positive integer
9020 LET T=0: LET D=1
9030 FOR P=LEN(H$)-1 TO 0 STEP -1
9040 C=ASC(MID$(H$,D,1))
9050 D=D+1
9060 IF C>=48 AND C<=57 THEN C=C-48: GOTO 9100
9070 IF C>=65 AND C<=70 THEN C=C-55: GOTO 9100
9080 IF C>=97 AND C<=102 THEN C=C-87: GOTO 9100
9090 GOTO 9800
9100 T=T+INT(C*16^P+0.5)
9110 NEXT
9120 RETURN

9700 PRINT "NOT A VALID INTEGER": RETURN
9800 PRINT "NOT A VALID HEX VALUE": RETURN
9900 PRINT "NOT A VALID HEX ADDRESS": RETURN

