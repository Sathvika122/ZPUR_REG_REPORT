@AccessControl.authorizationCheck: #NOT_ALLOWED
@EndUserText.label: 'ZC_RE_ASSET_FINAL_QUERY'
@ObjectModel.modelingPattern: #ANALYTICAL_QUERY
@ObjectModel.supportedCapabilities: [#ANALYTICAL_QUERY]
define transient view entity ZC_RE_ASSET_FINAL_QUERY
provider contract analytical_query
as projection on ZPR_KG_KR_FINAL
{
    SourceLedger,
    CompanyCode,
    FiscalYear,
    AccountingDocument,
     Ledger,
    AccountingDocumentType,
    LedgerGLLineItem,
    Supplier,
    SupplierFullName,
    gst_number,
    Country,
    Region,
    ReversalReferenceDocument,
    PurchasingDocument,
    PurchasingDocumentItem,
    Product,
    IN_HSNOrSACCode,
    ProductName,
    Quantity,
    UOM,
    Unit_Price,
    BusinessPlace,
    InvoiceReference,
    PostingDate,
    DocumentDate,
    GLAccount,
    GLAccountLongName,
    Language,
    TESTFIELD1,
    AmountInCompanyCodeCurrency,
    ExpenseAmount,
    Tds_Amount,
    CGSTAmount,
    IGSTAmount,
    SGSTAmount,
    NetAmount,
    ReversalCGST,
    ReversalIGST,
    ReversalSGST,
    CompanyCodeCurrency,
    TaxCode,
    TaxCodeName,
    TransactionTypeDetermination,
    FinancialAccountType
}
