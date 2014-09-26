----- C04 当前班次/当前计划/SPM/班次计划/当批实际/SPH/班次实际/废品数量/APC/当批零件/下批零件
select TAGNAME, TAGVALUE 
from PMC_TAGVALUECURRENT 
where SITECODE= 1081
	and TAGNAME LIKE 'CHN_PR_ACON.CON_PLC.%' 
	and MODIFYDATETIME >= sysdate;
	
----- C04 持续产时/日运行时间/日停机时间/可动率
select VALUEDATETIME, TAGVALUE 
from PMC_TAGVALUE 
where SITECODE= 1081
	and TAGNAME = 'CHN_PR_ACON.CON_PLC.Press5_ADC_Running'
	and VALUEDATETIME >= sysdate
	and TAGVALUE is not null order by VALUEDATETIME DESC

---- C04 日停机次数 ？显示有点问题
SELECT count(ID) 
FROM PMC_TAGVALUE 
WHERE SITECODE= 1081 
	AND TAGVALUE = 1 
	AND TAGNAME LIKE 'CHN_PR_ACON.CON_PLC.%' 
	AND VALUEDATETIME >= sysdate
	AND (TAGNAME LIKE '%Fault' or TAGNAME LIKE '%EStopOK')

----C04 冲压A线综合状态监控  冲压机监控数据
select 
	curval_.TAGNAME, 
	curval_.TAGVALUE, 
	code_.STATUSTEXT, 
	serverrity_.STATUSSERVERITY,
	curval_.MODIFYDATETIME
FROM PMC_TAGVALUECURRENT curval_ 
	INNER JOIN PMC_TAG tag_ ON curval_.TAGNAME = tag_.TAGNAME 
	INNER JOIN PMC_STATUSCODE code_ ON tag_.STATUSTYPECODE = code_.STATUSTYPECODE AND code_.STATUSCODE = curval_.TAGVALUE 
	INNER JOIN PMC_STATUSSERVERITY serverrity_ ON code_.STATUSSERVERITY = serverrity_.StatusServerity 
WHERE curval_.TAGNAME LIKE 'CHN_PR_ACON.CON_PLC.%' 
	AND serverrity_.STATUSSERVERITY <= 'C'
	AND curval_.MODIFYDATETIME>= sysdate
	AND (curval_.TAGNAME LIKE '%Robot%' 
		OR curval_.TAGNAME LIKE '%SafetyGateOk'  
		OR curval_.TAGNAME LIKE '%Press%' 
		OR curval_.TAGNAME LIKE '%Part_Prsnc') 
ORDER BY 
	curval_.MODIFYDATETIME DESC, 
	serverrity_.STATUSSERVERITY DESC
	
-- C04 机器人，废料线都还尚未确定
