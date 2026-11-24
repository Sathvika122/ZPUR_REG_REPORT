@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_ASSET_FINAL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #A,
    sizeCategory: #XL,
    dataClass: #TRANSACTIONAL
}
@Analytics.dataCategory: #CUBE 
@VDM.viewType: #COMPOSITE
define view entity ZPR_RE_ASSET_FINAL_F2 

// with parameters
//
//    
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo : abap.dats 
    as
  select distinct from ZPR_RE_FINAL_PREVIEW
 
//   (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
//left outer join 
//ZPR_RE_NET_AMOUNT 
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
//
//      as _TAXaAMT           on  _TAXaAMT.SourceLedger       = ZPR_RE_FINAL_PREVIEW.SourceLedger
//                                                                    and _TAXaAMT.Ledger             = ZPR_RE_FINAL_PREVIEW.Ledger
//
//                                                                    and _TAXaAMT.LedgerGLLineItem   = ZPR_RE_FINAL_PREVIEW.LedgerGLLineItem
//                                                                    and _TAXaAMT.AccountingDocument = ZPR_RE_FINAL_PREVIEW.AccountingDocument
//                                                                    and _TAXaAMT.FiscalYear         = ZPR_RE_FINAL_PREVIEW.FiscalYear


    left outer join ZPR_TAX_SC_SD_RE  
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
      as _TAXSCSD           on  _TAXSCSD.AccountingDocument = ZPR_RE_FINAL_PREVIEW.AccountingDocument
                                                                    and _TAXSCSD.FiscalYear         = ZPR_RE_FINAL_PREVIEW.FiscalYear
                                                                    and _TAXSCSD.CompanyCode        = ZPR_RE_FINAL_PREVIEW.CompanyCode
    //and
    // _TAXSCSD.AccountingDocumentItem         = ZPR_RE_FINAL_PREVIEW.LedgerGLLineItem
    //and _TAXSCSD.PurchasingDocumentItem = ZPR_RE_FINAL_PREVIEW.PurchasingDocumentItem
                                                                    and _TAXSCSD.tax_item_group     = ZPR_RE_FINAL_PREVIEW.PurchasingDocumentItem


    left outer join ZPR_SC_SD_RE_TAX
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
     as __TAXSCSDsgst_cgst on  __TAXSCSDsgst_cgst.AccountingDocument = ZPR_RE_FINAL_PREVIEW.AccountingDocument
                                                                    and __TAXSCSDsgst_cgst.FiscalYear         = ZPR_RE_FINAL_PREVIEW.FiscalYear
                                                                    and __TAXSCSDsgst_cgst.CompanyCode        = ZPR_RE_FINAL_PREVIEW.CompanyCode
    //and
    // _TAXSCSD.AccountingDocumentItem         = ZPR_RE_FINAL_PREVIEW.LedgerGLLineItem
    //and _TAXSCSD.PurchasingDocumentItem = ZPR_RE_FINAL_PREVIEW.PurchasingDocumentItem
                                                                    and __TAXSCSDsgst_cgst.tax_item_group     = ZPR_RE_FINAL_PREVIEW.PurchasingDocumentItem

{
  key ZPR_RE_FINAL_PREVIEW.SourceLedger,
  key ZPR_RE_FINAL_PREVIEW.CompanyCode,
  key ZPR_RE_FINAL_PREVIEW.FiscalYear,
  key ZPR_RE_FINAL_PREVIEW.AccountingDocument,
  key ZPR_RE_FINAL_PREVIEW.LedgerGLLineItem,
  key ZPR_RE_FINAL_PREVIEW.Ledger,
      ZPR_RE_FINAL_PREVIEW.Supplier,
     cast( ZPR_RE_FINAL_PREVIEW.SupplierFullName as abap.char( 220 ) )as SupplierFullName,
      ZPR_RE_FINAL_PREVIEW.gst_number,
      ZPR_RE_FINAL_PREVIEW.Country,
      ZPR_RE_FINAL_PREVIEW.Region,
      ZPR_RE_FINAL_PREVIEW.ReversalReferenceDocument,
      ZPR_RE_FINAL_PREVIEW.AccountingDocumentType,
      ZPR_RE_FINAL_PREVIEW.GLAccount,
      ZPR_RE_FINAL_PREVIEW.GLAccountLongName,
      ZPR_RE_FINAL_PREVIEW.PurchasingDocument,
      ZPR_RE_FINAL_PREVIEW.PurchasingDocumentItem,
      ZPR_RE_FINAL_PREVIEW.Product,
      ZPR_RE_FINAL_PREVIEW.ProductName,
      ZPR_RE_FINAL_PREVIEW.BusinessPlace,
      @Semantics.quantity.unitOfMeasure: 'UOM'
ZPR_RE_FINAL_PREVIEW.Quantity, 
ZPR_RE_FINAL_PREVIEW.UOM,
      ZPR_RE_FINAL_PREVIEW.IN_HSNOrSACCode,
     cast( ZPR_RE_FINAL_PREVIEW.InvoiceReference as abap.char( 16 ) ) as InvoiceReference,
      ZPR_RE_FINAL_PREVIEW.PostingDate,
      ZPR_RE_FINAL_PREVIEW.DocumentDate,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_FINAL_PREVIEW.AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_FINAL_PREVIEW.ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_FINAL_PREVIEW.WITAmount,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      
//      ZPR_RE_FINAL_PREVIEW.Unit_Price,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
      cast(0 as  abap.dec( 23, 2  ) ) as  Unit_Price,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
case when ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE' 
     and ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination = 'BSX' 
     and ZPR_RE_FINAL_PREVIEW.FinancialAccountType = 'M'
     then coalesce(__TAXSCSDsgst_cgst.CGST, cast(0 as abap.curr(29,2)))
     else coalesce(ZPR_RE_FINAL_PREVIEW.CGST, cast(0 as abap.curr(29,2)))
end as CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      case when ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE' and ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination = 'BSX' and ZPR_RE_FINAL_PREVIEW.FinancialAccountType = 'M'

       then _TAXSCSD.igst

      else   ZPR_RE_FINAL_PREVIEW.IGST end        as IGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'

      case when ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE' and ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination = 'BSX' and ZPR_RE_FINAL_PREVIEW.FinancialAccountType = 'M'

      then __TAXSCSDsgst_cgst.sgst

      else ZPR_RE_FINAL_PREVIEW.SGST end          as SGST,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//     cast( _TAXaAMT.netamount     as abap.curr( 29, 2 ) )    as NetAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )       as ReversalIGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )       as ReversalCGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )       as ReversalSGST,
      ZPR_RE_FINAL_PREVIEW.CompanyCodeCurrency    as CompanyCodeCurrency,
      ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination,
      ZPR_RE_FINAL_PREVIEW.FinancialAccountType,
      case when ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE' and ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination = 'BSX' and ZPR_RE_FINAL_PREVIEW.FinancialAccountType = 'M'

      then _TAXSCSD.TaxCode
      else  ZPR_RE_FINAL_PREVIEW.TaxCode end      as TaxCode,

      case when ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE' and ZPR_RE_FINAL_PREVIEW.TransactionTypeDetermination = 'BSX' and ZPR_RE_FINAL_PREVIEW.FinancialAccountType = 'M'

       then _TAXSCSD.TaxCodeName
      else   ZPR_RE_FINAL_PREVIEW.TaxCodeName end as TaxCodeName
} 
//where ZPR_RE_FINAL_PREVIEW.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
where ZPR_RE_FINAL_PREVIEW.SourceLedger = '0L' and ZPR_RE_FINAL_PREVIEW.Ledger = '0L'
and ZPR_RE_FINAL_PREVIEW.AccountingDocumentType = 'RE'



