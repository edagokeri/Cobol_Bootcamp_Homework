      *-----------------------
      * Copyright Contributors to the COBOL Programming Course
      * SPDX-License-Identifier: CC-BY-4.0
      *-----------------------
       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    PBEGIDX.
       AUTHOR.        Eda Gokeri
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT IDX-FILE   ASSIGN  PRTLINE
                             STATUS  PRT-ST.
           SELECT ACCT-REC   ASSIGN  ACCTREC
                             STATUS  ACCT-ST.
      *-------------
       DATA DIVISION.
      *-------------
       FILE SECTION.
       FD  PRINT-LINE  RECORDING MODE F.
       01  PRINT-REC.
           05  PRINT-SEQ             PIC X(04).
           05  PRINT-AD              PIC X(15).
           05  PRINT-SOYAD           PIC X(15).
           05  PRINT-DTAR            PIC X(08).
           05  PRINT-TODAY           PIC X(08).
           05  PRINT-FARK            PIC X(05).

      *
       FD  ACCT-REC RECORDING MODE F.
       01  ACCT-FIELDS.
           05  ACCT-SEQ            PIC X(04).
           05  ACCT-AD             PIC X(15).
           05  ACCT-SOYAD          PIC X(15).
           05  ACCT-DTAR           PIC X(08).
           05  ACCT-TODAY          PIC X(08).
      *
       WORKING-STORAGE SECTION.
       01  WS-WORK-AREA.
           05  PRT-ST           PIC 9(02).
               88 PRT-SUCCESS            VALUE 00 97.
           05  ACCT-ST          PIC 9(02).
               88 ACCT-EOF                VALUE 10.
               88 ACCT-SUCCESS            VALUE 00 97.

           05  WS-FUNCTION      PIC X(01).
               88 WS-FUNC-OPEN         VALUE 1.
               88 WS-FUNC-READ         VALUE 2.
               88 WS-FUNC-UPDATE       VALUE 3.
               88 WS-FUNC-CLOSE        VALUE 9.
           
           05  WS-INT-D         PIC 9(07).
           05  WS-INT-T         PIC 9(07).

       LINKAGE SECTION. 
       01  WS-SUB-AREA.
           05 WS-FUNCTION       PIC X(01).
           05 WS-RETURNCODE     PIC 9(02).
           05 WS-DATA           PIC X(60).
      *------------------
       PROCEDURE DIVISION USING WS-SUB-AREA.
      *------------------
       0000-MAIN.
           EVALUATE TRUE 
              WHEN WS-FUNC-OPEN
                 PERFORM H100-OPEN-FILES
              WHEN WS-FUNC-OPEN 
              WHEN OTHER 
                 DISPLAY 'INVALID FUNC' WS-FUNCTION 
           END-EVALUATE 
           PERFORM H200-PROCESS UNTIL ACCT-EOF.
           PERFORM H999-PROGRAM-EXIT.
       H100-OPEN-FILES.
           OPEN INPUT  ACCT-REC.
           OPEN OUTPUT PRINT-LINE.
           READ ACCT-REC.
           SET WS-FUNC-OPEN TO TRUE.
           CALL WS-ALTPROG USING WS-SUB-AREA.
           READ ACCT-REC.
       H100-END. EXIT.
      *
       H200-PROCESS.
           MOVE INP-ISLEM-TIPI TO WS-ISLEM-TIPI
           IF WS-ISLEM-TIPI-VALID
              EVALUATE WS-ISLEM-TIPI
                 WHEN 3
                   SET WS-FUNC-UPDATE TO TRUE
                 WHEN OTHER
                   SET WS-FUNC-READ   TO TRUE
              END-EVALUATE
              MOVE INP-ID     TO WS-SUB-ID
              MOVE INP-DVZ    TO WS-SUB-DVZ
              MOVE ZEROS      TO WS-SUB-RC
              MOVE SPACES     TO WS-SUB-DATA
              CALL WS-PBEGIDX USING WS-SUB-AREA
           ELSE
              STRING 'INVALID ISLEM TIPI:' INP-ISLEM-TIPI
               DELIMITED BY SIZE INTO OUT-REC
               WRITE OUT-REC
           END-IF
           READ INP-FILE.
       H200-END. EXIT.
       H300-CLOSE-FILES.
           CLOSE INP-FILE
                 OUT-FILE.
           SET WS-FUNC-CLOSE TO TRUE.
           CALL  WS-PBEGIDX USING WS-SUB-AREA.
       H300-END. EXIT.
       H999-PROGRAM-EXIT.
           PERFORM H300-CLOSE-FILES.
           STOP RUN.
       H999-END. EXIT.
