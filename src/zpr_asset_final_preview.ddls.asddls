@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_FINAL_PREVIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_FINAL_PREVIEW
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
  as select from    ZPR_ASSET_DATA
//                 (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

    left outer join ZPR_RE_SUPPLIER
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
                     as _supplier  on  _supplier.SourceLedger       = ZPR_ASSET_DATA.SourceLedger
                                                                                            and _supplier.CompanyCode        = ZPR_ASSET_DATA.CompanyCode
                                                                                            and _supplier.FiscalYear         = ZPR_ASSET_DATA.FiscalYear
                                                                                            and _supplier.AccountingDocument = ZPR_ASSET_DATA.AccountingDocument
                                                                                            and _supplier.Ledger             = ZPR_ASSET_DATA.Ledger

    left outer join I_Product                                                 as _product   on _product.Product = ZPR_ASSET_DATA.Product

    left outer join ZPR_ASSET_TAX_AGG
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo ) 
                    as _taxamount on  _taxamount.CompanyCode            = ZPR_ASSET_DATA.CompanyCode
                                                                                            and _taxamount.FiscalYear             = ZPR_ASSET_DATA.FiscalYear
                                                                                            and _taxamount.AccountingDocument     = ZPR_ASSET_DATA.AccountingDocument
    //and _taxamount.AccountingDocumentItem           = ZPR_ASSET_DATA.AccountingDocumentItem
                                                                                            and _taxamount.PurchasingDocument     = ZPR_ASSET_DATA.PurchasingDocument
                                                                                            and _taxamount.PurchasingDocumentItem = ZPR_ASSET_DATA.PurchasingDocumentItem



{
  key ZPR_ASSET_DATA.SourceLedger,
  key ZPR_ASSET_DATA.CompanyCode,
  key ZPR_ASSET_DATA.FiscalYear,
  key ZPR_ASSET_DATA.AccountingDocument,
  key ZPR_ASSET_DATA.LedgerGLLineItem,
  key ZPR_ASSET_DATA.Ledger,
      ZPR_ASSET_DATA.AccountingDocumentItem,
      ZPR_ASSET_DATA.AccountingDocumentType,
      ZPR_ASSET_DATA.Supplier,
      ZPR_ASSET_DATA.SupplierFullName,
      ZPR_ASSET_DATA.Country,
      ZPR_ASSET_DATA.Region,
      ZPR_ASSET_DATA.AssetClass,
      _product._Text.ProductName,
      _taxamount.IN_HSNOrSACCode,
      ZPR_ASSET_DATA.ReversalReferenceDocument,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      _taxamount.QuantityInEntryUnit             as Quantity,
      _taxamount.uom,
      _taxamount.BusinessPlace,
      ZPR_ASSET_DATA.gst_number,
      ZPR_ASSET_DATA.PurchasingDocument,
      ZPR_ASSET_DATA.PurchasingDocumentItem,
      ZPR_ASSET_DATA.Product,
      ZPR_ASSET_DATA.InvoiceReference,
      ZPR_ASSET_DATA.PostingDate,
      ZPR_ASSET_DATA.DocumentDate,
      ZPR_ASSET_DATA.TaxCode,
      ZPR_ASSET_DATA.TaxCodeName,
      ZPR_ASSET_DATA.GLAccount,
      ZPR_ASSET_DATA.GLAccountLongName,
      ZPR_ASSET_DATA.Language,
      _taxamount.DocumentReferenceID,
      //AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZPR_ASSET_DATA.AmountInTransactionCurrency as AmountInCompanyCodeCurrency,




      @Semantics.amount.currencyCode: 'TransactionCurrency'
      _supplier.AmountInCompanyCodeCurrency      as NetAmount,
      ZPR_ASSET_DATA.ClearingAccountingDocument,
      ZPR_ASSET_DATA.ClearingJournalEntryFiscalYear,
      ZPR_ASSET_DATA.TEST2,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZPR_ASSET_DATA.ExpenseAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZPR_ASSET_DATA.WITAmount,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      case
      //      when  ZPR_ASSET_DATA.AssetClass <> ''
      //then
      _taxamount.Total_CGST_CC,
      // end                                   as CGSTAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      case
      //      when  ZPR_ASSET_DATA.AssetClass <> ''
      // then
      _taxamount.Total_IGST_CC,
      // end        as IGSTAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      case
      //      when  ZPR_ASSET_DATA.AssetClass <> ''
      // then
      _taxamount.Total_SGST_CC,
      //end    as SGSTAmount,

      //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //    ZPR_ASSET_DATA.IGSTAmount,
      //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //    ZPR_ASSET_DATA.CGSTAmount,
      //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //    ZPR_ASSET_DATA.SGSTAmount,
      ZPR_ASSET_DATA.CompanyCodeCurrency,
      ZPR_ASSET_DATA.TransactionTypeDetermination,
      ZPR_ASSET_DATA.FinancialAccountType,
      ZPR_ASSET_DATA.TransactionCurrency

}
where
      ZPR_ASSET_DATA.AssetClass  <> ''
 // and ZPR_ASSET_DATA.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
