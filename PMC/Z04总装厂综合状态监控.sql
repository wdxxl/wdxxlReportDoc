----Z04
--计划生产  (ZZ0101)
select plcode as plcode, sum(PROSCHEDULNUM) as sumPROSCHEDULNUM from PP_MANUDETAIL 
where  fccode = 1081 and decode(NVL(PROSCHEDULDATE,'0'),'0',PSDATE, PROSCHEDULDATE) = to_char(sysdate,'yyyy-MM-dd') 
group by plcode;
--生产实际/上线/下线/
select stcode as stcode, sum(MOQTY)as summoqty from pp_vehconf 
where STCODE != 'ENDS' and fccode = 1081 and  substr(crtime, 0, 10) = to_char(sysdate,'yyyy-MM-dd') group by stcode;
--在制品
select stcode as stcode, sum(moqty)as summoqty from pp_vehinfo 
where STCODE != 'ENDS' and fccode = 1081 group by stcode order by stcode;
------------------------------------------------------------------
---方法1 ('PMC_ZZ_PBS_CUNCHU','PMC_ZZ_PBS_ZHISONG','PMC_ZZ_JIANC_JIANCE','PMC_ZZ_FANX_OKX','PMC_ZZ_JIANC_LUSHI','PMC_ZZ_JIANC_LINYU','PMC_ZZ_JIANC_SHANGJ','PMC_ZZ_FANX_SHANGJ','PMC_ZZ_FEIZ_FADONGJI')
------Key:  PMC_ZZ_PBS_CUNCHU@1
------Value: 10@FA5032@淋雨线-PB01控制箱急停-急停@淋雨线-PB01控制箱急停-急停
----- 质量和缺料 相关的数据查询 
SELECT
    to_char(sysdate,'yyyy-MM-dd HH24:mm:ss') SYSDATESTR,
    to_char(pmcar.createdatetime,'yyyy-MM-dd HH24:mm:ss') CREATEDATETIME,
    pmca.areacode || '@' || pmct.andoncategory as AREACODEINFO, 
    pmct.devicecode,--这里可以吧device text 取出来用语区分显示
    pmct.TAGTEXT || '-' || pmcsc.statusText AS TAGSTATUSTEXT ,
    pmcar.STATUSSERVERITY,
    pmcar.STATUSCOLORCODE 
FROM PMC_ANDONRECORD pmcar 
 INNER JOIN pmc_tag pmct  ON pmcar.TAGNAME = pmct.TAGNAME
    INNER JOIN pmc_statuscode pmcsc ON pmct.STATUSTYPECODE = pmcsc.STATUSTYPECODE AND pmcar.STATUSCODE = pmcsc.STATUSCODE
    inner join pmc_areadevice pmcad on pmct.devicecode = pmcad.DEVICECODE 
 inner join pmc_area pmca on pmcad.areacode = pmca.areacode 
  and pmca.areacode in ('PMC_ZZ_PBS_CUNCHU','PMC_ZZ_PBS_ZHISONG','PMC_ZZ_JIANC_JIANCE','PMC_ZZ_FANX_OKX','PMC_ZZ_JIANC_LUSHI','PMC_ZZ_JIANC_LINYU','PMC_ZZ_JIANC_SHANGJ','PMC_ZZ_FANX_SHANGJ','PMC_ZZ_FEIZ_FADONGJI')
order by 
     AREACODEINFO ASC,
    pmcar.STATUSSERVERITY ASC, 
    pmcar.CREATEDATETIME ASC
---------------------------------------------
----方法2 ('PMC_ZZ_NEIS','PMC_ZZ_DIP','PMC_ZZ_ZHONGZ','PMC_ZZ_OK')
------Key:  PMC_ZZ_DIP@1
------Value: 10@FA5032@淋雨线-PB01控制箱急停-急停@淋雨线-PB01控制箱急停-急停
----- 质量和缺料 相关的数据查询 
SELECT
    to_char(sysdate,'yyyy-MM-dd HH24:mm:ss') SYSDATESTR,
    to_char(pmcar.createdatetime,'yyyy-MM-dd HH24:mm:ss') CREATEDATETIME,
    pmca.parentareacode || '@' || pmct.andoncategory as PARENTAREACODEINFO, 
    pmct.devicecode,--这里可以吧device text 取出来用语区分显示
    pmct.TAGTEXT || '-' || pmcsc.statusText AS TAGSTATUSTEXT ,
    pmcar.STATUSSERVERITY,
    pmcar.STATUSCOLORCODE 
FROM PMC_ANDONRECORD pmcar 
 INNER JOIN pmc_tag pmct  ON pmcar.TAGNAME = pmct.TAGNAME
    INNER JOIN pmc_statuscode pmcsc ON pmct.STATUSTYPECODE = pmcsc.STATUSTYPECODE AND pmcar.STATUSCODE = pmcsc.STATUSCODE
    inner join pmc_areadevice pmcad on pmct.devicecode = pmcad.DEVICECODE 
 inner join pmc_area pmca on pmcad.areacode = pmca.areacode 
  and pmca.parentareacode in ('PMC_ZZ_NEIS','PMC_ZZ_DIP','PMC_ZZ_ZHONGZ','PMC_ZZ_OK') 
