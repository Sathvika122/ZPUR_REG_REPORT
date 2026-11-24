@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_NET_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_NET_AMOUNT
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_ASSET_EXPENSE_AMOUNT
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
left outer join ZPR_ASSET_TAX_AMOUNT_ITEM
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
 as _TAXaAMT   on  _TAXaAMT.SourceLedger       = ZPR_ASSET_EXPENSE_AMOUNT.SourceLedger
                                                            and _TAXaAMT.Ledger             = ZPR_ASSET_EXPENSE_AMOUNT.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
                                                            and
                                                                _TAXaAMT.LedgerGLLineItem   = ZPR_ASSET_EXPENSE_AMOUNT.LedgerGLLineItem
                                                            and
                                                             _TAXaAMT.AccountingDocument = ZPR_ASSET_EXPENSE_AMOUNT.AccountingDocument
                                                            and
                                                                _TAXaAMT.FiscalYear         = ZPR_ASSET_EXPENSE_AMOUNT.FiscalYear


{
    key ZPR_ASSET_EXPENSE_AMOUNT.SourceLedger,
    key ZPR_ASSET_EXPENSE_AMOUNT.CompanyCode,
    key ZPR_ASSET_EXPENSE_AMOUNT.FiscalYear,
    key ZPR_ASSET_EXPENSE_AMOUNT.AccountingDocument,
    key ZPR_ASSET_EXPENSE_AMOUNT.LedgerGLLineItem,
    key ZPR_ASSET_EXPENSE_AMOUNT.Ledger,
    _TAXaAMT.DocumentReferenceID,
    @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    ZPR_ASSET_EXPENSE_AMOUNT.ExpenseAmount + _TAXaAMT.Total_CGST_CC + _TAXaAMT.Total_IGST_CC + _TAXaAMT.Total_SGST_CC as netamount,
    ZPR_ASSET_EXPENSE_AMOUNT.CompanyCodeCurrency
    
}
//where  ZPR_ASSET_EXPENSE_AMOUNT.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
