//JBEG005J JOB 1,NOTIFY &SYSUID
//COBRUN EXEC IGYWCL
//COBOL.SYSIN  DD DSN=&SYSUID..CBL(PBEG006),DISP=SHR 
//LKED.SYSLMOD DD DSN=&SYSUID..LOAD(PBEG006),DISP=SHR 
//***************************************************/
// IF RC < 5 THEN 
//***************************************************/
//RUN    EXEC PGM=PBEG006
//STEPLIB  DD DSN=&SYSUID..LOAD,DISP=SHR
//ACCTREC  DD DSN=&SYSUID..QSAM.BB,DISP=SHR
//PRTLINE  DD DSN=&SYSUID..QSAM.CC,DISP=(NEW,CATLG,DELETE),
//            SPACE=(TRK,(20,20),RLSE),
//            DCB=(RECFM=FB,LRECL=55,BLKSIZE=0),UNIT=3390
//SYSOUT   DD SYSOUT=*,OUTLIM=15000
//SYSIN    DD *
1
1000
//CEEDUMP  DD DUMMY
//SYSUDUMP DD DUMMY
//***************************************************/
// ELSE 
// ENDIF