PROCEDURE pro_rpt_qualityissuetop
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);
/*
 * *********************************************
 * Name: pro_rpt_qualityissuetop(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build FTT quality issue top data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG
       
 ******************************************************************************************     
 * Verions   date  eidtor  description
 1.0.0    2014-11-04  kexue create this procedure (monthly)
 ******************************************************************************************
 *
 * Test SQL:
 * declare
	aa varchar2(255);
	bb varchar2(255);
   begin
  	pro_rpt_qualityissuetop(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_QUALITYISSUETOP where PRODUCTIONMONTH = to_number(to_char(sysdate,'yyyymm'));
   
   INSERT INTO MESRPT.RPT_QUALITYISSUETOP
	(SITECODE, PRODUCTIONMONTH, ORDINAL, COMPCODE, POSITIONCODE, FAILSYMPCODE, COMPNAME, 
	POSITIONNAME, FAILSYMPTEXT, SERSDEGREE, FREQUENCY)
	select
		table1.factorycode,
		table1.productionmonth,
		rownum ORDINAL,
		table1.compcode,
		table1.positioncode,
		table1.failsympcode,
		table1.compname,
		table1.positionname,
		table1.failsymptext,
		table1.sersdegree,
		table1.frequency
	from
	(select 
		factorycode,
		to_char(crttime,'yyyymm') productionmonth,
		compcode,
		compname,
		positioncode,
		positionname,
		failsympcode, 
		failsymptext,
		sersdegree,
		sum(QSTNNUM) frequency
	from ftt_qualityinfo
	where to_char(crttime,'yyyymm') = to_char(sysdate,'yyyymm')
	group by factorycode,to_char(crttime,'yyyymm'),compcode,compname,positioncode,positionname,failsympcode,failsymptext,sersdegree
	order by to_char(crttime,'yyyymm') asc,frequency desc
	) table1;

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;