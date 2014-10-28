function assembly_onoffline_daily(i_plcode in varchar2, 
                                  i_stcode in varchar2,
                                  i_mtcode in varchar2,
                                  i_crtime in date) return number
is
  o_sum_moqty varchar2(22);
/*
 * *********************************************
 * Name: assembly_onoffline_daily(i_plcode,i_stcode,i_mtcode,i_crtime)
 * Description: get assembly online or offline daily records. (i_crtime)
 * Parameter:
			 i_plcode ZZ0101
			 i_stcode T00 or F23
			 i_mtcode 'Z99KC135LET9NW0K10'
			 i_crtime 2014-10-27 00:00:00
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue  create this function
 1.0.1	  2014-10-28  kexue  update parameter use 'mtcode' instead of 'mttext3' and 'mttext4';
 ******************************************************************************************
 *
 * Test SQL:
 * select assembly_onoffline_daily('ZZ0101','T00','Z99KC135LET9NW0K10',format_crtime('2014-08-15 06:00:00')) from dual;
 **/
begin
  select 
    sum(vc.MOQTY) into o_sum_moqty
  from pp_vehconf vc
    inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = i_plcode
   	where vc.stcode = i_stcode
   		and mo.mtcode = i_mtcode
   		and format_crtime(vc.crtime) = i_crtime;
  return to_number(NVL(o_sum_moqty,'0'));
end assembly_onoffline_daily;
