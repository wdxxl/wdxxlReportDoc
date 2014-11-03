function ftt2_repair_ok(i_objcode in varchar2,
						i_productiondate in varchar2) return number
is
  o_sum_qstnnum number;
  v_ok_qstnnum varchar2(22);
  v_all_qstnnum varchar2(22);
/*
 * *********************************************
 * Name: ftt2_repair_ok(i_objcode,i_productiondate)
 * Description: get percentage of FTT2 repaired records in all records. (i_objcode,i_productiondate)
 * Parameter:
			 i_objcode 108104
			 i_productiondate 2014-09-19
			 
 ******************************************************************************************			 
 * Verions   date  eidtor  description
 1.0.0    2014-11-03  kexue  create this function;
 1.0.1    2014-11-03  kexue  use distinct count VIN as the repaired car numbers;
 1.0.2    2014-11-03  kexue  get rate for qstnnum of 2 in qstnnum with all record;
 ******************************************************************************************
 *
 * Test SQL:
 * select ftt2_repair_ok('108104','2014-09-19') from dual;
 **/
begin
	select
		sum(fttqi.qstnnum) into v_ok_qstnnum
	from 
		 ftt_qualityinfo fttqi 
	where fttqi.repairstatuscode = 2 
		 and to_char(fttqi.crttime,'yyyy-mm-dd') = i_productiondate
		 and fttqi.brchstatncode = i_objcode;

	select
		sum(fttqi.qstnnum) into v_all_qstnnum
	from 
		 ftt_qualityinfo fttqi 
	where to_char(fttqi.crttime,'yyyy-mm-dd') = i_productiondate
		 and fttqi.brchstatncode = i_objcode;
	
	  IF nvl(v_all_qstnnum,0) = 0 THEN
	      o_sum_qstnnum:= 0;
	  ELSIF nvl(v_ok_qstnnum,0) = 0 THEN
	      o_sum_qstnnum:= 0;
	  ELSE 
	  	o_sum_qstnnum:= round(to_number(v_ok_qstnnum)/to_number(v_all_qstnnum), 4);
	  End IF;

  return o_sum_qstnnum;
end ftt2_repair_ok;