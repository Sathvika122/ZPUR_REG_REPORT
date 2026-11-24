@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register RE Consumption'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define view entity ZC_RE_ASSET_FINAL
//  with parameters
//      p_ActualEntryDateFrom : zde_actualentrydate1,
//      p_ActualEntryDateTo   : zde_actualentrydate1

  as select from ZPR_RE_ASSET_FINAL
//  (
//      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//      p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key LedgerGLLineItem,
  key Ledger,

      Supplier,
      SupplierFullName,
      gst_number,
      Country,
      Region,
      ReversalReferenceDocument,
      AccountingDocumentType,
      GLAccount,
      GLAccountLongName,
      PurchasingDocument,
      PurchasingDocumentItem,
      Product,
      ProductName,
      BusinessPlace,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      Quantity,
      UOM,
      IN_HSNOrSACCode,
      InvoiceReference,
      PostingDate,
      DocumentDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      WITAmount,
      Unit_Price,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      IGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      SGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      NetAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ReversalIGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ReversalCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ReversalSGST,


      CompanyCodeCurrency,
      TransactionTypeDetermination,
      FinancialAccountType,
      TaxCode,
      TaxCodeName
}
