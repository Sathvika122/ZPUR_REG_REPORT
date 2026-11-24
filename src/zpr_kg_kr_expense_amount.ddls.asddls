@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_EXPENSE_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
} 
define view entity ZPR_KG_KR_EXPENSE_AMOUNT  

//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_KG_KR_FINAL
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key Ledger,
    
    LedgerGLLineItem,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( ExpenseAmount ) as ExpenseAmount ,
    
    CompanyCodeCurrency , 
    PostingDate
    
} 
where TESTFIELD1 = 'EXPENSIVE' 
//PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

group by 
   CompanyCodeCurrency,
   PostingDate,
     SourceLedger,
     CompanyCode,
     FiscalYear,
     AccountingDocument,
     Ledger,
    
    LedgerGLLineItem
 