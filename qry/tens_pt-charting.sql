SELECT DISTINCT
	ENCNTR_ALIAS.ALIAS AS FIN,
	DCP_FORMS_ACTIVITY.ENCNTR_ID AS ENCOUNTER_ID,
	CLINICAL_EVENT.PARENT_EVENT_ID AS CE_PARENT_EVENT_ID,
	CE_PT.PARENT_EVENT_ID AS CE_PT_PARENT_EVENT_ID,
	pi_from_gmt(CE_PT.EVENT_END_DT_TM, (pi_time_zone(1, @Variable('BOUSER')))) AS EVENT_DATETIME,
	CLINICAL_EVENT.EVENT_TITLE_TEXT AS EVENT,
	CE_PT.EVENT_CD AS EVENT_CD,
	CV_PT_EVENT.DISPLAY AS EVENT_DETAIL,
	CE_PT.RESULT_VAL AS RESULT_VALUE
FROM 
	CLINICAL_EVENT,
	CLINICAL_EVENT CE_PT,
	CODE_VALUE CV_PT_EVENT,
	DCP_FORMS_ACTIVITY,
	DCP_FORMS_ACTIVITY_COMP,
	ENCNTR_ALIAS
WHERE 
    ENCNTR_ALIAS.ALIAS IN @prompt('Enter value(s) for Alias','A',,Multi,Free,Persistent,,User:0)
	AND ENCNTR_ALIAS.ACTIVE_IND = 1
	AND ENCNTR_ALIAS.END_EFFECTIVE_DT_TM > SYSDATE
	AND ENCNTR_ALIAS.ENCNTR_ALIAS_TYPE_CD = 619
    AND (
        ENCNTR_ALIAS.ENCNTR_ID = DCP_FORMS_ACTIVITY.ENCNTR_ID
    	AND DCP_FORMS_ACTIVITY.DCP_FORMS_REF_ID IN (598550116, 598551022)
    )
	AND (
		DCP_FORMS_ACTIVITY.DCP_FORMS_ACTIVITY_ID = DCP_FORMS_ACTIVITY_COMP.DCP_FORMS_ACTIVITY_ID
		AND DCP_FORMS_ACTIVITY_COMP.COMPONENT_CD = 690936
	)
	AND (
		DCP_FORMS_ACTIVITY_COMP.PARENT_ENTITY_ID = CLINICAL_EVENT.PARENT_EVENT_ID
		AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31' 
	) 
	AND (
		CLINICAL_EVENT.EVENT_ID = CE_PT.PARENT_EVENT_ID
		AND CE_PT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
		AND CE_PT.EVENT_CD = CV_PT_EVENT.CODE_VALUE
	)
