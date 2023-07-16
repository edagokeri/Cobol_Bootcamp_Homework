      *-----------------------
      * Copyright Contributors to the COBOL Programming Course
      * SPDX-License-Identifier: CC-BY-4.0
      *-----------------------
       IDENTIFICATION DIVISION.
      *-----------------------
       PROGRAM-ID.    ALTPROG.
       AUTHOR.        Eda Gokeri
      *--------------------
       ENVIRONMENT DIVISION.
      *--------------------
       DATA DIVISION.
      *--------------------
       WORKING-STORAGE SECTION.
       01  WS-SUB-AREA.
           05 WS-SUB-FUNC    PIC 9(01).
              88 WS-FUNC-OPEN          VALUE 1.
              88 WS-FUNC-UPDATE        VALUE 3.
              88 WS-FUNC-CLOSE         VALUE 9.
           05 WS-SUB-ID      PIC X(05).
           05 WS-SUB-DVZ     PIC X(03).
           05 WS-SUB-RC      PIC X(02).
           05 WS-SUB-DATA    PIC X(60).
           05  OUT-FNAME-FROM      PIC X(15).
           05  OUT-FNAME-TO        PIC X(15).
           05  OUT-LNAME-FROM      PIC X(15).
           05  OUT-LNAME-TO        PIC X(15).
      *--------------------
       PROCEDURE DIVISION USING WS-SUB-AREA.
      *--------------------
       0000-ALTPROG.
           IF WS-FUNC-OPEN
               PERFORM 1000-OPEN
           ELSE IF WS-FUNC-UPDATE
               PERFORM 2000-UPDATE
           ELSE IF WS-FUNC-CLOSE
               PERFORM 3000-CLOSE
           ELSE
               DISPLAY "Invalid function code."
           END-IF.
           EXIT.

       1000-OPEN.
           DISPLAY "OPEN function called."
           DISPLAY "ID: " WS-SUB-ID
           DISPLAY "DVZ: " WS-SUB-DVZ
           DISPLAY "RC: " WS-SUB-RC
           DISPLAY "DATA: " WS-SUB-DATA
           EXIT.

       2000-UPDATE.
           DISPLAY "UPDATE function called."
           DISPLAY "ID: " WS-SUB-ID
           DISPLAY "DVZ: " WS-SUB-DVZ
           DISPLAY "RC: " WS-SUB-RC
           DISPLAY "DATA: " WS-SUB-DATA
           PERFORM 4000-PROCESS-UPDATE
           EXIT.

       4000-PROCESS-UPDATE.
           MOVE WS-SUB-DATA TO OUT-LNAME-FROM
           INSPECT OUT-LNAME-FROM REPLACING ALL 'E' BY 'I'
           INSPECT OUT-LNAME-FROM REPLACING ALL 'A' BY 'E'
           MOVE OUT-LNAME-FROM TO OUT-LNAME-TO
           EXIT.

       3000-CLOSE.
           DISPLAY "CLOSE function called."
           DISPLAY "ID: " WS-SUB-ID
           DISPLAY "DVZ: " WS-SUB-DVZ
           DISPLAY "RC: " WS-SUB-RC
           DISPLAY "DATA: " WS-SUB-DATA
           EXIT.
