@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_TAX_FINAL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_TAX_FINAL
// with parameters 
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_RE_TAX_AGG  
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
   key CompanyCode,
  key AccountingDocument,
  key FiscalYear,
  key AccountingDocumentItem,
  key TaxItemGroup,
  WIT_GL_Acc,
  WIT_GL_Acc_name,
  TESTFIELD1,
  FinancialAccountType,
    IN_HSNOrSACCode,
    BusinessPlace,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  AmountInCompanyCodeCurrency,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  Total_IGST_CC as IGST,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  Total_CGST_CC as CGST,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  Total_SGST_CC as SGST,
   @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  WIT_Value_CC as WIT,
   CompanyCodeCurrency , 
   PostingDate
   
}
//where  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
