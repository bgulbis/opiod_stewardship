SELECT DISTINCT
	ENCNTR_ALIAS.ENCNTR_ID AS ENCOUNTER_ID,
	CLINICAL_EVENT.EVENT_ID AS EVENT_ID,
	CLINICAL_EVENT.ORDER_ID AS ORDER_ID,
	TO_CHAR(pi_from_gmt(CLINICAL_EVENT.EVENT_END_DT_TM, (pi_time_zone(1, @Variable('BOUSER')))), 'YYYY-MM-DD"T"HH24:MI:SS') AS EVENT_DATETIME,
	CV_EVENT.DISPLAY AS EVENT,
	CLINICAL_EVENT.RESULT_VAL AS RESULT
FROM
    CLINICAL_EVENT,
    CODE_VALUE CV_EVENT,
	ENCNTR_ALIAS
WHERE
    ENCNTR_ALIAS.ALIAS IN @prompt('Enter value(s) for Alias','A',,Multi,Free,Persistent,,User:0)
	AND ENCNTR_ALIAS.ENCNTR_ALIAS_TYPE_CD = 619
    AND (
        ENCNTR_ALIAS.ENCNTR_ID = CLINICAL_EVENT.ENCNTR_ID
    	AND CLINICAL_EVENT.EVENT_CD = 326948035
	    AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31' 
        AND CLINICAL_EVENT.EVENT_CD = CV_EVENT.CODE_VALUE
    )
