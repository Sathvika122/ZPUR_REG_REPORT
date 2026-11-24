@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_TAX_ENTRY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_TAX_ENTRY 
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

  as select from    ZPR_KG_KR_ENTRY_VIEW  
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )


  // changed association [1..1]  to left outer join
    left outer join ZPR_KG_KR_TAX
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo ) 
                    as _TaxData on  _TaxData.AccountingDocument = ZPR_KG_KR_ENTRY_VIEW.AccountingDocument
                                                                                          and _TaxData.FiscalYear         = ZPR_KG_KR_ENTRY_VIEW.FiscalYear
                                                                                          and _TaxData.CompanyCode        = ZPR_KG_KR_ENTRY_VIEW.CompanyCode
                                                                                          and _TaxData.TAXITEM_NEW_1      = ZPR_KG_KR_ENTRY_VIEW.TAXITEM_NEW_1
  //                                                       and _TaxData.TaxItemGroup       = ZKR_KG.TaxItemGroup




{
  key ZPR_KG_KR_ENTRY_VIEW.CompanyCode,
  key ZPR_KG_KR_ENTRY_VIEW.AccountingDocument,
  key ZPR_KG_KR_ENTRY_VIEW.FiscalYear,


  key ZPR_KG_KR_ENTRY_VIEW.TAXITEM_NEW_1                                            as TaxItemGroup,
      //added
      ZPR_KG_KR_ENTRY_VIEW.IN_HSNOrSACCode,
      ZPR_KG_KR_ENTRY_VIEW.AccountingDocumentItem,
      //  key ZASSET_TRAN1.PurchasingDocument ,
      _TaxData.WIT_GL_Acc,
      _TaxData.WIT_GL_Acc_name,
      ZPR_KG_KR_ENTRY_VIEW.TESTFIELD1,
      ZPR_KG_KR_ENTRY_VIEW.FinancialAccountType,
      ZPR_KG_KR_ENTRY_VIEW.BusinessPlace,
      //      max(cast(PurchasingDocument as abap.dec(10,0))) as MaxPurchasingDocument,
      //      max( ZASSET_TRAN1.PurchasingDocument ) as PurchaseDoc,
      //      ZKR_KG.TransactionCurrency,
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
      //      ZKR_KG.AmountInTransactionCurrency,

      // CR11..



      //      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_ENTRY_VIEW.AmountInCompanyCodeCurrency                              as AmountInCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum(  get_numeric_value( _TaxData.IGST_NEW_CC ) ) as abap.curr(23, 2) ) as Total_IGST_CC,
      //      sum(  get_numeric_value( _SuppTax.IGST_NEW ) )                          as Total_IGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.CGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_CGST_CC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.SGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_SGST_CC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.WIT_value_CC ) ) as abap.curr(23, 2) ) as WIT_Value_CC,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.reversalCgst ) ) as abap.curr(23, 2) ) as reversalCgst,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.reversaligst ) ) as abap.curr(23, 2) ) as reversaligst,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( sum( get_numeric_value( _TaxData.reversalSgst ) ) as abap.curr(23, 2) ) as reversalSgst,
      ZPR_KG_KR_ENTRY_VIEW.CompanyCodeCurrency,
      ZPR_KG_KR_ENTRY_VIEW.TransactionCurrency
}
where
        ZPR_KG_KR_ENTRY_VIEW.Language      =  'E'
  //  and TaxItemGroup          is not null
  and(
        ZPR_KG_KR_ENTRY_VIEW.TAXITEM_NEW_1 is not null
    and ZPR_KG_KR_ENTRY_VIEW.TAXITEM_NEW_1 <> '000'
  )
  and   ZPR_KG_KR_ENTRY_VIEW.TESTFIELD1    <> '0'
//  and   ZPR_KG_KR_ENTRY_VIEW.PostingDate   between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

group by
  ZPR_KG_KR_ENTRY_VIEW.AccountingDocument,
  ZPR_KG_KR_ENTRY_VIEW.CompanyCode,
  ZPR_KG_KR_ENTRY_VIEW.FiscalYear,
  //  TaxItemGroup,
  ZPR_KG_KR_ENTRY_VIEW.TAXITEM_NEW_1,
  ZPR_KG_KR_ENTRY_VIEW.TESTFIELD1,
  ZPR_KG_KR_ENTRY_VIEW.FinancialAccountType,
  //  ZKR_KG.TransactionCurrency,
  //  ZKR_KG.AmountInTransactionCurrency,
  ZPR_KG_KR_ENTRY_VIEW.CompanyCodeCurrency,
  ZPR_KG_KR_ENTRY_VIEW.AmountInCompanyCodeCurrency,
  _TaxData.WIT_GL_Acc,
  _TaxData.WIT_GL_Acc_name,
  ZPR_KG_KR_ENTRY_VIEW.IN_HSNOrSACCode,
  ZPR_KG_KR_ENTRY_VIEW.TransactionCurrency,
  ZPR_KG_KR_ENTRY_VIEW.BusinessPlace,
  ZPR_KG_KR_ENTRY_VIEW.AccountingDocumentItem
