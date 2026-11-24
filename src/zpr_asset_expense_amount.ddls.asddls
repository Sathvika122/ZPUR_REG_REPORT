@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_EXPENSE_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_EXPENSE_AMOUNT 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select from ZPR_ASSET_FINAL_PREVIEW 
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
  key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    @Semantics.amount.currencyCode: 'TransactionCurrency'
   sum( ExpenseAmount) as ExpenseAmount ,
TransactionCurrency , 
CompanyCodeCurrency , 
PostingDate
}
 where  ZPR_ASSET_FINAL_PREVIEW.AssetClass <> ''  
// ZPR_ASSET_FINAL_PREVIEW.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
group by 
CompanyCodeCurrency,
TransactionCurrency , 
  SourceLedger,
     CompanyCode,
     FiscalYear,
     AccountingDocument,
     LedgerGLLineItem,
     Ledger , 
     PostingDate
