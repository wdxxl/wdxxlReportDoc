参考SQL:
--日计划   (HZ0101/TZ0101/ZZ0101)
select plcode as plcode, sum(PROSCHEDULNUM) as sumPROSCHEDULNUM from PP_MANUDETAIL 
where  fccode = 1081 and decode(NVL(PROSCHEDULDATE,'0'),'0',PSDATE, PROSCHEDULDATE) = to_char(sysdate,'yyyy-MM-dd') 
group by plcode;
--日完成/上线/下线/
select stcode as stcode, sum(MOQTY)as summoqty from pp_vehconf 
where STCODE != 'ENDS' and fccode = 1081 and  substr(crtime, 0, 10) = to_char(sysdate,'yyyy-MM-dd') group by stcode;
--节拍偏移 之 标准节拍 (HZ0101/TZ0101/ZZ0101)
select PLCODE, PPTAKT from md_pipeline where fccode = 1081;
--在制品
select stcode as stcode, sum(moqty)as summoqty from pp_vehinfo 
where STCODE != 'ENDS' and fccode = 1081 group by stcode order by stcode;
--月计划
select HZMPLAN, TZMPLAN, ZZMPLAN from PP_MonPlan 
where fccode = 1310 and month = to_char(to_date('2013-07-12','yyyy-mm-dd'),'yyyy-MM');
--月完成/月入库  
select stcode as stcode, sum(MOQTY)as summoqty from pp_vehconf 
where STCODE != 'ENDS' and fccode = 1081 and substr(crtime, 0, 7) = to_char(sysdate,'yyyy-MM')
group by stcode;