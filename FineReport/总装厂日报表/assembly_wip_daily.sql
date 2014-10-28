function assembly_wip_daily(i_plcode in varchar2,
                            i_stcode_t00 in varchar2,
                            i_stcode_f23 in varchar2,
                            i_mtcode in varchar2,
                            i_crtime in date ) return number
is
  o_sum_moqty_t00 varchar2 (22);
  o_sum_moqty_f23 varchar2 (22);
/*
 * *********************************************
 * Name: assembly_wip_daily(i_plcode,i_stcode_t00,i_stcode_f23,i_mtcode,i_crtime)
 * Description: get assembly online or offline daily records. (i_crtime)
 * Parameter:
			 i_plcode ZZ0101
			 i_stcode_t00 T00
       	     i_stcode_f23 F23
			 i_mtcode 'Z99KC135LET9NW0K10'
			 i_crtime 2014-10-27 00:00:00
			 
 ******************************************************************************************			 
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue  create this function
 1.0.1	  2014-10-28  kexue  update parameter use 'mtcode' instead of 'mttext3' and 'mttext4';
 ******************************************************************************************
 *
 * Test SQL:
 * select assembly_wip_daily('ZZ0101','T00','F23','Z99KC135LET9NW0K10',format_crtime('2014-08-15 06:00:00')) from dual;
 **/
begin
  --T00
  select
    sum(vc.MOQTY) into o_sum_moqty_t00
  from pp_vehconf vc
    inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = i_plcode
   	where vc.stcode = i_stcode_t00
   		and mo.mtcode = i_mtcode
   		and format_crtime(vc.crtime) <= i_crtime;
   --F23
  select
    sum(vc.MOQTY) into o_sum_moqty_f23
  from pp_vehconf vc
    inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = i_plcode
   	where vc.stcode = i_stcode_f23
   		and mo.mtcode = i_mtcode
   		and format_crtime(vc.crtime) <= i_crtime;

  return to_number(nvl(o_sum_moqty_t00,'0') - nvl(o_sum_moqty_f23,'0'));
end assembly_wip_daily;
