@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED 
}
define view entity ZPR_RE_TAX 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select from ZPR_RE_DATA_ENTRY
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

{
    key AccountingDocument,
  key AccountingDocumentItem,
  key FiscalYear,
  key CompanyCode,
      FinancialTransactionType,
      TransactionTypeDetermination,
      GLAccount,
      MasterFixedAsset,
      TaxItemGroup,
//      TransactionCurrency,
      AccountingDocumentType,
      //CR11
      CompanyCodeCurrency,
      
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      //
         @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
AmountInTransactionCurrency , 
TransactionCurrency , 
//      @Aggregation.default: #SUM
//      @Semantics.amount.currencyCode: 'TransactionCurrency'
//      AmountInTransactionCurrency,
      Supplier,
      PurchasingDocument,
      TaxNumber3,
      Region,
      IN_GSTPlaceOfSupply,
      PostingDate,
      DocumentDate,
      GLAccountName,
      Language,
      PurchasingDocumentItem,
      DocumentReferenceID,
      TaxCode,
      TaxCodeName,
      taxcodelang,
      SupplierName,
      Country,
      FinancialAccountType,

      case
        when ZPR_RE_DATA_ENTRY.TaxItemGroup = '000' and ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'BSX'
        then
          '999'
        else
          ZPR_RE_DATA_ENTRY.TaxItemGroup
      end as TAXITEM_NEW,

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
//
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
      
      // CR11
      
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JII'  or TransactionTypeDetermination = 'JIM' 
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
      when TransactionTypeDetermination = 'WIT' or  ZPR_RE_DATA_ENTRY.GLAccount = '0021603002'
      then
          GLAccount
      else
          ''
      end
      
         as WIT_GL_Acc,
      case
      when TransactionTypeDetermination = 'WIT' or  ZPR_RE_DATA_ENTRY.GLAccount = '0021603002'
      then
          GLAccountName
      else
          ''
      end
      
         as WIT_GL_Acc_name

}
where

  (
       ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'JII'
    or ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'JIS'
    or ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'JIC'
     or ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'JIM'
    or ZPR_RE_DATA_ENTRY.TransactionTypeDetermination = 'WIT'
    or ZPR_RE_DATA_ENTRY.GLAccount = '0021603002'
  )
  and  ZPR_RE_DATA_ENTRY.Language                     = 'E'
   
//and  ZPR_RE_DATA_ENTRY.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
