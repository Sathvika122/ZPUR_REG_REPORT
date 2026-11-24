@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_TAX_CODE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_TAX_CODE
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_ASSET_DATA

//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    AccountingDocumentItem,
    AccountingDocumentType,
    Supplier,
    AssetClass,
    SupplierFullName,
    gst_number,
    Country,
    Region,
    PurchasingDocument,
    PurchasingDocumentItem,
    Product,
    InvoiceReference,
    PostingDate,
    DocumentDate,
    TaxCode,
    TaxCodeName,
    GLAccount,
    GLAccountLongName,
    Language,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   // AmountInTransactionCurrency,
    AmountInCompanyCodeCurrency,
    TransactionCurrency,
    ClearingAccountingDocument,
    ClearingJournalEntryFiscalYear,
    TEST2,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ExpenseAmount,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    WITAmount,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    IGSTAmount,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CGSTAmount,
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    SGSTAmount,
    // @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CompanyCodeCurrency,
    TransactionTypeDetermination,
    FinancialAccountType 
}
where AssetClass  = ''  and TaxCode <> ''  and  TEST2 =  'EXENSIVE'
//and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
