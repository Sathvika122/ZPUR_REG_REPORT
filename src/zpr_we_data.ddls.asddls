@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_WE_DATA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_WE_DATA
// with parameters 
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_RE_DATA
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
key Ledger,
   key FiscalYear,
    key CompanyCode,
    key PurchasingDocument,
    key PurchasingDocumentItem,
    key AccountingDocument,
    AccountingDocumentType,
    Supplier,
     case when (AccountAssignmentNumber = '00')
            then cast( '01'  as abap.char( 5 ))
            else cast(AccountAssignmentNumber as abap.char( 5 ))
      end as WEIndicator,
    Product,
    InvoiceReference,
    PostingDate,
    DocumentDate,
    GLAccount,
    GLAccountLongName,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInCompanyCodeCurrency,
    CompanyCodeCurrency,
    TransactionTypeDetermination,
    FinancialAccountType 
     
    
}
//where AccountingDocumentType = 'WE'
//and
//    //changed condition 
//    TransactionTypeDetermination = 'BSX'  or TransactionTypeDetermination = 'KBS' 
//
//and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo


///written by Ramesh.G
where (
    AccountingDocumentType = 'WE'
    and (
        TransactionTypeDetermination = 'BSX'
        or TransactionTypeDetermination = 'KBS'
    )
)
//and PostingDate between $parameters.p_ActualEntryDateFrom
//                    and $parameters.p_ActualEntryDateTo
