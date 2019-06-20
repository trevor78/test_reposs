//TESTPRC1 PROC                                                         00000010
//**********************************************************************00000020
//* FUNCTIONAL AREA:  CUSTOMER SERVICE                                  00000030
//*                                                                     00000040
//* CUBSO210: CAP SEAMLESS MOVE (PORTABILITY)                           00000050
//*                                                                     00000060
//* THIS JOB USES RSAM                                                  00000070
//*                                                                     00000080
//**********************************************************************00000200
//*  DELETES FILES FROM PREVIOUS RUN                                    00000210
//**********************************************************************00000220
//STEP0001 EXEC PGM=IEFBR14                                             00000230
//*                                                                     00000240
//DD01     DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..LAST.RUN,                00000250
//         DISP=(MOD,DELETE,DELETE),UNIT=&UNIT,SPACE=(TRK,0)            00000260
//*                                                                     00000270
//**********************************************************************00000280
//*  REFORMATS LAST RUNDATE FILE TO PUT QUOTES AROUND DATE FOR DB2      00000290
//**********************************************************************00000300
//STEP0002 EXEC PGM=SORT,COND=(4,LT)                                    00000310
//*                                                                     00000320
//SYSOUT   DD SYSOUT=*                                                  00000330
//SYSIN    DD DSN=GEN.SYM2CA(CS767D07),                                 00000340
//            DISP=SHR                                                  00000350
//*                                                                     00000360
//SORTIN   DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..LAST.RUNDATE,            00000370
//            DISP=SHR                                                  00000380
//*                                                                     00000390
//SORTOUT  DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..LAST.RUN,                00000400
//            DISP=(NEW,CATLG,DELETE),UNIT=&UNIT,                       00000410
//            SPACE=(80,(1,1),RLSE),AVGREC=U,                           00000420
//            DCB=(LRECL=80,RECFM=FB)                                   00000430
//*                                                                     00000440
//********************************************************************  00000450
//* STEP0003 COMBINES CONTROL STATEMENTS FOR USE IN UNLOAD STEP         00000460
//********************************************************************  00000470
//STEP0003 EXEC PGM=SORT,COND=(4,LT)                                    00000480
//SYSOUT   DD SYSOUT=*                                                  00000490
//*                                                                     00000500
//SORTIN   DD DSN=GEN.SYM2CA(CS767D10),DISP=SHR                         00000510
//         DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..LAST.RUN,DISP=SHR        00000520
//*                                                                     00000530
//SORTOF1  DD DSN=&&CTL,                                                00000540
//            DISP=(NEW,PASS,DELETE),UNIT=&UNIT,                        00000550
//            SPACE=(80,(50,10),RLSE),AVGREC=U,                         00000560
//            DCB=(RECFM=FB,LRECL=80)                                   00000570
//*                                                                     00000580
//SORTOF2  DD SYSOUT=*,                                                 00000590
//            DCB=(RECFM=FB,LRECL=80)                                   00000600
//*                                                                     00000610
//SYSIN    DD DSN=GEN.SYM2CA(CS767D09),DISP=SHR                         00000620
//*                                                                     00000630
//**********************************************************************00000640
//* STEP STEP0004 EXECUTES PROC &UNLDPROC WHICH UNLOADS ALL             00000650
//* COMPLETED CONNECT SERVICE ORDERS SINCE LAST TIME JOB WAS EXECUTED   00000660
//**********************************************************************00000670
//STEP0004 EXEC &UNLDPROC,DB2=&DB2,LIB=&LIB,SQL=&SQL                    00000680
//*                                                                     00000690
//SYSTSIN  DD DSN=GEN.SYM2CA(UL&DB2.&SQL),DISP=SHR                      00000700
//*                                                                     00000710
//SYSIN    DD DSN=&&CTL,DISP=(OLD,PASS)                                 00000720
//*                                                                     00000730
//SYSREC00 DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..MTR.ORD.INPUT(+1),       00000740
//         UNIT=&UNIT,DISP=(NEW,CATLG,DELETE),                          00000750
//         SPACE=(53,(200,50),RLSE),AVGREC=K,                           00000760
//         DCB=(LRECL=53,RECFM=FB)                                      00000770
//*                                                                     00000780
//****************************************************************      00000790
//*                                                                     00000800
//* PRE ALLOCATE DATASET FOR ERROR REPORT IN STEP STEP0005.             00000810
//*                                                                     00000820
//****************************************************************      00000830
//*                                                                     00000840
//STEP0005 EXEC PGM=IEFBR14,COND=(4,LT)                                 00000850
//*                                                                     00000860
//CUSOD212 DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..CURSO210(+1),            00000870
//            DISP=(NEW,CATLG,DELETE),UNIT=&UNIT,                       00000880
//            SPACE=(133,(60,10)),AVGREC=K,                             00000890
//            DCB=(RECFM=FB,LRECL=133)                                  00000900
//*                                                                     00000910
//********************************************************************* 00000920
//* STEP STEP0006 EXECUTES PROC &DB2PROC WHICH EXECUTES                 00000930
//* PROGRAM CUBSO210, CAP SEAMLESS MOVE (PORTABILITY)                   00000940
//********************************************************************* 00000950
//STEP0006 EXEC &DB2PROC,                                               00000960
//         PROGRM=CUBSO210,                                             00000970
//         DB2SUB=&DB2SUB,                                              00000980
//         INP='1999',                                                  00000990
//         HIGHLVL=&HIGHLVL,                                            00001000
//         ENVIR=&ENVIR,                                                00001010
//         JOB=&JOB,                                                    00001020
//         PLID=&PLID,                                                  00001030
//         OBJNAME=&OBJNAME,                                            00001040
//         BATLOAD1=&BATLOAD1,                                          00001050
//         BATLOAD2=&BATLOAD2,                                          00001060
//         BATLOAD3=&BATLOAD3,                                          00001070
//         BATLOAD4=&BATLOAD4,                                          00001080
//         BATLOAD5=&BATLOAD5,                                          00001090
//         UNIT=&UNIT,                                                  00001100
//         SPACE=&SPACE,                                                00001110
//         DISP=&DISP                                                   00001120
//*                                                                     00001130
//CUSOD210 DD DISP=SHR,                                                 00001140
//         DSN=&HIGHLVL..&ENVIR..&PLID&JOB..MTR.ORD.INPUT(+1)           00001150
//*                                                                     00001160
//CUSOD211 DD DISP=SHR,                                                 00001170
//         DSN=&HIGHLVL..&ENVIR..&PLID&JOB..LAST.RUNDATE                00001180
//*                                                                     00001190
//CUSOD212 DD DSN=&HIGHLVL..&ENVIR..&PLID&JOB..CURSO210(+1),            00001200
//         DISP=(MOD,CATLG,CATLG)                                       00001210
//*                                                                     00001220
