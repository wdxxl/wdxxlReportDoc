function ftt2_repair_all(i_objcode in varchar2,
											i_productiondate in varchar2) return number
is
  v_all_qstnnum varchar2(22);
/*
 * *********************************************
 * Name: ftt2_repair_all(i_objcode,i_productiondate)
 * Description: get of FTT2 in all issue records. (i_objcode,i_productiondate)
 * Parameter:
			 i_objcode 108104
			 i_productiondate 2014-09-19
			 
 ******************************************************************************************			 
 * Verions   date  eidtor  description
 1.0.0    2014-11-03  kexue  create this function;
 ******************************************************************************************
 *
 * Test SQL:
 * select ftt2_repair_all('108104','2014-09-19') from dual;
 **/
begin
	select
		sum(fttqi.qstnnum) into v_all_qstnnum
	from 
		 ftt_qualityinfo fttqi 
	where to_char(fttqi.crttime,'yyyy-mm-dd') = i_productiondate
		 and fttqi.brchstatncode = i_objcode;

  return to_number(nvl(v_all_qstnnum,0));
end ftt2_repair_all;