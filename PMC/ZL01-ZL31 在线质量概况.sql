---------------------(ZL01 All)/(ZL31 总装) 在线质量概况
---症状数量/未闭环症状 A B C 计算
select * from FTT_QUALITYINFO info where info.factoryCode = 1081 and info.crtTime >= sysdate

/*
WBS入("10810401001"),
报交("10810401002"),
OK线("108102010101"),
检测线("108102010102"),
路试("108102010103"),
淋雨("108102010104"),
商检("108102010105");
  */
---------交检合格率 = 合格的车数/总车数
---------单台不良率=不合格的问题数/总车数
------------获取总车数
select info.coltStatCode as coltStatCode, count(distinct info.vin) as num
from FTT_QUALITYINFO info 
where info.factoryCode = 1081 and info.crtTime >= sysdate group by info.coltStatCode;
------------合格车辆数
select info.coltStatCode as coltStatCode, count(distinct info.vin) as num 
from FTT_QUALITYINFO info
where info.factoryCode = 1081 and info.crtTime >= sysdate and 
not exists(select 1 from FTT_QUALITYINFO info2 
	where info2.vin=info.vin and info2.coltStatCode=info.coltStatCode 
	and info2.sersdeGree is not null)  
group by info.coltStatCode;
-----------不合格问题数
select info.coltStatCode as coltStatCode, sum(info.qstnNum) as num 
from FTT_QUALITYINFO info
where info.factoryCode =  1081 and info.crtTime >= sysdate
and info.sersdeGree is not null 
group by info.coltStatCode;


--------------------------------------
--TopN All '10810401001','10810401002','108102010101','108102010102','108102010103','108102010104','108102010105'
--Top ZZ '108102010101','108102010102','108102010103','108102010104','108102010105'
select info.compCode, 
	info.positionCode, 
	info.failSympCode, 
	count(info.qstnNum) as qstnNum,
	concat(concat(concat(concat(info.compName,'<font color=red>@</font>'),info.positionName),'<font color=red>@</font>'),
   	sysmptoms.failSympText) as description 
from FTT_QUALITYINFO info 
	inner join FTT_FAILTURESYMPTOMS sysmptoms on info.failSympCode=sysmptoms.failSympCode
	where info.factoryCode = 1081 and info.crtTime >= sysdate
   	and info.sersdeGree is not null 
   	and info.coltStatCode in ('10810401001','10810401002','108102010101','108102010102','108102010103','108102010104','108102010105') 
   	group by info.compCode, 
   	info.positionCode,
   	info.failSympCode,
   	info.compName,
   	info.positionName, 
   	sysmptoms.failSympText 
order by count(info.qstnNum) desc;
    

