---------------------------Step 1: Create Table
--创建表结构 FTT_QUALITYINFO
--create table ftt_qualityinfo as select * from ftt_qualityinfo@CXMES where 1<>1;
--创建表结构 FTT_QUALITYLINE
--create table FTT_QUALITYLINE as select * from FTT_QUALITYLINE@CXMES where 1<>1;
--创建表结构 ftt_prdbasedata
--create table ftt_prdbasedata as select * from ftt_prdbasedata@CXMES where 1<>1;

---------------------------Step 2: Sychnoized Data ODS Level
--PRO_FTT_QUALITYINFO
Create or replace PROCEDURE PRO_FTT_QUALITYINFO
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  VAR2ERRCODE VARCHAR2(256);
  VAR2ERRMSG  VARCHAR2(256);
BEGIN
/*
 * *********************************************
 * Name: PRO_FTT_QUALITYINFO Sychnoized
 * Description: Full Flash Ftt_QualityInfo data
 * Parameter:
			 RunDate
			 OUTERRCODE
			 OUTERRMSG
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-31  kexue  create this function
 ******************************************************************************************
 *
 **/
delete FTT_QUALITYINFO;
insert into FTT_QUALITYINFO select * from FTT_QUALITYINFO@CXMES;
COMMIT;
--Throw Exception
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OUTERRCODE := VAR2ERRCODE;
    OUTERRMSG  := SUBSTR(VAR2ERRMSG, 1, 255);
END;
--PRO_FTT_QUALITYLINE
Create or replace PROCEDURE PRO_FTT_QUALITYLINE
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  VAR2ERRCODE VARCHAR2(256);
  VAR2ERRMSG  VARCHAR2(256);
BEGIN
/*
 * *********************************************
 * Name: PRO_FTT_QUALITYLINE Sychnoized
 * Description: Full Flash FTT_QUALITYLINE data
 * Parameter:
			 RunDate
			 OUTERRCODE
			 OUTERRMSG
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-31  kexue  create this Procedure
 ******************************************************************************************
 *
 **/
delete FTT_QUALITYLINE;
insert into FTT_QUALITYLINE select * from FTT_QUALITYLINE@CXMES;
COMMIT;
--Throw Exception
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OUTERRCODE := VAR2ERRCODE;
    OUTERRMSG  := SUBSTR(VAR2ERRMSG, 1, 255);
END;
--PRO_ftt_prdbasedata
Create or replace PROCEDURE PRO_ftt_prdbasedata
(RunDate IN date,OUTERRCODE OUT VARCHAR2,OUTERRMSG OUT VARCHAR2) IS
  VAR2ERRCODE VARCHAR2(256);
  VAR2ERRMSG  VARCHAR2(256);
BEGIN
/*
 * *********************************************
 * Name: Pro_ftt_prdbasedata Sychnoized
 * Description: Full Flash ftt_prdbasedata data
 * Parameter:
			 RunDate
			 OUTERRCODE
			 OUTERRMSG
 ******************************************************************************************
 * Verions   date  eidtor  description
 1.0.0    2014-10-31  kexue  create this Procedure
 ******************************************************************************************
 *
 **/
delete ftt_prdbasedata;
insert into ftt_prdbasedata select * from ftt_prdbasedata@CXMES;
COMMIT;
--Throw Exception
  EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK;
    OUTERRCODE := VAR2ERRCODE;
    OUTERRMSG  := SUBSTR(VAR2ERRMSG, 1, 255);
END;

---------------------------Step 3: Test Procedure execution 
--PRO_FTT_QUALITYINFO
declare
	aa varchar2(256);
	bb varchar2(256);
begin
	Pro_ftt_QUALITYINFO(sysdate,aa,bb);
end;
select * from FTT_QUALITYINFO;
--PRO_FTT_QUALITYLINE
declare
	aa varchar2(256);
	bb varchar2(256);
begin
	Pro_ftt_QUALITYLINE(sysdate,aa,bb);
end;
select * from FTT_QUALITYLINE;
--PRO_ftt_prdbasedata
declare
	aa varchar2(256);
	bb varchar2(256);
begin
	Pro_ftt_prdbasedata(sysdate,aa,bb);
end;
select * from ftt_prdbasedata;

---------------------------Step 4: Build in ODS Level
--NO19. PRO_FTT_QUALITYINFO 。Kexue
  SPNAME := 'PRO_FTT_QUALITYINFO';
  SP_EXECUTE_PROC(SPNAME, V_DATE, var2ErrCode, var2ErrMsg);
  IF var2ErrCode IS NOT NULL THEN
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);  
    RETURN;
  END IF;    
--NO20. PRO_FTT_QUALITYLINE 。Kexue
  SPNAME := 'PRO_FTT_QUALITYLINE';
  SP_EXECUTE_PROC(SPNAME, V_DATE, var2ErrCode, var2ErrMsg);
  IF var2ErrCode IS NOT NULL THEN
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);  
    RETURN;
  END IF;    
--NO21. PRO_FTT_PRDBASEDATA 。Kexue
  SPNAME := 'PRO_FTT_PRDBASEDATA';
  SP_EXECUTE_PROC(SPNAME, V_DATE, var2ErrCode, var2ErrMsg);
  IF var2ErrCode IS NOT NULL THEN
    OutErrCode := var2ErrCode;
    OutErrMsg  := SUBSTR(var2ErrMsg, 1, 255);  
    RETURN;
  END IF;   
