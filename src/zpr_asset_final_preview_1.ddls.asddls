@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_FINAL_PREVIEW_1'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_FINAL_PREVIEW_1
//  with parameters
//
//
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
  as select distinct from ZPR_ASSET_FINAL_PREVIEW
//                          (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                          p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

    left outer join       ZPR_ASSET_NET_AMOUNT   
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
                                       as _TAXaAMT on  _TAXaAMT.SourceLedger       = ZPR_ASSET_FINAL_PREVIEW.SourceLedger
                                                                                                and _TAXaAMT.Ledger             = ZPR_ASSET_FINAL_PREVIEW.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
                                                                                                and _TAXaAMT.LedgerGLLineItem   = ZPR_ASSET_FINAL_PREVIEW.LedgerGLLineItem
                                                                                                and _TAXaAMT.AccountingDocument = ZPR_ASSET_FINAL_PREVIEW.AccountingDocument
                                                                                                and _TAXaAMT.FiscalYear         = ZPR_ASSET_FINAL_PREVIEW.FiscalYear

    left outer join       ZPR_ASSET_TAX_CODE
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                          p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
                           as _TAXCODE on  _TAXCODE.SourceLedger       = ZPR_ASSET_FINAL_PREVIEW.SourceLedger
                                                                                                and _TAXCODE.Ledger             = ZPR_ASSET_FINAL_PREVIEW.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
    //                                                            and
    //                                                                _TAXaAMT.LedgerGLLineItem   = ZPR_ASSET_FINAL_PREVIEW.LedgerGLLineItem
                                                                                                and _TAXCODE.AccountingDocument = ZPR_ASSET_FINAL_PREVIEW.AccountingDocument
                                                                                                and _TAXCODE.FiscalYear         = ZPR_ASSET_FINAL_PREVIEW.FiscalYear



{
  key ZPR_ASSET_FINAL_PREVIEW.SourceLedger,
  key ZPR_ASSET_FINAL_PREVIEW.CompanyCode,
  key ZPR_ASSET_FINAL_PREVIEW.FiscalYear,
  key ZPR_ASSET_FINAL_PREVIEW.AccountingDocument,
  key ZPR_ASSET_FINAL_PREVIEW.LedgerGLLineItem,
  key ZPR_ASSET_FINAL_PREVIEW.Ledger,
      ZPR_ASSET_FINAL_PREVIEW.Supplier,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      ZPR_ASSET_FINAL_PREVIEW.Quantity,
      ZPR_ASSET_FINAL_PREVIEW.uom,
      ZPR_ASSET_FINAL_PREVIEW.SupplierFullName,
      ZPR_ASSET_FINAL_PREVIEW.Country,
      ZPR_ASSET_FINAL_PREVIEW.Region,
      ZPR_ASSET_FINAL_PREVIEW.ProductName,
      ZPR_ASSET_FINAL_PREVIEW.ReversalReferenceDocument,
      ZPR_ASSET_FINAL_PREVIEW.IN_HSNOrSACCode,
      ZPR_ASSET_FINAL_PREVIEW.BusinessPlace,
      ZPR_ASSET_FINAL_PREVIEW.gst_number,
      ZPR_ASSET_FINAL_PREVIEW.AccountingDocumentType,
      ZPR_ASSET_FINAL_PREVIEW.PurchasingDocument,
      ZPR_ASSET_FINAL_PREVIEW.PurchasingDocumentItem,
      ZPR_ASSET_FINAL_PREVIEW.Product,
      _TAXaAMT.DocumentReferenceID as InvoiceReference,
      ZPR_ASSET_FINAL_PREVIEW.PostingDate,
      ZPR_ASSET_FINAL_PREVIEW.DocumentDate,

      _TAXCODE.TaxCode,
      _TAXCODE.TaxCodeName,
      ZPR_ASSET_FINAL_PREVIEW.GLAccount,
      ZPR_ASSET_FINAL_PREVIEW.GLAccountLongName,
      ZPR_ASSET_FINAL_PREVIEW.Language,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.AmountInCompanyCodeCurrency,
      ZPR_ASSET_FINAL_PREVIEW.ClearingAccountingDocument,
      ZPR_ASSET_FINAL_PREVIEW.ClearingJournalEntryFiscalYear,
      ZPR_ASSET_FINAL_PREVIEW.TEST2,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.WITAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.Total_CGST_CC,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.Total_IGST_CC,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW.Total_SGST_CC,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_ASSET_FINAL_PREVIEW.Quantity <> 0
      then
      cast( ZPR_ASSET_FINAL_PREVIEW.ExpenseAmount as abap.dec( 23, 2 ) )
      else
      cast( 0 as abap.dec( 23, 2  ))
      end                          as Unit_Price,
      //  cast(0 as  abap.dec( 23, 2  ) ) as  Unit_Price,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _TAXaAMT.netamount           as NetAmount,
      ZPR_ASSET_FINAL_PREVIEW.CompanyCodeCurrency,
      ZPR_ASSET_FINAL_PREVIEW.TransactionCurrency,
 
      ZPR_ASSET_FINAL_PREVIEW.TransactionTypeDetermination,
      ZPR_ASSET_FINAL_PREVIEW.FinancialAccountType
}
//  ZPR_ASSET_FINAL_PREVIEW.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
