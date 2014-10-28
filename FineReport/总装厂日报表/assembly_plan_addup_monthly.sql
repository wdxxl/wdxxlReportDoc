function assembly_plan_addup_monthly(i_fccode in varchar2,
                                     i_plcode in varchar2,
                                     i_mtcode in varchar2,
                                     i_crtime in date) return number
is
  o_sum_proschedulnum varchar2(22);
/*
 * *********************************************
 * Name: assembly_plan_addup_monthly(i_fccode,i_plcode,i_mtcode,i_crtime)
 * Description: get assembly plan monthly addup records. (i_crtime)
 * Parameter:
       i_fccode 1081
       i_plcode ZZ0101
       i_mtcode Z99KC1330BH9000A05
       i_crtime 2014-10-27 00:00:00
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue  create this function

 ******************************************************************************************
 *
 **/
begin
 select
    sum(PROSCHEDULNUM) into o_sum_proschedulnum
 from 
 	PP_MANUDETAIL
 where
      fccode = i_fccode
	  and plcode = i_plcode
	  and mtcode = i_mtcode
	  and format_crtime(decode(NVL(PROSCHEDULDATE,'0'),'0',PSDATE||' 00:00:00', PROSCHEDULDATE))
          between to_date(to_char(i_crtime, 'yyyy-mm')|| '-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss') and i_crtime;
  return to_number(NVL(o_sum_proschedulnum,'0'));
end assembly_plan_addup_monthly;
