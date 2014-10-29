CREATE OR REPLACE PROCEDURE pro_rpt_PRODUCTIONTREND
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);

/*
 * *********************************************
 * Name: pro_rpt_PRODUCTIONTREND(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build production trend data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG

 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-29  kexue create this procedure

 ******************************************************************************************
 *
 * Test SQL:
 * declare
  aa varchar2(255);
  bb varchar2(255);
   begin
    pro_rpt_PRODUCTIONTREND(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_PRODUCTIONTREND;

   INSERT INTO RPT_PRODUCTIONTREND
    (PRODUCTIONDATE, SHOPCODE, PLANQUANTITY, COMPLETEQUANTITY)
    select actual.fcrtime as PRODUCTIONDATE,
            actual.plcode as SHOPCODE,
            trends_plan_addup_daily(actual.plcode, actual.fcrtime) as PLANQUANTITY,
            actual.summoqty as COMPLETEQUANTITY
       from (select decode(plcode,
                           'ZZ0101',
                           'ZZ0101',
                           decode(plcode, 'WBS01', 'HZ0101', 'TZ0101')) as plcode,
                    format_crtime(crtime) fcrtime,
                    sum(moqty) summoqty
               from pp_vehconf
              where (stcode like 'PBS%')
                 or (stcode in ('WBS', 'F23'))
              group by plcode, stcode, format_crtime(crtime)) actual;

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;
