PROCEDURE pro_rpt_ftt2
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);
/*
 * *********************************************
 * Name: pro_rpt_ftt2(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build FTT2 data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG
       
 ******************************************************************************************     
 * Verions   date  eidtor  description
 1.0.0    2014-11-03  kexue create this procedure
 1.0.1 	  2014-11-03  kexue update issueCars "sum(distinct vin)" and add offlinecars "OK offline"
 ******************************************************************************************
 *
 * Test SQL:
 * declare
	aa varchar2(255);
	bb varchar2(255);
   begin
  	pro_rpt_ftt2(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_FTT2;
   INSERT INTO RPT_FTT2
	(SITECODE, PRODUCTIONDATE, BRCHSTATNCODE, BRCHSTATNNAME, FTTVALUE, CLOSEDRATE, ISSUECARS, OFFLINECARS)
	select 
		'1081',
		to_date(productiondate,'yyyy-mm-dd hh24:mi:ss'),
		objcode,
		objname, 
		decode(total_OK_in,0,'0',round(total_issue/total_OK_in, 4)) as FTTValue,
		decode(total_OK_in,0,'0',round(ftt2_repair_ok(objcode,productiondate)/total_OK_in, 4)) as CLOSEDRATE,
		total_issue,
		total_OK_in
	from (
	 select productiondate,objcode,objname,total_OK_in,count(vin) as total_issue
	 from (
	 select 
			distinct 
			to_char(fttqi.crttime,'yyyy-mm-dd') productiondate,
		  	fttpbd.objcode,
			fttpbd.objname,
		    fttqi.vin,
		    ftt_ok_daily(to_date(to_char(fttqi.crttime, 'yyyy-mm-dd')||' 00:00:00' , 'yyyy-mm-dd hh24:mi:ss')) as total_OK_in
		from ftt_qualityinfo fttqi inner join ftt_prdbasedata fttpbd on fttpbd.objcode  = fttqi.brchstatncode
			)
	group by productiondate,objcode,objname,total_OK_in
	);

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;