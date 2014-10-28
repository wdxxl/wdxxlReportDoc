function format_crtime(i_crttime IN varchar2)
  return date AS
  out_formatted_date varchar2(20);
/*
 * *********************************************
 * Name: format_crtime(i_crttime IN varchar2)
 * Description: format create date time.
 * Parameter: i_crttime create datetime
 * Example
              1. Input '2014-10-27 06:00:00' Output '2014-10-27 00:00:00'
              2. Input '2014-10-27 05:59:59' Output '2014-10-26 00:00:00'
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue  create this function
 
 *********************************************
 *
 **/
begin
  select
  	case
	when i_crttime > to_char(to_date(i_crttime,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd')||' 05:59:59' 
		then to_char(to_date(i_crttime,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd')
	else to_char(trunc(to_date(i_crttime,'yyyy-mm-dd hh24:mi:ss')-1),'yyyy-mm-dd')
	end case
    into out_formatted_date
    from dual;
  return to_date(out_formatted_date,'yyyy-mm-dd');
end format_crtime;