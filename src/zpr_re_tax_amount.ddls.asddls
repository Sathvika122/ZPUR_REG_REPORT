@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_TAX_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED 
}
define view entity ZPR_RE_TAX_AMOUNT
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_RE_FINAL_PREVIEW  
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( CGST) as CGST,
   
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( IGST) as IGST,
   
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   sum( SGST) as SGST,
   
    TESTFIELD1,
    CompanyCodeCurrency
   
}
////ADDED CONDITION
//    where    AccountingDocumentType       = 'RE'
//  and  (TransactionTypeDetermination = 'WRX'
//  or   TransactionTypeDetermination = 'BSX'
//  or   TransactionTypeDetermination = 'FR3' )
//  or(
//       TransactionTypeDetermination = 'KBS'
//    and FinancialAccountType         = 'S'
//  
//
//) and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

///written by Ramesh.G

where
    AccountingDocumentType = 'RE'         
and (
      TransactionTypeDetermination = 'WRX'
   or TransactionTypeDetermination = 'BSX'
   or TransactionTypeDetermination = 'FR3'
   or (
           TransactionTypeDetermination = 'KBS'
       and FinancialAccountType         = 'S'
      )
)
//and PostingDate                           -- ✅ applies to all branches
//        between $parameters.p_ActualEntryDateFrom
//            and $parameters.p_ActualEntryDateTo
//where  TESTFIELD1 = 'EXPENSIVE'


//ennded by ramesh.G
group by 
  TESTFIELD1,
    CompanyCodeCurrency,
       SourceLedger,
     CompanyCode,
     FiscalYear,
     AccountingDocument,
     LedgerGLLineItem,
     Ledger,
     
     //addded by ramesh.G
      PostingDate  
