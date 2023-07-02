//DELDEF01 JOB ' ',CLASS=A,MSGLEVEL=(1,1),
//          MSGCLASS=X,NOTIFY=&SYSUID
//DELET500 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//SYSIN DD *
    DELETE Z95640.VSAM.AA CLUSTER PURGE
    IF LASTCC LE 08 THEN SET MAXCC = 00
    DEF CL ( NAME(Z95640.VSAM.AA)          -
             FREESPACE( 20 20 )            -
             SHR( 2,3 )                    -
             KEYS(4 0)                     -
             INDEXED SPEED                 -
             RECSZ(50 50)                  -
             TRK (10 10)                   -
             VOLUME (VPWRKB)               -
             LOG(NONE)                     -
             UNIQUE )                      -
        DATA (NAME(Z95640.VSAM.AA.DATA))   -
        INDEX ( NAME(Z95640.VSAM.AA.INDEX))
//REPRO600 EXEC PGM=IDCAMS
//SYSPRINT DD SYSOUT=*
//INN001 DD DSN=Z95640.QSAM.FF,DISP=SHR
//OUT001 DD DSN=Z95640.VSAM.AA,DISP=SHR
//SYSIN DD *
  REPRO INFILE(INN001) OUTFILE(OUT001)
