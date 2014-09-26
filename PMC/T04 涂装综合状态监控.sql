----------------T04 涂装综合状态监控
--------计划CT?
--------实际CT?
------生产计划
SELECT SUM(PROSCHEDULNUM) as MOQTYS 
FROM PP_MANUDETAIL 
WHERE FCCODE = 1081 AND PLCODE = 'TZ0101'
and (PROSCHEDULDATE  = to_char(sysdate,'yyyy-MM-dd') OR (PROSCHEDULDATE IS NULL AND PSDATE = to_char(sysdate,'yyyy-MM-dd')))
-----生产实际
SELECT SUM(MOQTY) as MOQTYS FROM PP_VEHCONF WHERE FCCODE = 1081
AND PLCODE = 'PBS01' and CRTIME  >= to_char(sysdate,'yyyy-MM-dd')

----在制品 --- 代码有错误
--前处理("T010"),
--PVC("T020"),
--中涂线("T030"),
--面漆线("T040"),
--报交线("T050"),
--------上线  和 下线
select STCODE as STCODE, sum(MOQTY) as MOQTYS from PP_VEHCONF 
where FCCODE=1081 and PLCODE in('TZ0101','PBS01') and CRTIME >= to_char(sysdate,'yyyy-MM-dd')
group by STCODE
--------在制品
select STCODE as STCODE, sum(MOQTY) as MOQTYS from PP_VEHINFO 
where FCCODE=1081 and PLCODE in ('TZ0101','PBS01')  and STCODE != 'ENDS' group by STCODE
----质量状态
	--获取返修记录啊A,B,C分组
	--焊涂转挂 TZ02/电泳打磨TZ05/电泳钣金TZ04/中涂打磨TZ03/大修打磨TZ01/面漆修理TZ2/
select 
	record_.INSPECTIONTYPECODE, 
	record_.SERVERITY, 
	count(record_.ID) as NUM
from QM_REPAIRRECORD record_ 
where record_.SITECODE = 1081 
	and record_.REPAIRTYPECODE != 2
	and record_.INSPECTIONTYPECODE LIKE '%TZ%'
GROUP BY 
	record_.INSPECTIONTYPECODE,
	record_.SERVERITY;
------------------
---TopN
select record_.FAILURESYMPTOMCODE, tom_.SYMPTOMTEXT, count(record_.ID) AS NUM 
FROM QM_REPAIRRECORD record_ 
INNER JOIN QM_FAILURESYMPTOM tom_ ON record_.FAILURESYMPTOMCODE = tom_.SYMPTOMCODE
WHERE record_.REPAIRTYPECODE != 2 AND record_.SITECODE = 1081 and record_.INSPECTIONTYPECODE LIKE '%TZ%'
GROUP BY record_.FAILURESYMPTOMCODE, tom_.SYMPTOMTEXT 
ORDER BY count(record_.ID) DESC;




