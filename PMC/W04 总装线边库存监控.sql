--------W04 总 装 线 边 库 存 监 控
-----求总
select count(*) as TOTAL 
from MM_LineStore mml inner join BA_MATERIAL bam on bam.MTCODE = mml.MTCODE 
where mml.FCCODE= 1081 and mml.PLCODE = 'ZZ0101' 
order by mml.STOREAREA asc
-----数据分页获取
select * from (
	select t.*, rownum rn 
		from (
			select mml.FCCODE,
					mml.PLCODE, 
					mml.MTCODE, 
					bam.MTTEXT, 
					mml.VIRTUALSTOCK, 
					mml.LOCKSTOCK,
					mml.STOREAREA,
					mml.SECSTOCK,
					mml.MAXSTOCK 
			from MM_LineStore mml 
					inner join BA_MATERIAL bam on bam.MTCODE = mml.MTCODE
			where mml.FCCODE= 1081 and mml.PLCODE = 'ZZ0101' order by mml.STOREAREA asc)
			t where rownum <= 20) where rn >= 1
