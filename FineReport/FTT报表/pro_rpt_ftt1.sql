PROCEDURE pro_rpt_ftt1
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);
/*
 * *********************************************
 * Name: pro_rpt_ftt1(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build FTT1 data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG
       
 ******************************************************************************************     
 * Verions   date  eidtor  description
 1.0.0    2014-11-03  kexue create this procedure
 1.0.1    2014-11-03  kexue update FTTvalue for display, formated as '0.1234' rather than '12.34'
 ******************************************************************************************
 *
 * Test SQL:
 * declare
	aa varchar2(255);
	bb varchar2(255);
   begin
  	pro_rpt_ftt1(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_FTT1;
   INSERT INTO RPT_FTT1
   (SITECODE, PRODUCTIONDATE, FTTVALUE)
  select 
    '1081',
    to_date(productiondate, 'yyyy-mm-dd hh24:mi:ss') productiondate,
    decode(b,0,'0',round(a/b,4)) as FTTValue
  from
  (select
    to_char(crttime,'yyyy-mm-dd') productiondate,
    sum(QSTNNUM) as a,
    ftt_ok_daily(to_date(to_char(crttime,'yyyy-mm-dd')||' 00:00:00', 'yyyy-mm-dd hh24:mi:ss')) as b
  from ftt_qualityinfo 
  group by to_char(crttime,'yyyy-mm-dd'));

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;