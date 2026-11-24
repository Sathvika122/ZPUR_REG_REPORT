@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_NET_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_NET_AMOUNT_r
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

 as select distinct from ZPR_RE_NET_AMOUNT
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
{key SourceLedger,
 key CompanyCode,
 key FiscalYear,
 key AccountingDocument,
 key LedgerGLLineItem,
 key Ledger,
 netamount,
 CompanyCodeCurrency   
}
//where  ZPR_RE_EXPENSE_AMOUNT.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
