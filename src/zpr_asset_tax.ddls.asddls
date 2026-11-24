@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_TAX 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select from ZPR_ASSET_DATA_ENTRY 
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
   key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
      TaxCode,
//      TaxCodeName,
      FinancialAccountType,
      TransactionTypeDetermination,

      Supplier,

//      TaxCalculationProcedure,
//      TaxCalculationProcedure_2,

      TaxNumber3,
      DocumentDate,
      IN_GSTPlaceOfSupply,
      AccountingDocumentType,
//      TransactionCurrency,
      GLAccount,
      GLAccountName,
      Region,
      TaxItemGroup,
       
      
      
      //CR11
      CompanyCodeCurrency,
      
//      @Aggregation.default: #SUM
//      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      AmountInCompanyCodeCurrency,

      //
      //      cast( _SuppInvTaxAgg.Total_IGST as ABAP.CURR(15, 2) ) as Total_IGST,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JII'
//      then get_numeric_value(AmountInTransactionCurrency)
//      else 0
//      end
//      as abap.curr(23, 2)
//      )   as IGST_NEW,
//      //
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JIC'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end
//      as abap.curr(23, 2)
//      )   as CGST_NEW,
//
//      //
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JIS'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end
//      as abap.curr(23, 2)
//      )   as SGST_NEW,
//      //
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JRI'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end
//      as abap.curr(23, 2)
//      )   as Reverse_Charge_IGST_NEW,
//      //
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JRS'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end as abap.curr(23, 2)
//      )   as Reverse_Charge_SGST_NEW,
//      //
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'JRC'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end
//      as abap.curr(23, 2)
//      )   as Reverse_Charge_CGST_NEW,
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      cast(
//      case
//      when TransactionTypeDetermination = 'WIT'
//      then
//          get_numeric_value(AmountInTransactionCurrency)
//      else
//          0
//      end
//      as abap.curr(23, 2)
//      )   as WIT_value,
      
      
      
      
      //CR11
      
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JII'
      then get_numeric_value(AmountInCompanyCodeCurrency)
      else 0
      end
      as abap.curr(23, 2)
      )   as IGST_NEW_CC,
      //
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JIC'
      then
          get_numeric_value(AmountInCompanyCodeCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as CGST_NEW_CC,

      //
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JIS'
      then
          get_numeric_value(AmountInCompanyCodeCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as SGST_NEW_CC,
      
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'WIT'
      then
          get_numeric_value(AmountInCompanyCodeCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as WIT_value_CC,
      
      case
      when TransactionTypeDetermination = 'WIT' or  ZPR_ASSET_DATA_ENTRY.GLAccount = '0021603002'
      then
          GLAccount
      else
          ''
      end
      
         as WIT_GL_Acc,
      case
      when TransactionTypeDetermination = 'WIT' or  ZPR_ASSET_DATA_ENTRY.GLAccount = '0021603002'
      then
          GLAccountName
      else
          ''
      end
      
         as WIT_GL_Acc_name,
      //
//      case
//          when TaxCode = 'I1'
//              and TaxCodeName = 'A/P Sales Tax, taxable, distributed to line items'
//              then 1
//          else 0
//      end as TEST_I1_TAX,


      DocumentReferenceID,
      PostingDate,

      SupplierName
      /* Associations */

}
where
    Language = 'E'
    
    //CR11 changes for Supplier coming in Tax value
    and 
    FinancialAccountType <> 'K'
//    and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
//  and
//  not (
//      TaxCode = 'I1'
//      and TaxCodeName = 'A/P Sales Tax, taxable, distributed to line items'
//  )
