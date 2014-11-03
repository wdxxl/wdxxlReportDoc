function ftt2_repair_ok(i_objcode in varchar2,
						i_productiondate in varchar2) return number
is
  o_sum_qstnnum varchar2 (22);
/*
 * *********************************************
 * Name: ftt2_repair_ok(i_objcode,i_productiondate)
 * Description: get FTT2 repaired records. (i_objcode,i_productiondate)
 * Parameter:
			 i_objcode 108104
			 i_productiondate 2014-09-19
			 
 ******************************************************************************************			 
 * Verions   date  eidtor  description
 1.0.0    2014-11-03  kexue  create this function;
 ******************************************************************************************
 *
 * Test SQL:
 * select ftt2_repair_ok('108104','2014-09-19') from dual;
 **/
begin
  select
	sum(fttqi.QSTNNUM) into o_sum_qstnnum
  from 
  	ftt_qualityinfo fttqi 
  where fttqi.repairstatuscode = 2 
  	and to_char(fttqi.crttime,'yyyy-mm-dd') = i_productiondate
  	and fttqi.brchstatncode = i_objcode;
  return to_number(nvl(o_sum_qstnnum,'0'));
end ftt2_repair_ok;