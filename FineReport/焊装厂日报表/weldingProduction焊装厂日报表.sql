------焊装厂  参考信息
select * from pp_vehconf;
--stcode 操作工位
--crttime 生产时间
select * from ba_material where mttext4 is not null;
--mtcode 物料编码   ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10')
--mttext4 产品型号  - 车型  ('KC-1','KC1')
--mttext3 产品系列 - 车系 ('KC1','MR7183C01')
select * from pp_manuorder where plcode = 'HZ0101' and mtcode in ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10');
--mtcode 物料编码  ('Z99KC1340BT8000A05','Z99KC1330BH9000K10','Z99KC135LET9NW0K10')
--monum 生产订单号  ('600000338','PO20140530','062401','600000291','2014060401') 等等
--plcode 流水线  HZ0101

-------Step1 表数据初步结构建立 ---
select distinct
 	mt.mttext3 as CARFAMILYTEXT,
 	mt.mttext4 as CARTYPETEXT,
 	to_date(vc.crtime,'yyyy-mm-dd hh24:mi:ss') AS PRODUCTIONDATE
from pp_vehconf vc
   inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'HZ0101'
   inner join ba_material mt on mt.mtcode = mo.mtcode
   where vc.stcode in ('WBS', 'T010') and mt.mttext4 is not null
   order by mt.mttext3;

------Step2 其他信息填充
 
   