order by 
     PARENTAREACODEINFO ASC,
    pmcar.STATUSSERVERITY ASC, 
    pmcar.CREATEDATETIME ASC
--------------------------------------------------------
---方法3 （PMC_ZZ_PBS_CUNCHU，PMC_ZZ_PBS_ZHISONG，PMC_ZZ_JIANC_JIANCE,PMC_ZZ_FANX_OKX,PMC_ZZ_JIANC_LUSHI,PMC_ZZ_JIANC_LINYU,PMC_ZZ_JIANC_SHANGJ,PMC_ZZ_FANX_SHANGJ,PMC_ZZ_FEIZ_FADONGJI)
  /*
   * 设备
   * Level4 Search by Device
   * Key: PMC_ZZ_JIANCE_LINYU@1
   * Value：10@FA5032@淋雨线-PB01控制箱急停-急停@淋雨线-PB01控制箱急停-急停
   */
SELECT
    to_char(sysdate,'yyyy-MM-dd HH24:mm:ss') SYSDATESTR,
    to_char(pmcst.createdatetime,'yyyy-MM-dd HH24:mm:ss') CREATEDATETIME,
    pmca.areacode AREACODEINFO, 
    pmct.devicecode,--这里可以吧device text 取出来用语区分显示
    pmct.TAGTEXT || '-' || pmcsc.statusText AS TAGSTATUSTEXT ,
    pmcst.STATUSSERVERITY,
    pmcst.STATUSCOLORCODE 
FROM pmc_statusrecord pmcst 
 INNER JOIN pmc_tag pmct  ON pmcst.TAGNAME = pmct.TAGNAME
    INNER JOIN pmc_statuscode pmcsc ON pmct.STATUSTYPECODE = pmcsc.STATUSTYPECODE  AND pmcst.STATUSCODE = pmcsc.STATUSCODE
    inner join pmc_areadevice pmcad on pmcst.devicecode = pmcad.DEVICECODE 
 inner join pmc_area pmca on pmcad.areacode = pmca.areacode 
  and pmca.areacode in ('PMC_ZZ_PBS_CUNCHU','PMC_ZZ_PBS_ZHISONG','PMC_ZZ_JIANC_JIANCE','PMC_ZZ_FANX_OKX','PMC_ZZ_JIANC_LUSHI','PMC_ZZ_JIANC_LINYU','PMC_ZZ_JIANC__SHANGJ','PMC_ZZ_FANX_SHANGJ','PMC_ZZ_FEIZ_FADONGJI')
order by 
     AREACODEINFO ASC,
    pmcst.STATUSSERVERITY ASC, 
    pmcst.CREATEDATETIME ASC
----------------------------------------
----方法4 （PMC_ZZ_NEIS，PMC_ZZ_DIP，PMC_ZZ_ZHONGZ，PMC_ZZ_OK）
  /*
   * 设备
   * Level4 Search by parentAreaCode
   * Key: PMC_ZZ_JIANCE_LINYU@1
   * Value：10@FA5032@淋雨线-PB01控制箱急停-急停@淋雨线-PB01控制箱急停-急停
   */
SELECT
    to_char(sysdate,'yyyy-MM-dd HH24:mm:ss') SYSDATESTR,
    to_char(pmcst.createdatetime,'yyyy-MM-dd HH24:mm:ss') CREATEDATETIME,
    pmca.parentareacode PARENTAREACODEINFO,
    pmct.deviceCODE, --这里可以吧device text 取出来用语区分显示
    pmct.TAGTEXT || '-' || pmcsc.statusText AS TAGSTATUSTEXT ,
    pmcst.STATUSSERVERITY,
    pmcst.STATUSCOLORCODE
FROM pmc_statusrecord pmcst 
 INNER JOIN pmc_tag pmct  ON pmcst.TAGNAME = pmct.TAGNAME
    INNER JOIN pmc_statuscode pmcsc ON pmct.STATUSTYPECODE = pmcsc.STATUSTYPECODE  AND pmcst.STATUSCODE = pmcsc.STATUSCODE
    inner join pmc_areadevice pmcad on pmcst.devicecode = pmcad.DEVICECODE 
 inner join pmc_area pmca on pmcad.areacode = pmca.areacode 
 and pmca.parentareacode in ('PMC_ZZ_NEIS','PMC_ZZ_DIP','PMC_ZZ_ZHONGZ','PMC_ZZ_OK') 
order by 
     PARENTAREACODEINFO ASC,
    pmcst.STATUSSERVERITY ASC,
    pmcst.createdatetime ASC
