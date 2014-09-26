---Z24 OK线返修区
--OK线("108102010101"), 检测线("108102010102"),

---车辆数
select count(distinct q.vin) from FTT_QUALITYINFO q where q.repairStatusCode!=2 and q.coltStatCode in('108102010101','108102010102')
----问题总数
select sum(q.qstnNum) from FTT_QUALITYINFO q where q.repairStatusCode!=2 and q.coltStatCode in('108102010101','108102010102')
---责任部门  p.s. 空的话 转换为无部门
select q.BRCHSTATNCODE, q.BRCHSTATNNAME, sum(q.qstnNum) as QSTNNUM  
from FTT_QUALITYINFO q 
where q.repairStatusCode!=2 and q.coltStatCode in('108102010101','108102010102') 
group by q.BRCHSTATNCODE, q.BRCHSTATNNAME;
----序号/VIN/入区时间/待维修/待确认/已确认
select 
	q.vin as vin, 
	min(q.crtTime) as crtTime, 
	sum(q.qstnNum) as qstnNum,
   (select sum(qq.qstnNum) from FTT_QUALITYINFO qq where qq.vin=q.vin and qq.repairStatusCode=1) as unchecked, 
   (select sum(qq.qstnNum) from FTT_QUALITYINFO qq where qq.vin=q.vin and qq.repairStatusCode=2) as checked,
    case when min(q.repairStatusCode)=1 then '待确认' else '修理中' end as status
 from FTT_QUALITYINFO q
 where q.repairStatusCode!=2 and q.coltStatCode in('108102010101','108102010102')  group by  q.vin;
------颜色/车型配置/   for 循环 20次   ---- 有待改进
SELECT 
	distinct mc.COTEXT as COTEXT, concat(bm.BODYTYPE, bm.WEIBIAO) as PEIZHI
from PP_VINGENERATE v 
	LEFT JOIN  PP_MANUORDER mo ON  mo.MONUM = v.MONNUM
	LEFT JOIN BA_MATERIAL bm ON bm.MTCODE = mo.MTCODE 
	LEFT JOIN MD_COLOUR mc ON mc.COCODE = SUBSTR(bm.MTCODE, (LENGTH(bm.MTCODE)-2),3)
where  v.PRDSEQ='L6T7944Z8EN000084'