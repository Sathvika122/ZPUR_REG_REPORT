@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_EXPENSE_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_EXPENSE_AMOUNT
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_RE_FINAL_PREVIEW
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    //added
    PurchasingDocumentItem,
    TransactionTypeDetermination, 
    FinancialAccountType,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( ExpenseAmount) as ExpenseAmount ,
  
 
    TESTFIELD1,
    CompanyCodeCurrency ,
    PostingDate
  
}
//where
//        AccountingDocumentType       = 'RE'
//  and  ( TransactionTypeDetermination = 'WRX'
//  or    TransactionTypeDetermination = 'BSX'
//  or    TransactionTypeDetermination = 'FR3' )
//  or(
//        TransactionTypeDetermination = 'KBS'
//    and FinancialAccountType         = 'S'
//  ) and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

//written by ramesh.g
where
    AccountingDocumentType = 'RE'
    and (
        TransactionTypeDetermination = 'WRX'
        or TransactionTypeDetermination = 'BSX'
        or TransactionTypeDetermination = 'FR3'
        or (
            TransactionTypeDetermination = 'KBS'
            and FinancialAccountType = 'S'
        )
    )
//    and PostingDate between
//        $parameters.p_ActualEntryDateFrom
//        and $parameters.p_ActualEntryDateTo
group by
 
  TESTFIELD1,
    CompanyCodeCurrency,
      SourceLedger,
     CompanyCode,
     FiscalYear,
     AccountingDocument,
     PurchasingDocumentItem,
      TransactionTypeDetermination, 
    FinancialAccountType,
     LedgerGLLineItem,
     Ledger,
     PostingDate
