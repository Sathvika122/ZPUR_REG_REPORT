@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_REVERSAL_TAX'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_REVERSAL_TAX 
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

  as select from ZPR_KG_KR_NET_AMOUNT
//                 (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                 p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo
//                 )

{
  key SourceLedger,
  key CompanyCode,
  key FiscalYear,
  key AccountingDocument,
  key Ledger,
      LedgerGLLineItem,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      reversalcgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      reversaligst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      reversalSgst,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case when
      reversalcgst <> 0 and reversalSgst <> 0
        then   netpaid  - reversalcgst - reversalSgst
        when reversaligst <> 0
       then   netpaid  - reversaligst
       else
       netpaid
        end as netpaid,
      CompanyCodeCurrency
}
