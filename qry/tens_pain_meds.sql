SELECT DISTINCT
	ENCNTR_ALIAS.ENCNTR_ID AS ENCOUNTER_ID,
	CLINICAL_EVENT.EVENT_ID AS EVENT_ID,
	TO_CHAR(pi_from_gmt(CLINICAL_EVENT.EVENT_END_DT_TM, (pi_time_zone(1, @Variable('BOUSER')))), 'YYYY-MM-DD"T"HH24:MI:SS') AS EVENT_DATETIME,
	CV_EVENT.DISPLAY AS MEDICATION,
	ORDERS.ORDER_MNEMONIC AS MED_PRODUCT,
	CE_MED_RESULT.ADMIN_DOSAGE AS DOSE,
	CV_DOSAGE_UNIT.DISPLAY AS DOSE_UNIT,
	CE_MED_RESULT.INFUSION_RATE AS RATE,
	CV_INFUSION_UNIT.DISPLAY AS RATE_UNIT,
	CV_IV_EVENT.DISPLAY AS IV_EVENT,
	CV_ADMIN_ROUTE.DISPLAY AS ROUTE,
	CLINICAL_EVENT.ORDER_ID AS ORDER_ID,
	ORDERS.TEMPLATE_ORDER_ID AS TEMPLATE_ORDER_ID,
	CASE ORDERS.TEMPLATE_ORDER_ID
		WHEN 0 THEN CLINICAL_EVENT.ORDER_ID
		ELSE ORDERS.TEMPLATE_ORDER_ID
	END AS ORIG_ORDER_ID
FROM
	CE_MED_RESULT,
    CLINICAL_EVENT,
	CODE_VALUE CV_ADMIN_ROUTE,
	CODE_VALUE CV_DOSAGE_UNIT,
    CODE_VALUE CV_EVENT,
    CODE_VALUE CV_INFUSION_UNIT,
    CODE_VALUE CV_IV_EVENT,
	ENCNTR_ALIAS,
	ORDERS,
	PI_THERA_CLASS_VIEW
WHERE
    ENCNTR_ALIAS.ALIAS IN @prompt('Enter value(s) for Alias','A',,Multi,Free,Persistent,,User:0)
	AND ENCNTR_ALIAS.ENCNTR_ALIAS_TYPE_CD = 619
	AND (
	    ENCNTR_ALIAS.ENCNTR_ID = CLINICAL_EVENT.ENCNTR_ID
		AND CLINICAL_EVENT.VALID_UNTIL_DT_TM > DATE '2099-12-31'
		AND CLINICAL_EVENT.EVENT_CD = CV_EVENT.CODE_VALUE
	)
    AND (
        CLINICAL_EVENT.ORDER_ID = ORDERS.ORDER_ID
		AND ORDERS.ACTIVE_IND = 1
		AND ORDERS.CATALOG_TYPE_CD = 1363
    )
    AND (
        ORDERS.CATALOG_CD = PI_THERA_CLASS_VIEW.DRUG_CAT_CD
        AND PI_THERA_CLASS_VIEW.DRUG_CAT IN (
            'narcotic analgesic combinations', 
            'narcotic analgesics',
            'nonsteroidal anti-inflammatory agents',
            'cox-2 inhibitors',
            'gamma-aminobutyric acid analogs',
            'analgesic combinations',
            'miscellaneous analgesics',
            'topical anesthetics'
        )
    )
	AND (
		CLINICAL_EVENT.EVENT_ID = CE_MED_RESULT.EVENT_ID
		AND CE_MED_RESULT.ADMIN_ROUTE_CD = CV_ADMIN_ROUTE.CODE_VALUE
		AND CE_MED_RESULT.DOSAGE_UNIT_CD = CV_DOSAGE_UNIT.CODE_VALUE
		AND CE_MED_RESULT.INFUSION_UNIT_CD = CV_INFUSION_UNIT.CODE_VALUE
		AND CE_MED_RESULT.IV_EVENT_CD = CV_IV_EVENT.CODE_VALUE
	)
