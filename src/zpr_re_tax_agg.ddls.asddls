@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_TAX_AGG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
} 
define view entity ZPR_RE_TAX_AGG
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

  as select from    ZPR_RE_DATA_ENTRY
//                 (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
  //changed from association [1..1] to left outer join
    left outer join ZPR_RE_TAX
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
                     as _TaxData on  _TaxData.AccountingDocument = ZPR_RE_DATA_ENTRY.AccountingDocument
                                                                                          and _TaxData.FiscalYear         = ZPR_RE_DATA_ENTRY.FiscalYear
                                                                                          and _TaxData.CompanyCode        = ZPR_RE_DATA_ENTRY.CompanyCode
                                                                                          and _TaxData.TaxItemGroup       = ZPR_RE_DATA_ENTRY.TaxItemGroup
{
  key ZPR_RE_DATA_ENTRY.CompanyCode,
  key ZPR_RE_DATA_ENTRY.AccountingDocument,
  key ZPR_RE_DATA_ENTRY.FiscalYear,
  key ZPR_RE_DATA_ENTRY.TaxItemGroup, -- Grouping by TaxItemGroup
      //  key ZASSET_TRAN1.PurchasingDocument ,
      ZPR_RE_DATA_ENTRY.AccountingDocumentItem,
      _TaxData.WIT_GL_Acc,
      _TaxData.WIT_GL_Acc_name,
      ZPR_RE_DATA_ENTRY.TESTFIELD1,
      ZPR_RE_DATA_ENTRY.FinancialAccountType,
      ZPR_RE_DATA_ENTRY.IN_HSNOrSACCode,
      ZPR_RE_DATA_ENTRY.BusinessPlace,

      //      max(cast(PurchasingDocument as abap.dec(10,0))) as MaxPurchasingDocument,
      //      max( ZASSET_TRAN1.PurchasingDocument ) as PurchaseDoc,
      //      ZI_RE_DATA.TransactionCurrency,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum(  get_numeric_value( _TaxData.IGST_NEW ) ) as abap.curr(23, 2) )               as Total_IGST,
      //      //      sum(  get_numeric_value( _SuppTax.IGST_NEW ) )                          as Total_IGST,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.CGST_NEW ) ) as abap.curr(23, 2) )                as Total_CGST,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.SGST_NEW ) ) as abap.curr(23, 2) )                as Total_SGST,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.WIT_value ) ) as abap.curr(23, 2) )               as WIT_Value,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      ZI_RE_DATA.AmountInTransactionCurrency,


      // cr11 changes


      //      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_DATA_ENTRY.AmountInCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum(  get_numeric_value( _TaxData.IGST_NEW_CC ) ) as abap.curr(23, 2) ) as Total_IGST_CC,
      //      sum(  get_numeric_value( _SuppTax.IGST_NEW ) )                          as Total_IGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.CGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_CGST_CC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.SGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_SGST_CC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.WIT_value_CC ) ) as abap.curr(23, 2) ) as WIT_Value_CC,
      ZPR_RE_DATA_ENTRY.CompanyCodeCurrency ,
      ZPR_RE_DATA_ENTRY.PostingDate

}
where
      ZPR_RE_DATA_ENTRY.Language    =  'E'
  and ZPR_RE_DATA_ENTRY.TaxItemGroup                  is not null
  and ZPR_RE_DATA_ENTRY.TESTFIELD1  <> 'TAX'
 // and ZPR_RE_DATA_ENTRY.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
group by
  ZPR_RE_DATA_ENTRY.AccountingDocument,
  ZPR_RE_DATA_ENTRY.AccountingDocumentItem,
  ZPR_RE_DATA_ENTRY.CompanyCode,
  ZPR_RE_DATA_ENTRY.FiscalYear,
  ZPR_RE_DATA_ENTRY.TaxItemGroup,
  ZPR_RE_DATA_ENTRY.TESTFIELD1,
  ZPR_RE_DATA_ENTRY.FinancialAccountType,
  //  ZI_RE_DATA.TransactionCurrency,
  //  ZI_RE_DATA.AmountInTransactionCurrency,
  ZPR_RE_DATA_ENTRY.CompanyCodeCurrency,
  ZPR_RE_DATA_ENTRY.AmountInCompanyCodeCurrency,
  _TaxData.WIT_GL_Acc,
  ZPR_RE_DATA_ENTRY.IN_HSNOrSACCode,
  ZPR_RE_DATA_ENTRY.BusinessPlace,
  _TaxData.WIT_GL_Acc_name , 
   ZPR_RE_DATA_ENTRY.PostingDate
