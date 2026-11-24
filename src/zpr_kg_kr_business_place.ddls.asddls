@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_BUSINESS_PLACE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_BUSINESS_PLACE 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

 as select from ZPR_KG_KR_ENTRY_VIEW

//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )


{
   key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    
    
    Supplier , 
    SupplierName , 
    BusinessPlace 
}
where FinancialAccountType = 'K'
//  and PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
