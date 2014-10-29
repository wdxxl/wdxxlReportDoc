create or replace function trends_plan_addup_daily(
                                   i_plcode in varchar2 ,
                                   i_crtime in date ) return number
is
  o_sum_proschedulnum varchar2 (22);
/*
 * *********************************************
 * Name: trends_plan_addup_daily(i_plcode,i_crtime)
 * Description: get production trends plan daily addup records. (i_crtime)
 * Parameter:
       i_plcode ZZ0101
       i_crtime 2014-10-27 00:00:00
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-29  kexue  create this procedure

 ******************************************************************************************
 * Test SQL:
 * select trends_plan_addup_daily('ZZ0101',format_crtime('2014-05-11 06:00:00')) from dual;
 **/
begin
  select
    sum (PROSCHEDULNUM) into o_sum_proschedulnum
  from
      PP_MANUDETAIL
  where
      plcode = i_plcode
      and format_crtime(decode(NVL(PROSCHEDULDATE, '0'), '0' ,PSDATE||' 00:00:00', PROSCHEDULDATE)) = i_crtime;
  return to_number(NVL(o_sum_proschedulnum,'0'));
end trends_plan_addup_daily;
