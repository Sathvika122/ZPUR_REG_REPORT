@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_TAX  

// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select
 from ZPR_KG_KR_ENTRY_VIEW  
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
     key AccountingDocument,
  key FiscalYear,
  key CompanyCode,
  AccountingDocumentItem,
      FinancialTransactionType,
      TransactionTypeDetermination,
      GLAccount,
      MasterFixedAsset,
      TaxItemGroup,
      TAXITEM_NEW_1,
  
      AccountingDocumentType,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,
      
      //CR11
      CompanyCodeCurrency,

      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      //
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
        when ZPR_KG_KR_ENTRY_VIEW.TaxItemGroup = '000' and ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'WIT'
        then
          '999'
        else
          ZPR_KG_KR_ENTRY_VIEW.TaxItemGroup
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
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JII'
      then get_numeric_value(AmountInTransactionCurrency)
      else 0
      end
      as abap.curr(23, 2)
      )   as IGST_NEW_CC,
      //
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JIC'
      then
          get_numeric_value(AmountInTransactionCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as CGST_NEW_CC,

      //
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'JIS'
      then
          get_numeric_value(AmountInTransactionCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as SGST_NEW_CC,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
      case
      when TransactionTypeDetermination = 'WIT'
      then
          get_numeric_value(AmountInTransactionCurrency)
      else
          0
      end
      as abap.curr(23, 2)
      )   as WIT_value_CC,
      
       case
      when TransactionTypeDetermination = 'WIT' or  ZPR_KG_KR_ENTRY_VIEW.GLAccount = '0021603002'
      then
          GLAccount
      else
          ''
      end
      
         as WIT_GL_Acc,
      case
      when TransactionTypeDetermination = 'WIT' or  ZPR_KG_KR_ENTRY_VIEW.GLAccount = '0021603002'
      then
          GLAccountName
      else
          ''
      end
      
         as WIT_GL_Acc_name ,
         
         
               @Semantics.amount.currencyCode: 'TransactionCurrency'
         case
           when TransactionTypeDetermination = 'JRI' 
           then AmountInTransactionCurrency 
           else null
       end                                               as reversaligst,
          @Semantics.amount.currencyCode: 'TransactionCurrency'
                case
           when TransactionTypeDetermination = 'JRC' 
           then AmountInTransactionCurrency 
           else null
       end                                               as reversalCgst,
          @Semantics.amount.currencyCode: 'TransactionCurrency'
         case
           when TransactionTypeDetermination = 'JRS' 
           then AmountInTransactionCurrency 
           else null
       end                                               as reversalSgst , 
       TransactionCurrency
       
      

}
where

  (
       ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JII'
    or ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JIS'
    or ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JIC'
     or   ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JRI'
    or ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JRC'
    or ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'JRS'
    or ZPR_KG_KR_ENTRY_VIEW.TransactionTypeDetermination = 'WIT'
    or ZPR_KG_KR_ENTRY_VIEW.GLAccount = '0021603002'
  )
  and  ZPR_KG_KR_ENTRY_VIEW.Language                     = 'E' 
  // ZPR_KG_KR_ENTRY_VIEW.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
