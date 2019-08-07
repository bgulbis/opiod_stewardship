SELECT DISTINCT
	ENCNTR_ALIAS.ALIAS AS FIN,
	DCP_FORMS_ACTIVITY.ENCNTR_ID AS ENCOUNTER_ID,
	TO_CHAR(pi_from_gmt(CE_PT1.EVENT_END_DT_TM, (pi_time_zone(1, @Variable('BOUSER')))), 'YYYY-MM-DD"T"HH24:MI:SS') AS EVENT_DATETIME,
	CE_PT1.EVENT_TITLE_TEXT AS EVENT_TEXT1,
	CV_PT_EVENT1.DISPLAY AS EVENT_DETAIL1,
	CE_PT1.RESULT_VAL AS RESULT_VALUE1,
	CE_PT2.EVENT_TITLE_TEXT AS EVENT_TEXT2,
	CV_PT_EVENT2.DISPLAY AS EVENT_DETAIL2,
	CE_PT2.RESULT_VAL AS RESULT_VALUE2,
	CE_PT3.EVENT_TITLE_TEXT AS EVENT_TEXT3,
	CV_PT_EVENT3.DISPLAY AS EVENT_DETAIL3,
	CE_PT3.RESULT_VAL AS RESULT_VALUE3,
	CE_PT4.EVENT_TITLE_TEXT AS EVENT_TEXT4,
	CV_PT_EVENT4.DISPLAY AS EVENT_DETAIL4,
	CE_PT4.RESULT_VAL AS RESULT_VALUE4,
	DCP_FORMS_ACTIVITY_COMP.PARENT_ENTITY_ID AS PARENT_EVENT_ID,
	CE_PT1.PARENT_EVENT_ID AS PARENT_EVENT_ID1,
	CE_PT1.EVENT_ID AS EVENT_ID1,
	CE_PT2.PARENT_EVENT_ID AS PARENT_EVENT_ID2,
	CE_PT2.EVENT_ID AS EVENT_ID2,
	CE_PT3.PARENT_EVENT_ID AS PARENT_EVENT_ID3,
	CE_PT3.EVENT_ID AS EVENT_ID3,
	CE_PT4.PARENT_EVENT_ID AS PARENT_EVENT_ID4,
	CE_PT4.EVENT_ID AS EVENT_ID4,
	CE_PT1.EVENT_CD AS EVENT_CD1,
	CE_PT2.EVENT_CD AS EVENT_CD2,
	CE_PT3.EVENT_CD AS EVENT_CD3,
	CE_PT4.EVENT_CD AS EVENT_CD4
FROM 
	CODE_VALUE CV_PT_EVENT1,
	CODE_VALUE CV_PT_EVENT2,
	CODE_VALUE CV_PT_EVENT3,
	CODE_VALUE CV_PT_EVENT4,
	DCP_FORMS_ACTIVITY,
	DCP_FORMS_ACTIVITY_COMP,
	ENCNTR_ALIAS,
	(
	    SELECT * 
	    FROM CLINICAL_EVENT 
	    WHERE 
	        CLINICAL_EVENT.PARENT_EVENT_ID <> CLINICAL_EVENT.EVENT_ID
	        AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
	) CE_PT1,
	(
	    SELECT * 
	    FROM CLINICAL_EVENT 
	    WHERE 
	        CLINICAL_EVENT.PARENT_EVENT_ID <> CLINICAL_EVENT.EVENT_ID
	        AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
	) CE_PT2,
	(
	    SELECT * 
	    FROM CLINICAL_EVENT 
	    WHERE 
	        CLINICAL_EVENT.PARENT_EVENT_ID <> CLINICAL_EVENT.EVENT_ID
	        AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
	) CE_PT3,
	(
	    SELECT * 
	    FROM CLINICAL_EVENT 
	    WHERE 
	        CLINICAL_EVENT.PARENT_EVENT_ID <> CLINICAL_EVENT.EVENT_ID
	        AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
	) CE_PT4
WHERE 
    ENCNTR_ALIAS.ALIAS IN @prompt('Enter value(s) for Alias','A',,Multi,Free,Persistent,,User:0)
	AND ENCNTR_ALIAS.ACTIVE_IND = 1
	AND ENCNTR_ALIAS.END_EFFECTIVE_DT_TM > SYSDATE
	AND ENCNTR_ALIAS.ENCNTR_ALIAS_TYPE_CD = 619
    AND (
        ENCNTR_ALIAS.ENCNTR_ID = DCP_FORMS_ACTIVITY.ENCNTR_ID
    	AND DCP_FORMS_ACTIVITY.DCP_FORMS_REF_ID IN (598550634, 598550116, 598551022)
    )
	AND (
		DCP_FORMS_ACTIVITY.DCP_FORMS_ACTIVITY_ID = DCP_FORMS_ACTIVITY_COMP.DCP_FORMS_ACTIVITY_ID
		AND DCP_FORMS_ACTIVITY_COMP.COMPONENT_CD = 690936
	)
	AND (
		DCP_FORMS_ACTIVITY_COMP.PARENT_ENTITY_ID = CE_PT1.PARENT_EVENT_ID
		AND CE_PT1.VALID_UNTIL_DT_TM > DATE '2099-12-31' 
		AND CE_PT1.EVENT_CD = CV_PT_EVENT1.CODE_VALUE
	) 
	AND (
	    CE_PT1.EVENT_ID = CE_PT2.PARENT_EVENT_ID(+)
		AND CE_PT2.VALID_UNTIL_DT_TM(+) > DATE '2099-12-31'
		AND CE_PT2.EVENT_CD = CV_PT_EVENT2.CODE_VALUE(+)
	)
	AND (
	    CE_PT2.EVENT_ID = CE_PT3.PARENT_EVENT_ID(+)
		AND CE_PT3.VALID_UNTIL_DT_TM(+) > DATE '2099-12-31'
		AND CE_PT3.EVENT_CD = CV_PT_EVENT3.CODE_VALUE(+)
	)
	AND (
	    CE_PT3.EVENT_ID = CE_PT4.PARENT_EVENT_ID(+)
		AND CE_PT4.VALID_UNTIL_DT_TM(+) > DATE '2099-12-31'
		AND CE_PT4.EVENT_CD = CV_PT_EVENT4.CODE_VALUE(+)
	)