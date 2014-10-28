PROCEDURE pro_rpt_assemblyproduction
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  var2ErrCode varchar2(256);
  var2ErrMsg  varchar2(256);

  cursor c_assembly_data is
    select distinct
     vc.fccode as sitecode,
     mt.mttext3 as CARFAMILYTEXT,
     mt.mttext4 as CARTYPETEXT,
     format_crtime(vc.crtime) as productiondate,
     cl.cocode as CARCOLORCODE,
     cl.cotext as CARCOLORTEXT,
     mt.mtcode,
     decode(mt.expflg,0,0,1) as EXPFLG
  from pp_vehconf vc
     inner join pp_manuorder mo on vc.monum = mo.monum and mo.plcode = 'ZZ0101'
     inner join ba_material mt on mt.mtcode = mo.mtcode
     inner join md_colour cl on substr(mt.mtcode, -3, 3) = cl.cocode
  where vc.stcode in ('T00','T01','C01','F01','F23') and mt.mttext4 is not null
     order by mt.mttext3;

   i_fccode varchar2(256);
   i_plcode varchar2(256);
   i_mttext3 varchar2(256);
   i_mttext4 varchar2(256);
   i_mtcode varchar2(256);
   i_crtime date;
/*
 * *********************************************
 * Name: pro_rpt_assemblyproduction(RunDate,OUTERRCODE,OUTERRMSG)
 * Description: build assembly production data
 * Parameter:
       RunDate
       OUTERRCODE
       OUTERRMSG
       
 ******************************************************************************************     
 * Verions   date  eidtor  description
 1.0.0    2014-10-27  kexue create this prodecure
 1.0.1	  2014-10-28  kexue update parameter use 'mtcode' instead of 'mttext3' and 'mttext4';
 1.0.2    2014-10-28  kexue add expflg 'expflg = 0 for domastic else for export'
 ******************************************************************************************
 *
 * Test SQL:
 * declare
	aa varchar2(255);
	bb varchar2(255);
   begin
  	pro_rpt_assemblyproduction(sysdate,aa,bb);
   end;
 */

begin
   delete from RPT_ASSEMBLYPRODUCTION;

   for r_assembly_data in c_assembly_data loop
     i_fccode := r_assembly_data.sitecode;
     i_plcode := 'ZZ0101';
     i_mttext3 := r_assembly_data.CARFAMILYTEXT;
     i_mttext4 := r_assembly_data.CARTYPETEXT;
     i_mtcode := r_assembly_data.mtcode;
     i_crtime := r_assembly_data.productiondate;

     INSERT INTO RPT_ASSEMBLYPRODUCTION(
             SITECODE,
             PRODUCTIONDATE,
             CARFAMILYCODE,
             CARFAMILYTEXT,
             ENGINEDISPLACEMENTCODE,             --5
             ENGINEDISPLACEMENTTEXT,
             TRANSMISSIONTYPECODE,
             TRANSMISSIONTYPETEXT,
             CARTYPECODE,
             CARTYPETEXT,                        --10
             CARCOLORCODE,
             CARCOLORTEXT,
             PBSIN,
             PLAN_,
             ONLINE_,                            --15
             OFFLINE_,
             WIP,
             COMMERCIAL,
             NONCOMMERCIAL,
             BALANCE,                            --20
             PBSINTHISYEAR,
             ONLINETHISYEAR,
             OFFLINETHISYEAR,
             COMMERCIALTHISYEAR,
             NONCOMMERCIALTHISYEAR,              --25
             PBSINTHISMONTH,
             PLANTHISMONTH,
             ONLINETHISMONTH,
             OFFLINETHISMONTH,
             COMMERCIALTHISMONTH,                --30
             NONCOMMERCIALTHISMONTH,
             DOMESTICFLAG)
      VALUES(
             r_assembly_data.sitecode,                                                    --SITECODE
             r_assembly_data.productiondate,                                              --PRODUCTIONDATE
             r_assembly_data.CARFAMILYTEXT,							--CARFAMILYCODE   use text TODO
             r_assembly_data.CARFAMILYTEXT,                                               --CARFAMILYTEXT
             'T'||i_mtcode,                      --5
             'T'||i_mtcode,
             'T'||i_mtcode,
             'T'||i_mtcode,
             r_assembly_data.CARTYPETEXT,							--CARTYPECODE use text TODO
             r_assembly_data.CARTYPETEXT,         --10                                    --CARTYPETEXT
             r_assembly_data.CARCOLORCODE,                                                --CARCOLORCODE
             r_assembly_data.CARCOLORTEXT,                                                --CARCOLORTEXT
             0,
             assembly_plan_addup_daily(i_fccode,i_plcode,i_mtcode,i_crtime),              --PLAN_
             assembly_onoffline_daily(i_plcode,'T00',i_mtcode,i_crtime), --15  			  --ONLINE_
             assembly_onoffline_daily(i_plcode,'F23',i_mtcode,i_crtime),       			  --OFFLINE_
             assembly_wip_daily(i_plcode,'T00','F23',i_mtcode,i_crtime),      			  --WIP
             0,
             0,
             assembly_wip_daily(i_plcode,'F23','RK01',i_mtcode,i_crtime), --20 		      --BALANCE
             assembly_onoffline_yearly(i_plcode,'PBS',i_mtcode,i_crtime),                 --PBSINTHISYEAR
             assembly_onoffline_yearly(i_plcode,'T00',i_mtcode,i_crtime),                 --ONLINETHISYEAR
             assembly_onoffline_yearly(i_plcode,'F23',i_mtcode,i_crtime),                 --OFFLINETHISYEAR
             0,
             0,                                   --25
             assembly_onoffline_monthly(i_plcode,'PBS',i_mtcode,i_crtime),                --PBSINTHISMONTH
             assembly_plan_addup_monthly(i_fccode,i_plcode,i_mtcode,i_crtime),            --PLANTHISMONTH
             assembly_onoffline_monthly(i_plcode,'T00',i_mtcode,i_crtime) ,               --ONLINETHISMONTH
             assembly_onoffline_monthly(i_plcode,'F23',i_mtcode,i_crtime) ,               --OFFLINETHISMONTH
             0,                                   --30
             0,
             r_assembly_data.EXPFLG);
   End loop;

   commit;
EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);
END;
