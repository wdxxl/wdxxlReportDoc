SELECT 
    mds.stcode,
    ppv.prdseq,
    ppv.monum,
    ppm.excountry,
    bam.bodytype,
    bam.bodytype||weibiao,
    mdc.cotext,
    bam.mttext2,
    bam.mttext,
    mds.TEMPFLG
FROM
    md_station mds LEFT OUTER JOIN PP_VEHINFO ppv ON mds.stcode = ppv.stcode and mds.plcode = ppv.PLCODE
    left outer JOIN pp_manuorder ppm ON ppm.PLCODE = mds.PLCODE and ppv.monum = ppm.MONUM 
    left outer join ba_material bam on ppm.mtcode = bam.mtcode 
    left outer join md_colour mdc on mdc.cocode = substr(bam.MTCODE,-3)
WHERE
    mds.fccode = 1081
    AND mds.plcode = 'ZZ0101' 
    and mds.seqid >= '0020'
ORDER BY
    mds.seqid,
    ppv.CHTIME