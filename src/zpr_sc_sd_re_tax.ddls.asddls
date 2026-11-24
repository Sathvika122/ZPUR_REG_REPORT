@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_SC_SD_RE_TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_SC_SD_RE_TAX
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select distinct from ZPR_TAX_SC_SD_RE  
// (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{
    key AccountingDocument,
    key FiscalYear,
    key CompanyCode,
    TaxItemGroup,
    TransactionCurrency,
    AccountingDocumentType,
    PurchasingDocument,
    PurchasingDocumentItem,
//    added by Ram.G
PostingDate, 
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    sgst,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
 case
   when TaxItemGroup  = '001'
   then sgst 
   
    when TaxItemGroup  = '002'
   then sgst
   
    when TaxItemGroup  = '003'
   then sgst
   
    when TaxItemGroup  = '004'
   then sgst
   
    when TaxItemGroup  = '005'
   then sgst
   
    when TaxItemGroup  = '006'
   then sgst
   
    when TaxItemGroup  = '007'
   then sgst
   
    when TaxItemGroup  = '008'
   then sgst
   
    when TaxItemGroup  = '009'
   then sgst
     end as CGST , 
  
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
// added by Ram.G
    else            '00000' 
 //end by ram>G
 end as tax_item_group,
   
   
   
   
   
 
   
    CompanyCodeCurrency
    
   
}
where  sgst  <> 0 and sgst is not null
//and  PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
