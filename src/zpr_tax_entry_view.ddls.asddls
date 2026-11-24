@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_TAX_ENTRY_VIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_TAX_ENTRY_VIEW
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_RE_DATA_ENTRY
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )



{
     key AccountingDocument,
   key FiscalYear,
   key CompanyCode,
   //key AccountingDocumentItem,
   //FinancialTransactionType,
  // FinancialAccountType,
  /// TransactionTypeDetermination,
  // GLAccount,

   TaxItemGroup,
   TransactionCurrency,
   AccountingDocumentType,


  
//   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//   AmountInCompanyCodeCurrency,
//   @Semantics.amount.currencyCode: 'TransactionCurrency'
//   AmountInTransactionCurrency,

 
   PurchasingDocument,
   
  // GLAccountName,
  
   PurchasingDocumentItem,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   case when TransactionTypeDetermination = 'JII'
   then AmountInCompanyCodeCurrency end as igst , 
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   case when TransactionTypeDetermination = 'JIS'
   then AmountInCompanyCodeCurrency end as sgst , 
     @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
   case when TransactionTypeDetermination = 'JIC'
   then AmountInCompanyCodeCurrency end as cgst , 
   TaxCode,
   TaxCodeName,
   taxcodelang,
 case when TaxItemGroup = '001' 
 then '00010'
 when 
 TaxItemGroup = '002' 
 then '00020'
 
 when TaxItemGroup = '003'
 then '00030'
 
 when TaxItemGroup = '004'
 then '00040'
 
 when TaxItemGroup = '005'
 then '00050'
 
  when TaxItemGroup = '006'
 then '00060'
 
 when TaxItemGroup = '007'
 then '00070'
 
 when TaxItemGroup = '008'
 then '00080'
 
 when TaxItemGroup = '009'
 then '00090'
 
 end as tax_item_group,
   REIndicator,
   TESTFIELD1,
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//   ExpenseAmount,
//   
//   
//    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//   WITAmount,
   CompanyCodeCurrency
}
where TaxItemGroup = '001' or TaxItemGroup = '002' or TaxItemGroup = '003'
//and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
