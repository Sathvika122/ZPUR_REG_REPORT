@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_SUPPLIER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_SUPPLIER 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

as select from ZPR_RE_DATA  
//(      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
  key Ledger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
  key SourceLedger,
    Supplier,
    SupplierFullName,
    gst_number,
    Country,
    Region,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInCompanyCodeCurrency , 
    CompanyCodeCurrency,
   TransactionTypeDetermination,
 FinancialAccountType , 
 PostingDate
}
where 
FinancialAccountType = 'K'
//and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
