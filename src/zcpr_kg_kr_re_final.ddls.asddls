@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ZCPR_KG_KR_RE_FINAL'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZCPR_KG_KR_RE_FINAL as select from ZPR_KG_KR_RE_FINAL
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key Ledger,
    LedgerGLLineItem,
    Supplier,
    SupplierFullName,
    gst_number,
    Country,
    Region,
    AccountingDocumentType,
    PurchasingDocument,
    PurchasingDocumentItem,
    BusinessPlace,
    @Semantics.quantity.unitOfMeasure: 'UOM'
    Quantity,
    UOM,
    Product,
    ProductName,
    IN_HSNOrSACCode,
    InvoiceReference,
    PostingDate,
    DocumentDate,
    GLAccount,
    GLAccountLongName,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    AmountInCompanyCodeCurrency,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ExpenseAmount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    Tds_Amount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    CGSTAmount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    IGSTAmount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    SGSTAmount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    NetAmount,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    Unit_Price,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ReversalCGST,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ReversalIGST,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ReversalSGST,
   
    CompanyCodeCurrency,
    TransactionTypeDetermination,
    FinancialAccountType,
    TaxCode,
    TaxCodeName,
    ReversalReferenceDocument
}
