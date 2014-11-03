function ftt_ok_daily(i_crtime in date) return number
is
  o_sum_moqty_ok varchar2 (22);
/*
 * *********************************************
 * Name: ftt_ok_daily(i_crtime)
 * Description: get FTT line of 'OK' online daily records. (i_crtime)
 * Parameter:
			 i_crtime 2014-10-27 00:00:00
			 
 ******************************************************************************************			 
 * Verions   date  eidtor  description
 1.0.0    2014-10-31  kexue  create this function;
 ******************************************************************************************
 *
 * Test SQL:
 * select ftt_ok_daily(format_crtime('2014-08-15 06:00:00')) from dual;
 **/
begin
  --OK
  select
    sum(vc.MOQTY) into o_sum_moqty_ok
  from pp_vehconf vc
  where vc.stcode = 'OK'
   		and format_crtime(vc.crtime) = i_crtime;
  return to_number(nvl(o_sum_moqty_ok,'0'));
end ftt_ok_daily;