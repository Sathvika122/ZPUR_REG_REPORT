@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_TAX_AMOUNT_ITEM'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_TAX_AMOUNT_ITEM
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_ASSET_FINAL_PREVIEW 
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    
    AssetClass,
    
   DocumentReferenceID,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum( Total_CGST_CC) as Total_CGST_CC,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( Total_IGST_CC ) as Total_IGST_CC,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sum( Total_SGST_CC ) as Total_SGST_CC,
    CompanyCodeCurrency
    
}
//where   ZPR_ASSET_FINAL_PREVIEW.AssetClass <> '' and  ZPR_ASSET_FINAL_PREVIEW.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
group by 
CompanyCodeCurrency,
  SourceLedger,
     CompanyCode,
     FiscalYear,
     AccountingDocument,
     LedgerGLLineItem,
     Ledger,
    DocumentReferenceID,
    AssetClass
