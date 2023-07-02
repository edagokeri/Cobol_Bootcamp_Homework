       IDENTIFICATION DIVISION.
       PROGRAM-ID. HMWRK03.
       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT VSAM-FILE ASSIGN TO VSAMFILE
                            ORGANIZATION INDEXED
                            ACCESS RANDOM
                            RECORD KEY VSAM-KEY
                            STATUS ST-VSAM.
           SELECT OUT-FILE  ASSIGN TO OUTFILE
                            STATUS ST-OUT.
           SELECT INP-FILE  ASSIGN TO INPFILE
                            STATUS ST-INP.
       DATA DIVISION.
       FILE SECTION.
       FD  VSAM-FILE.
         01  VSAM-REX.
           03 VSAM-KEY.
              05 VSAM-ID         PIC S9(5) COMP-3.
              05 VSAM-DVZ        PIC S9(3) COMP.
           03 VSAM-NAME          PIC X(30).
           03 VSAM-DATE          PIC S9(07) COMP-3.
           03 VSAM-BALANCE       PIC S9(15) COMP-3.
       FD  OUT-FILE RECORDING MODE F.
         01  PRINT-REC.
           03 REC-ID-O          PIC X(5).
           03 REC-DVZ-O         PIC X(3).
           03 REC-NAME-O        PIC X(30).
           03 REC-DATE-O        PIC X(8).
           03 REC-BALANCE-O     PIC 9(15).
       FD  INP-FILE RECORDING MODE F.
         01  FLTIN.
           03 REC-ID            PIC X(5).
           03 REC-DVZ           PIC X(3).
       WORKING-STORAGE SECTION.
         01  WS-WORK-AREA.
           03 ST-INP            PIC 9(2).
              88 INP-FILE-EOF                   VALUE 10.
              88 INP-FILE-SUCCESS               VALUE 0 97.
              88 INP-FILE-NOTFND                VALUE 23.
           03 ST-VSAM            PIC 9(2).
              88 VSAM-FILE-SUCCESS               VALUE 0 97.
              88 VSAM-FILE-NOTFND                VALUE 23.
           03 ST-OUT            PIC 9(2).
              88 OUT-FILE-SUCCESS               VALUE 0 97.
           03 REC-KEY           PIC 9(8).
           03 INT-DATE          PIC 9(7).
           03 GREG-DATE         PIC 9(8).

       PROCEDURE DIVISION.
       0000-MAIN.
           PERFORM H100-OPEN-FILES
           PERFORM H200-READ-FIRST
           PERFORM H201-READ-NEXT-RECORD UNTIL INP-FILE-EOF
           PERFORM H999-PROGRAM-EXIT.
       0000-END. EXIT.

       H100-OPEN-FILES.
           OPEN INPUT  INP-FILE.
           OPEN INPUT  VSAM-FILE.
           OPEN OUTPUT OUT-FILE.
           IF (ST-VSAM NOT = 0) AND (ST-VSAM NOT = 97)
           DISPLAY '1'
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-VSAM
           MOVE ST-VSAM TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (ST-INP NOT = 0) AND (ST-INP NOT = 97)
           DISPLAY '2'
           DISPLAY 'UNABLE TO OPEN INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.

           IF (ST-OUT NOT = 0) AND (ST-OUT NOT = 97)
           DISPLAY '3'
           DISPLAY 'UNABLE TO OPEN OUTFILE: ' ST-OUT
           MOVE ST-OUT TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
       H100-END. EXIT.

       H200-READ-FIRST.
           READ INP-FILE.
           IF (ST-INP NOT = 0) AND (ST-INP NOT = 97)
           DISPLAY 'UNABLE TO READ INPFILE: ' ST-INP
           MOVE ST-INP TO RETURN-CODE
           PERFORM H999-PROGRAM-EXIT
           END-IF.
           COMPUTE VSAM-ID = FUNCTION NUMVAL-C (REC-ID)
           COMPUTE VSAM-DVZ = FUNCTION NUMVAL (REC-DVZ)
           READ VSAM-FILE KEY VSAM-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H200-END. EXIT.

       H201-READ-NEXT-RECORD.
           READ INP-FILE.
           COMPUTE VSAM-ID = FUNCTION NUMVAL-C (REC-ID)
           COMPUTE VSAM-DVZ = FUNCTION NUMVAL (REC-DVZ)
           READ VSAM-FILE KEY VSAM-KEY
             INVALID KEY PERFORM WRNG-RECORD
             NOT INVALID KEY PERFORM WRITE-RECORD.
       H201-END. EXIT.

       DATE-CONVERT.
           COMPUTE INT-DATE = FUNCTION INTEGER-OF-DAY(VSAM-DATE)
           COMPUTE GREG-DATE = FUNCTION DATE-OF-INTEGER(INT-DATE).
       DATE-END. EXIT.

       WRNG-RECORD.
               DISPLAY "record undefined: " REC-ID.
       WRNG-END. EXIT.

       WRITE-RECORD.
           PERFORM DATE-CONVERT.
           MOVE VSAM-ID       TO  REC-ID-O.
           MOVE VSAM-DVZ      TO  REC-DVZ-O.
           MOVE VSAM-NAME     TO  REC-NAME-O.
           MOVE GREG-DATE    TO  REC-DATE-O.
           MOVE VSAM-BALANCE  TO  REC-BALANCE-O.
           WRITE PRINT-REC.
       WRITE-END. EXIT.

       H999-PROGRAM-EXIT.
           CLOSE INP-FILE.
           CLOSE VSAM-FILE.
           CLOSE OUT-FILE.
           GOBACK.
       H999-EXIT.
