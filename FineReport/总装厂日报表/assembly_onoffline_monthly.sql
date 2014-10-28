function assembly_onoffline_monthly(i_plcode in varchar2, 
                                                   i_stcode in varchar2,
                                                   i_mttext3 in varchar2,
                                                   i_mttext4 in varchar2,
                                                   i_crtime in date) return number
is
  o_sum_moqty varchar2(22);
/*
 * *********************************************
 * Name: assembly_onoffline_monthly(i_plcode,i_stcode,i_mttext3,i_mttext4,i_crtime)
 * Description: get assembly online or offline monthly records. (between 2014-10-01 00:00:00 to icrtime)
 * Parameter:
			 i_plcode ZZ0101
			 i_stcode T00 or F23
			 i_mttext3 KC-1
			 i_mttext4 KC1
			 i_crtime 2014-10-27 00:00:00
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue  create this function
 
 *********************************************
 *
 **/
begin
  select 
    sum(vc.MOQTY) into o_sum_moqty
  from pp_vehconf vc
    inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = i_plcode
       inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = i_stcode
   		and mt.mttext3 = i_mttext3
   		and mt.mttext4 = i_mttext4
   		and format_crtime(vc.crtime) between 
          to_date(to_char(i_crtime,'yyyy-mm')||'-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss')
          and i_crtime;
  return to_number(NVL(o_sum_moqty,'0'));
end assembly_onoffline_monthly;
