@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_TAX_AGG'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
} 
define view entity ZPR_ASSET_TAX_AGG 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select from ZPR_ASSET_DATA_ENTRY

//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
//changed from  association [1..1]
   left outer join ZPR_ASSET_TAX
//     (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
    as _TaxData on  _TaxData.AccountingDocument = ZPR_ASSET_DATA_ENTRY.AccountingDocument
                                                       and _TaxData.FiscalYear         = ZPR_ASSET_DATA_ENTRY.FiscalYear
                                                       and _TaxData.CompanyCode        = ZPR_ASSET_DATA_ENTRY.CompanyCode
                                                       and _TaxData.TaxItemGroup       = ZPR_ASSET_DATA_ENTRY.TaxItemGroup
{
  key ZPR_ASSET_DATA_ENTRY.CompanyCode,
  key ZPR_ASSET_DATA_ENTRY.AccountingDocument,
  key ZPR_ASSET_DATA_ENTRY.FiscalYear,
  key ZPR_ASSET_DATA_ENTRY.TaxItemGroup,
ZPR_ASSET_DATA_ENTRY.GLAccount,
ZPR_ASSET_DATA_ENTRY.GLAccountName,
ZPR_ASSET_DATA_ENTRY.PurchasingDocument,
ZPR_ASSET_DATA_ENTRY.PurchasingDocumentItem,
ZPR_ASSET_DATA_ENTRY.IN_HSNOrSACCode,
ZPR_ASSET_DATA_ENTRY.BusinessPlace,
@Semantics.quantity.unitOfMeasure: 'uom'
ZPR_ASSET_DATA_ENTRY.QuantityInEntryUnit, 
ZPR_ASSET_DATA_ENTRY.GoodsMovementEntryUnit as uom , 




   -- Grouping by TaxItemGroup
      //  key ZASSET_TRAN1.PurchasingDocument ,
      _TaxData.WIT_GL_Acc,
      _TaxData.WIT_GL_Acc_name,
      ZPR_ASSET_DATA_ENTRY.AccountingDocumentItem,
      ZPR_ASSET_DATA_ENTRY.TEST2,
      ZPR_ASSET_DATA_ENTRY.FinancialAccountType,
      ZPR_ASSET_DATA_ENTRY.DocumentReferenceID , 
      //      max(cast(PurchasingDocument as abap.dec(10,0))) as MaxPurchasingDocument,
      //      max( ZASSET_TRAN1.PurchasingDocument ) as PurchaseDoc,
      //      ZASSET_TRAN1.TransactionCurrency,
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
      //      cast( sum( get_numeric_value( _TaxData.Reverse_Charge_IGST_NEW ) ) as abap.curr(23, 2) ) as Total_Reverse_IGST,
      //
      //      //      sum( get_numeric_value( _SuppTax.Reverse_Charge_IGST_NEW ) )           as Total_Reverse_IGST,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.Reverse_Charge_CGST_NEW ) ) as abap.curr(23, 2) ) as Total_Reverse_CGST,
      //      //      sum( get_numeric_value( _SuppTax.Reverse_Charge_CGST_NEW ) )           as Total_Reverse_CGST,
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.Reverse_Charge_SGST_NEW ) ) as abap.curr(23, 2) ) as Total_Reverse_SGST,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      cast( sum( get_numeric_value( _TaxData.WIT_value ) ) as abap.curr(23, 2) )               as WIT_Value,
      //
      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      ZASSET_TRAN1.AmountInTransactionCurrency,

      //CR11
      ZPR_ASSET_DATA_ENTRY.CompanyCodeCurrency,

      //      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      ZPR_ASSET_DATA_ENTRY.AmountInTransactionCurrency  as AmountInCompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( sum(  get_numeric_value( _TaxData.IGST_NEW_CC ) ) as abap.curr(23, 2) ) as Total_IGST_CC,
      //      sum(  get_numeric_value( _SuppTax.IGST_NEW ) )                          as Total_IGST,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( sum( get_numeric_value( _TaxData.CGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_CGST_CC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( sum( get_numeric_value( _TaxData.SGST_NEW_CC ) ) as abap.curr(23, 2) )  as Total_SGST_CC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast( sum( get_numeric_value( _TaxData.WIT_value_CC ) ) as abap.curr(23, 2) ) as WIT_Value_CC,
      
      case
      when ZPR_ASSET_DATA_ENTRY.TEST2 <> 'TAX'
      then 000
      else 
      0 end as postingitemviem , 
      ZPR_ASSET_DATA_ENTRY.TransactionCurrency


      //      sum(cast( (  cast(ZASSET_TRAN1.AmountInTransactionCurrency as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.IGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.CGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.SGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.Reverse_Charge_IGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.Reverse_Charge_CGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2))
      //      + cast( coalesce( cast( _TaxData.Reverse_Charge_SGST_NEW as abap.dec(23, 2) ), 0 ) as abap.dec(23, 2)) ) as abap.dec(23, 2) )) as TotalAmount
      //
}
where
      ZPR_ASSET_DATA_ENTRY.Language =  'E'
  and ZPR_ASSET_DATA_ENTRY.TaxItemGroup          is not null
  and ZPR_ASSET_DATA_ENTRY.TEST2    <> 'TAX'
//and  ZPR_ASSET_DATA_ENTRY.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
group by
  ZPR_ASSET_DATA_ENTRY.AccountingDocument,
  ZPR_ASSET_DATA_ENTRY.CompanyCode,
  ZPR_ASSET_DATA_ENTRY.FiscalYear,
  ZPR_ASSET_DATA_ENTRY.GoodsMovementEntryUnit, 
  ZPR_ASSET_DATA_ENTRY.QuantityInEntryUnit ,
  ZPR_ASSET_DATA_ENTRY.TaxItemGroup,
  ZPR_ASSET_DATA_ENTRY.TEST2,
  ZPR_ASSET_DATA_ENTRY.FinancialAccountType,
  ZPR_ASSET_DATA_ENTRY.BusinessPlace,
  //  ZASSET_TRAN1.TransactionCurrency,
  //  ZASSET_TRAN1.AmountInTransactionCurrency,
  ZPR_ASSET_DATA_ENTRY.CompanyCodeCurrency,
  ZPR_ASSET_DATA_ENTRY.AmountInTransactionCurrency,
  _TaxData.WIT_GL_Acc,
  _TaxData.WIT_GL_Acc_name,
  ZPR_ASSET_DATA_ENTRY.AccountingDocumentItem,
 ZPR_ASSET_DATA_ENTRY.GLAccount,
 ZPR_ASSET_DATA_ENTRY.PurchasingDocument,
ZPR_ASSET_DATA_ENTRY.PurchasingDocumentItem,
ZPR_ASSET_DATA_ENTRY.IN_HSNOrSACCode,
ZPR_ASSET_DATA_ENTRY.GLAccountName , 
ZPR_ASSET_DATA_ENTRY.DocumentReferenceID,
ZPR_ASSET_DATA_ENTRY.TransactionCurrency
//  ZASSET_TRAN1.PurchasingDocument
//  _TaxData.IGST_NEW,
//  _TaxData.CGST_NEW,
//_TaxData.SGST_NEW,
//_TaxData.Reverse_Charge_IGST_NEW,
//_TaxData.Reverse_Charge_CGST_NEW,
//_TaxData.Reverse_Charge_SGST_NEW
