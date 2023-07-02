//HMWRK03J JOB 1,NOTIFY=&SYSUID
//***************************************************/
//COBRUN  EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(HMWRK03),DISP=SHR
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(HMWRK03),DISP=SHR
//***************************************************/
// IF RC < 5 Z95640
//***************************************************/
//RUN     EXEC PGM=HMWRK03
//STEPLIB   DD DSN=&SYSUID..LOAD,DISP=SHR
//INPFILE   DD DSN=&SYSUID..QSAM.INP,DISP=SHR
//VSAMFILE  DD DSN=Z95632.VSAM.AA,DISP=SHR
//OUTFILE   DD DSN=&SYSUID..QSAM.OUT,
//             DISP=(NEW,CATLG,DELETE),
//             UNIT=SYSDA,
//             SPACE=(TRK,(10,10),RLSE),
//             DCB=(RECFM=FB,LRECL=61,BLKSIZE=0)
//SYSOUT    DD SYSOUT=*,OUTLIM=15000
//CEEDUMP   DD DUMMY
//SYSUDUMP  DD DUMMY
//***************************************************/
// ELSE
// ENDIF
