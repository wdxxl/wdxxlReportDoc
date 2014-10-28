﻿-----总装厂 Assembly Production 参考信息
select * from pp_vehconf;
--stcode 操作工位
--crttime 生产时间
select * from ba_material where mttext4 is not null;
--mtcode 物料编码   ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10')
--mttext4 产品型号  - 车型  ('KC-1','KC1')
--mttext3 产品系列 - 车系 ('KC1','MR7183C01')
select * from pp_manuorder where plcode = 'ZZ0101' and mtcode in ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10');
--mtcode 物料编码  ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10')
--monum 生产订单号  ('600000303','600000371','600000338','1111111111','600000331') 等等
--plcode 流水线  HZ0101
select * from md_colour;
--COCODE ('B07','B05','A05','D06','C11','E10','K11','K10')
--COTEXT ('墨玉黑','紫钻黑','冰晶白','珍珠银','玄武灰','珊瑚红','琉璃金','闪晶棕')
--------------------------------时间函数计算 ---------------------------------------------------
select sysdate from dual; --- 2014-10-23 22:28:08
select to_date((to_char(sysdate,'yyyy-mm-dd') ||' 05:59:00'),'yyyy-mm-dd hh24:mi:ss')  from dual; --2014-10-23 05:59:00
select 
	case
	when sysdate < to_date((to_char(sysdate,'yyyy-mm-dd') ||' 05:59:00'),'yyyy-mm-dd hh24:mi:ss')  
		then to_char(trunc(SYSDATE-1),'yyyy-mm-dd')
	else to_char(sysdate,'yyyy-mm-dd hh24:mi:ss')
end case
from dual;
--------2014-10-23 22:29:00
select
	case when '2014-10-23 22:28:08' > '2014-10-23 05:59:00' then 'aaa'
	else vc.crtime
	end case 
from pp_vehconf vc
-----------
select to_char(to_date(vc.crtime,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd') from pp_vehconf vc;
--------
select sysdate,
	case 
	when vc.crtime > to_char(to_date(vc.crtime,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd')||' 05:59:00' 
		then to_char(to_date(vc.crtime,'yyyy-mm-dd hh24:mi:ss'),'yyyy-mm-dd')
	else to_char(trunc(to_date(vc.crtime,'yyyy-mm-dd hh24:mi:ss')-1),'yyyy-mm-dd')
	end case ,sysdate
from pp_vehconf vc
------------------------------------------------------------------------------------------------------
-------Step1 表数据初步结构建立 ----------------------------------------------------------------------------
select distinct
	vc.fccode as sitecode, --工厂
 	mt.mttext3 as CARFAMILYTEXT, --车系
 	mt.mttext4 as CARTYPETEXT, -- 车型
 	format_crtime(vc.crtime), --调用函数 时间
 	cl.cocode, --颜色编号
 	cl.cotext, --颜色
 	mt.mtcode  --物料编码
from pp_vehconf vc
   inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   inner join ba_material mt on mt.mtcode = mo.mtcode
   inner join md_colour cl on substr(mt.mtcode, -3, 3) = cl.cocode
where vc.stcode in ('T00','T01','C01','F01','F23') and mt.mttext4 is not null
   order by mt.mttext3;
------Step2 其他信息填充-----------------------------------------------------------------------------
--1,2,3 done
--4. 本年PBS进车累计
	select 
		sum(MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'PBS' 
   		and mt.mttext3 = ? 
   		and mt.mttext4 = ? 
   		and format_crtime(vc.crtime) between ? and ? -- 游标传入参数时间
--5 question to be confirm
--6. 本年累计上线
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'T00' 
   		and mt.mttext3 = ?
   		and mt.mttext4 = ? 
   		and format_crtime(vc.crtime) between ? and ?
--7. 本年累计下线
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'F23' 
   		and mt.mttext3 = ?
   		and mt.mttext4 = ? 
   		and format_crtime(vc.crtime) between ? and ?
--8. 本月每日计划累计
	select assembly_plan_addup_monthly('1081','ZZ0101','Z99KC1330BH9000A05',format_crtime('2014-10-27 00:00:00')) from dual;
--9. PBS进车累计

--15. 当日上线
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'T00' 
   		and mt.mttext3 = ? 
   		and mt.mttext4 = ?
   		and format_crtime(vc.crtime) = ?  -- 游标传入参数时间
	--例子: 
	/*
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'T00' 
   		and mt.mttext3 = 'KC-1' 
   		and mt.mttext4 = 'KC1' 
   		and format_crtime(vc.crtime) = to_date('2014-08-15 00:00:00','yyyy-mm-dd hh24:mi:ss') 
  	*/
    -- select assembly_onoffline_daily('ZZ0101','T00','KC-1','KC1',to_date('2014-08-15 00:00:00','yyyy-mm-dd hh24:mi:ss') ) from dual;
--16. 当日下线
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'F23' 
   		and mt.mttext3 = ? 
   		and mt.mttext4 = ?
   		and format_crtime(vc.crtime) = ? -- 游标传入参数时间
   --例子: 
	/*
	select 
		sum(vc.MOQTY) 
	from pp_vehconf vc
		inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
   		inner join ba_material mt on mt.mtcode = mo.mtcode
   	where vc.stcode = 'F23' 
   		and mt.mttext3 = 'KC-1' 
   		and mt.mttext4 = 'KC1' 
   		and format_crtime(vc.crtime) = to_date('2014-08-15 00:00:00','yyyy-mm-dd hh24:mi:ss') 
  	*/
   		
 