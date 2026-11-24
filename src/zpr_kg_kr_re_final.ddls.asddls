@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_RE_FINAL'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #XL,
//    dataClass: #MIXED
//}
//@Analytics.dataCategory: #CUBE 
//@VDM.viewType: #COMPOSITE
define view entity ZPR_KG_KR_RE_FINAL
// with parameters
//
//    
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo : abap.dats
 as select from ZPR_KG_KR_FINAL   
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
 
 
  left outer join ZPR_KG_KR_REVERSAL_TAX 
  
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
        
        
  as _TAXaAMT on  _TAXaAMT.SourceLedger       = ZPR_KG_KR_FINAL.SourceLedger
                                                            and _TAXaAMT.Ledger             = ZPR_KG_KR_FINAL.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
                                                            and
                                                                _TAXaAMT.LedgerGLLineItem   = ZPR_KG_KR_FINAL.LedgerGLLineItem
                                                            and
                                                             _TAXaAMT.AccountingDocument = ZPR_KG_KR_FINAL.AccountingDocument
                                                            and
                                                                _TAXaAMT.FiscalYear         = ZPR_KG_KR_FINAL.FiscalYear
{
    
  key ZPR_KG_KR_FINAL.SourceLedger,
  key ZPR_KG_KR_FINAL.CompanyCode,
  key ZPR_KG_KR_FINAL.FiscalYear,
  key ZPR_KG_KR_FINAL.AccountingDocument,
  key ZPR_KG_KR_FINAL.Ledger,
  ZPR_KG_KR_FINAL.LedgerGLLineItem,
      ZPR_KG_KR_FINAL.Supplier,
    cast(  ZPR_KG_KR_FINAL.SupplierFullName as abap.char( 220 ) ) as SupplierFullName,
      ZPR_KG_KR_FINAL.gst_number,
      ZPR_KG_KR_FINAL.Country,
      ZPR_KG_KR_FINAL.Region,
      ZPR_KG_KR_FINAL.AccountingDocumentType,
      ZPR_KG_KR_FINAL.PurchasingDocument,
      ZPR_KG_KR_FINAL.PurchasingDocumentItem,
      ZPR_KG_KR_FINAL.BusinessPlace,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      ZPR_KG_KR_FINAL.Quantity, 
      ZPR_KG_KR_FINAL.UOM,
    // cast  ('' as abap.char( 50 )) as DocumentItemText,
      ZPR_KG_KR_FINAL.Product,
      ZPR_KG_KR_FINAL.ProductName,
    
      ZPR_KG_KR_FINAL.IN_HSNOrSACCode,
      ZPR_KG_KR_FINAL.InvoiceReference,
      ZPR_KG_KR_FINAL.PostingDate,
      ZPR_KG_KR_FINAL.DocumentDate,
      ZPR_KG_KR_FINAL.GLAccount,
      ZPR_KG_KR_FINAL.GLAccountLongName,
       
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_FINAL.AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      
      //  semantic for the sum
      @DefaultAggregation: #SUM
      ZPR_KG_KR_FINAL.ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      
      ZPR_KG_KR_FINAL.Tds_Amount,
       @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_FINAL.CGSTAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
        //  semantic for the sum
      @DefaultAggregation: #SUM
      ZPR_KG_KR_FINAL.IGSTAmount,
       @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_FINAL.SGSTAmount,
       @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   cast(_TAXaAMT.netpaid  as abap.curr( 29, 2 ) ) as  NetAmount,
   
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
    ZPR_KG_KR_FINAL.Unit_Price,
//    @DefaultAggregation: #SUM
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      ZPR_KG_KR_FINAL.Unit_Price,
      
     @DefaultAggregation: #SUM
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     ZPR_KG_KR_FINAL.ReversalCGST ,
      @DefaultAggregation: #SUM
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency' 
     ZPR_KG_KR_FINAL.ReversalIGST ,
      @DefaultAggregation: #SUM 
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
     ZPR_KG_KR_FINAL.ReversalSGST,
    ZPR_KG_KR_FINAL.CompanyCodeCurrency as  CompanyCodeCurrency,
      ZPR_KG_KR_FINAL.TransactionTypeDetermination,
      ZPR_KG_KR_FINAL.FinancialAccountType,
      ZPR_KG_KR_FINAL.TaxCode,
      ZPR_KG_KR_FINAL.TaxCodeName ,
      ZPR_KG_KR_FINAL.ReversalReferenceDocument
      
}

where  (ZPR_KG_KR_FINAL.AccountingDocumentType = 'KG' or ZPR_KG_KR_FINAL.AccountingDocumentType = 'KR' )
 
// ZPR_KG_KR_FINAL.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

