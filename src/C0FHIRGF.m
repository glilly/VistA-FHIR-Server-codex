C0FHIRGF ;VAMC/JS-FHIR MASTER AGGREGATOR ; 30-JAN-2026
 ;;1.1;C0FHIR PROJECT;;Jan 30, 2026;Build 2
 Q
GENFULL(RESULT,DFN,ENCPTR,SDT,EDT) ;RPC: C0FHIR GET FULL BUNDLE
 N BNDL,CNT,GLB,LRDFN,ENCID,VISIT,CURRENC,EDTM,CDT,TARGET,ERR,MEDENC
 S CNT=0,GLB=$NA(^TMP("C0FHIRGF",$J)) K @GLB,RESULT
 ; 1. Initialize Bundle Header
 S BNDL("resourceType")="Bundle",BNDL("type")="collection"
 ; 2. Get Patient Demographics (Module: PT)
 S LRDFN=$$GETPT^C0FHIRPT(.BNDL,.CNT,DFN)
 ; 3. Determine Mode: Single Encounter vs Date Range
 I +ENCPTR D
 . D PROC(ENCPTR,.BNDL,.CNT,DFN,LRDFN)
 . S MEDENC="ENC-"_ENCPTR
 E  D
 . S SDT=$G(SDT,0),EDT=$G(EDT,9999999),EDTM=EDT_".9999"
 . S CDT=SDT-.000001
 . F  S CDT=$O(^SCE("ADFN",DFN,CDT)) Q:'CDT!(CDT>EDTM)  D
 .. S CURRENC=0 F  S CURRENC=$O(^SCE("ADFN",DFN,CDT,CURRENC)) Q:'CURRENC  D
 ... D PROC(CURRENC,.BNDL,.CNT,DFN,LRDFN)
 ;
 ; Pull medications once per bundle to avoid duplicates in bulk mode.
 D GETMEDS^C0FHIRMX(.BNDL,.CNT,DFN,$G(MEDENC))
EXIT S BNDL("total")=CNT
 D ENCODE^XLFJSON("BNDL",GLB)
 M RESULT=@GLB K @GLB
 Q
PROC(IE,BNDL,CNT,DFN,LRDFN) ; Process clinical data for one encounter
 N VDT,VISIT,ENCID,TARGET,ERR
 S ENCID="ENC-"_IE
 K TARGET,ERR D GETS^DIQ(409.68,IE_",",".01;.05","IE","TARGET","ERR")
 I $D(ERR) Q
 S VDT=$G(TARGET(409.68,IE_",",.01,"I")),VISIT=$G(TARGET(409.68,IE_",",.05,"I"))
 S CNT=CNT+1,BNDL("entry",CNT,"resource","resourceType")="Encounter"
 S BNDL("entry",CNT,"resource","id")=ENCID
 S BNDL("entry",CNT,"resource","subject","reference")="Patient/"_DFN
 D GETLAB^C0FHIRLM(.BNDL,.CNT,LRDFN,VISIT,ENCID)
 D GETIMM^C0FHIRIM(.BNDL,.CNT,IE,ENCID)
 D GETVIT^C0FHIRVM(.BNDL,.CNT,DFN,VDT,ENCID)
 D GETPRC^C0FHIRPM(.BNDL,.CNT,IE,ENCID)
 D GETNOTES^C0FHIRNOTE(.BNDL,.CNT,IE,ENCID)
 Q
 ;
LOGERR(CONTEXT,ERRIN,BNDL,CNT,MSG) ; Append OperationOutcome to bundle
 N DIAG
 S DIAG=$G(MSG)
 I DIAG="",$D(ERRIN) S DIAG=$G(ERRIN("DIERR",1,"TEXT",1))
 I DIAG="" S DIAG="Unspecified error"
 S CNT=$G(CNT)+1
 S BNDL("entry",CNT,"resource","resourceType")="OperationOutcome"
 S BNDL("entry",CNT,"resource","issue",1,"severity")="error"
 S BNDL("entry",CNT,"resource","issue",1,"code")="exception"
 S BNDL("entry",CNT,"resource","issue",1,"details","text")=$G(CONTEXT)
 S BNDL("entry",CNT,"resource","issue",1,"diagnostics")=DIAG
 Q
