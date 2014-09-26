---- T00扫描验证
------------PBS故障点
select 
	to_char(sysdate,'yyyy-MM-dd HH24:mm:ss') as SYSDATESTR,
	to_char(pmctvc.createdatetime,'yyyy-MM-dd HH24:mm:ss') as CREATEDATETIME,
	pmct.TAGTEXT||'-'|| pmcsc.statusText as tagtext,
	pmcss.STATUSCOLORCODE 
from PMC_TagValueCurrent pmctvc 
	inner join pmc_tag pmct on pmctvc.TAGNAME = pmct.TAGNAME 
	inner join pmc_statuscode pmcsc on pmct.STATUSTYPECODE = pmcsc.STATUSTYPECODE 
		and pmctvc.TAGVALUE = pmcsc.STATUSCODE 
	inner join pmc_statusserverity pmcss on pmcsc.statusserverity = pmcss.statusserverity 
where pmctvc.sitecode= 1081 
	and pmctvc.TAGNAME = 'PBS故障点-RAED_tagFAIL_FR8'
------------ 参考队列 (T001....T001/T01/T02/T03/T04/T05/T06/T07) 50个
select * from 
	(select t.*, rownum rn from 
		( SELECT mds.stcode, 
				ppv.prdseq as VIN,
				bam.bodytype||weibiao as BODYTYPEWEIBIAO,
				mdc.cotext 
			FROM  md_station mds 
				LEFT OUTER JOIN PP_VEHINFO ppv ON mds.stcode = ppv.stcode and mds.plcode = ppv.PLCODE 
				left outer JOIN pp_manuorder ppm ON ppm.PLCODE = mds.PLCODE and ppv.monum = ppm.MONUM
				left outer join ba_material bam on ppm.mtcode = bam.mtcode 
				left outer join md_colour mdc on mdc.cocode = substr(bam.MTCODE,-3) 
			WHERE mds.fccode = 1081 AND mds.plcode = 'ZZ0101' and mds.seqid <= '0080'
				ORDER BY mds.seqid desc, ppv.CHTIME desc ) t where rownum <= 50 order by rn desc) where rn >= 1 
------------ 获取当前 （T001/T001/T01/T02/T03/T04/T05/T06/T07） 9个
select * from 
	(select t.*,rownum rn from 
		( SELECT mds.stcode, 
				ppv.prdseq as VIN,
				bam.bodytype||weibiao as BODYTYPEWEIBIAO,
				mdc.cotext 
			FROM  md_station mds 
				LEFT OUTER JOIN PP_VEHINFO ppv ON mds.stcode = ppv.stcode and mds.plcode = ppv.PLCODE 
				left outer JOIN pp_manuorder ppm ON ppm.PLCODE = mds.PLCODE and ppv.monum = ppm.MONUM 
				left outer join ba_material bam on ppm.mtcode = bam.mtcode 
				left outer join md_colour mdc on mdc.cocode = substr(bam.MTCODE,-3) 
			WHERE mds.fccode = 1081  AND mds.plcode = 'ZZ0101'  and mds.seqid <= '0080'
			ORDER BY mds.seqid desc, ppv.CHTIME desc ) 
			t where rownum <= 9 order by rn desc) where rn >= 1