union 
select distinct from ZPR_ASSET_FINAL_PREVIEW_1 
//(
//        p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo
//)

{
  key ZPR_ASSET_FINAL_PREVIEW_1.SourceLedger,
  key ZPR_ASSET_FINAL_PREVIEW_1.CompanyCode,
  key ZPR_ASSET_FINAL_PREVIEW_1.FiscalYear,
  key ZPR_ASSET_FINAL_PREVIEW_1.AccountingDocument,
  key ZPR_ASSET_FINAL_PREVIEW_1.LedgerGLLineItem,
  key ZPR_ASSET_FINAL_PREVIEW_1.Ledger,
      ZPR_ASSET_FINAL_PREVIEW_1.Supplier,
      ZPR_ASSET_FINAL_PREVIEW_1.SupplierFullName,
      ZPR_ASSET_FINAL_PREVIEW_1.gst_number,
      ZPR_ASSET_FINAL_PREVIEW_1.Country,
      ZPR_ASSET_FINAL_PREVIEW_1.Region,
        ReversalReferenceDocument,
      ZPR_ASSET_FINAL_PREVIEW_1.AccountingDocumentType,
      ZPR_ASSET_FINAL_PREVIEW_1.GLAccount,
      ZPR_ASSET_FINAL_PREVIEW_1.GLAccountLongName,
      ZPR_ASSET_FINAL_PREVIEW_1.PurchasingDocument,
      ZPR_ASSET_FINAL_PREVIEW_1.PurchasingDocumentItem,
      ZPR_ASSET_FINAL_PREVIEW_1.Product,
      ZPR_ASSET_FINAL_PREVIEW_1.ProductName,
    
BusinessPlace,
//@Semantics.quantity.unitOfMeasure: 'UOM'
ZPR_ASSET_FINAL_PREVIEW_1.Quantity , 
ZPR_ASSET_FINAL_PREVIEW_1.uom,



      ZPR_ASSET_FINAL_PREVIEW_1.IN_HSNOrSACCode,
      ZPR_ASSET_FINAL_PREVIEW_1.InvoiceReference,
      ZPR_ASSET_FINAL_PREVIEW_1.PostingDate,
      ZPR_ASSET_FINAL_PREVIEW_1.DocumentDate,
   //   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.AmountInCompanyCodeCurrency,
  //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.ExpenseAmount,
///@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.WITAmount,
//       @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
       ZPR_ASSET_FINAL_PREVIEW_1.Unit_Price,
//      ZPR_ASSET_FINAL_PREVIEW_1.Unit_Price,
//@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.Total_CGST_CC       as CGST,
   //   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.Total_IGST_CC       as IGST,
    //  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_ASSET_FINAL_PREVIEW_1.Total_SGST_CC       as SGST,
  //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  //////    ZPR_ASSET_FINAL_PREVIEW_1.NetAmount,
  //    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )   as ReversalIGST,
 //     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )   as ReversalCGST,
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( 0 as abap.curr( 10, 2 ) )   as ReversalSGST,
      ZPR_ASSET_FINAL_PREVIEW_1.TransactionCurrency as CompanyCodeCurrency,
      ZPR_ASSET_FINAL_PREVIEW_1.TransactionTypeDetermination,
      ZPR_ASSET_FINAL_PREVIEW_1.FinancialAccountType,
      ZPR_ASSET_FINAL_PREVIEW_1.TaxCode,
      ZPR_ASSET_FINAL_PREVIEW_1.TaxCodeName
}
//where ZPR_ASSET_FINAL_PREVIEW_1.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

where SourceLedger = '0L' and Ledger = '0L'
and ZPR_ASSET_FINAL_PREVIEW_1.AccountingDocumentType = 'RE'
