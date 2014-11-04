PROCEDURE pro_rpt_qualityissue
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);
/*
 * *********************************************
 * Name: pro_rpt_qualityissue(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build FTT3 quality issue data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG
       
 ******************************************************************************************     
 * Verions   date  eidtor  description
 1.0.0    2014-11-04  kexue create this procedure
 ******************************************************************************************
 *
 * Test SQL:
 * declare
	aa varchar2(255);
	bb varchar2(255);
   begin
  	pro_rpt_qualityissue(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_QUALITYISSUE;
   
   INSERT INTO RPT_QUALITYISSUE
	(ID, 
	 SITECODE, 
	 VIN, 
	 COMPCODE, 
	 POSITIONCODE,   ---5
	 FAILSYMPCODE, 
	 SERSDEGREE,
	 QSTNNUM, 
	 COLTSTATCODE, 
	 CRTUSER, 		 ---10
	 CRTTIME, 
	 STATE, 
	 MDFUSER, 
	 MDFTIME,
	 ZRTYPE, 		---15
	 OPRTSTATN,
	 OPRTMAN, 
	 OPRTEXTN,
	 TESTSTATN, 
	 TESTMAN, 		---20
	 TESTEXTN, 
	 DISVSTATN, 
	 DISVMAN, 
	 DISVEXTN, 
	 CONSFZR, 		---25
	 CONSFZREXTN, 
	 BRCHFZR, 
	 BRCHFZREXTN, 
	 BASEFZR, 
	 BASEFZREXTN,	---30
	 DECIDEMAN, 
	 SAVETIME, 
	 DECIDETIME,
	 POSITIONNAME, 
	 FAILSYMPTEXT,	---35
	 NEWFIALSYMP, 
	 EXTN, 
	 ENDTIME, 
	 COMPNAME,
	 COLTSTATNAME, 	---40	
	 OPRTSTATNCODE, 
	 TESTSTATNCODE, 
	 CRTUSERNAME, 
	 MDFUSERNAME, 
	 COLLECTTYPE, 	---45
	 DISVSTATNNAME,
	 DISVMANNAME, 
	 ISFRACAS, 
	 UNFREEZEDATE, 
	 REPAIRDESP, 	---50
	 REPAIRRESULT, 
	 REPAIRMAN, 
	 REPAIRDATE, 
	 REPAIRCONFUN, 
	 REPAIRCONFURN, ---55
	 REPAIRCONFTIME, 
	 CARTYPE, 			
	 CONSSTATNCODE, 
	 CONSSTATNNAME, 
	 BRCHSTATNCODE, ---60
	 BRCHSTATNNAME,
	 BASESTATNCODE, 
	 BASESTATNNAME, 
	 REPAIRSTATUSCODE, 
	 REPAIRTYPECODE, ---65
	 CONFIRMTEXT)
	select
		fttqi.ID, 
		fttqi.FACTORYCODE, 
		fttqi.VIN, 
		fttqi.COMPCODE,
		fttqi.POSITIONCODE,   ---5
		fttqi.FAILSYMPCODE,
		fttqi.SERSDEGREE,
		fttqi.QSTNNUM,
		fttqi.COLTSTATCODE,
		fttqi.CRTUSER, 		---10
		fttqi.CRTTIME,
		fttqi.STATE,
		fttqi.MDFUSER,
		fttqi.MDFTIME,
		fttqi.ZRTYPE,			---15
		fttqi.OPRTSTATN,
		fttqi.OPRTMAN,
		fttqi.OPRTEXTN,
		fttqi.TESTSTATN,
		fttqi.TESTMAN,		---20
		fttqi.TESTEXTN,
		fttqi.DISVSTATN,
		fttqi.DISVMAN,
		fttqi.DISVEXTN,
		fttqi.CONSFZR,		---25
		fttqi.CONSFZREXTN,
		fttqi.BRCHFZR, 
		fttqi.BRCHFZREXTN,
		fttqi.BASEFZR,
		fttqi.BASEFZREXTN,	---30
		fttqi.DECIDEMAN, 
		fttqi.SAVETIME, 
		fttqi.DECIDETIME,
		fttqi.POSITIONNAME,
		fttqi.FAILSYMPTEXT,	---35
		fttqi.NEWFIALSYMP, 
		fttqi.EXTN, 
		fttqi.ENDTIME, 
		fttqi.COMPNAME, 
		fttqi.COLTSTATNAME, 	---40	
		fttqi.OPRTSTATNCODE,
		fttqi.TESTSTATNCODE,
		fttqi.CRTUSERNAME,
		fttqi.MDFUSERNAME,
		fttqi.COLLECTTYPE,	---45
		fttqi.DISVSTATNNAME,
		fttqi.DISVMANNAME, 
		fttqi.ISFRACAS, 
		fttqi.UNFREEZEDATE,
		fttqi.REPAIRDESP, 	---50
		fttqi.REPAIRRESULT,
		fttqi.REPAIRMAN,
		fttqi.REPAIRDATE,
		fttqi.REPAIRCONFUN,
		fttqi.REPAIRCONFURN,	---55
		fttqi.REPAIRCONFTIME,
		fttqi.CARTYPE,
		fttqi.CONSSTATNCODE,
		fttqi.CONSSTATNNAME,
		fttqi.BRCHSTATNCODE, ---60
		fttpbd.OBJNAME as brchstatnname,
		fttqi.BASESTATNCODE, 
		fttqi.BASESTATNNAME, 
		fttqi.REPAIRSTATUSCODE, 
		fttqi.REPAIRTYPECODE, ---65
		fttqi.CONFIRMTEXT
	from ftt_qualityinfo fttqi inner join ftt_prdbasedata fttpbd on fttqi.BRCHSTATNCODE = fttpbd.OBJCODE;

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;