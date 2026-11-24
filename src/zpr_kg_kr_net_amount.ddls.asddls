@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_NET_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}  
define view entity ZPR_KG_KR_NET_AMOUNT 
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from ZPR_KG_KR_EXPENSE_AMOUNT 
//( 
//
//     p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo
//)

  left outer join ZPR_KG_KR_TAX_AMOUNT 
//   (
//       p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo
//  )
  
      as _TAXaAMT  on  _TAXaAMT.SourceLedger       = ZPR_KG_KR_EXPENSE_AMOUNT.SourceLedger
                                                           and _TAXaAMT.Ledger             = ZPR_KG_KR_EXPENSE_AMOUNT.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
                                                           and _TAXaAMT.LedgerGLLineItem   = ZPR_KG_KR_EXPENSE_AMOUNT.LedgerGLLineItem
                                                           and _TAXaAMT.AccountingDocument = ZPR_KG_KR_EXPENSE_AMOUNT.AccountingDocument
                                                           and _TAXaAMT.FiscalYear         = ZPR_KG_KR_EXPENSE_AMOUNT.FiscalYear

    left outer join ZPR_KG_KR_ENTRY_TAX
//    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
     as _Reversal on  
    //_Reversal.SourceLedger       = ZPR_KG_KR_EXPENSE_AMOUNT.SourceLedger
       //                                                    and _Reversal.Ledger             = ZPR_KG_KR_EXPENSE_AMOUNT.Ledger
    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
                                                            _Reversal.AccountingDocumentItem   = '002'
                                                           and _Reversal.AccountingDocument = ZPR_KG_KR_EXPENSE_AMOUNT.AccountingDocument
                                                           and _Reversal.FiscalYear         = ZPR_KG_KR_EXPENSE_AMOUNT.FiscalYear
                                                           and _Reversal.CompanyCode = ZPR_KG_KR_EXPENSE_AMOUNT.CompanyCode


{
     key ZPR_KG_KR_EXPENSE_AMOUNT.SourceLedger,
  key ZPR_KG_KR_EXPENSE_AMOUNT.CompanyCode,
  key ZPR_KG_KR_EXPENSE_AMOUNT.FiscalYear,
  key ZPR_KG_KR_EXPENSE_AMOUNT.AccountingDocument,
  key ZPR_KG_KR_EXPENSE_AMOUNT.Ledger,
      ZPR_KG_KR_EXPENSE_AMOUNT.LedgerGLLineItem,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //_TAXaAMT.CGSTAmount + _TAXaAMT.ReversalCGST + _TAXaAMT.IGSTAmount + _TAXaAMT.ReversalIGST   +  _TAXaAMT.SGSTAmount  + _TAXaAMT.ReversalSGST as taxtotal,
   cast(  -1 * _Reversal.reversalCgst as abap.curr( 10, 2 ) ) as reversalcgst ,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( -1 * _Reversal.reversaligst as abap.curr( 10, 2 )  ) as reversaligst , 
        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( -1 *  _Reversal.reversalSgst as abap.curr( 10, 2 ) ) as reversalSgst ,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case 
      when _TAXaAMT.CGSTAmount <> 0 and _TAXaAMT.SGSTAmount <> 0
      then 
      
      ZPR_KG_KR_EXPENSE_AMOUNT.ExpenseAmount + _TAXaAMT.CGSTAmount + _TAXaAMT.SGSTAmount
      
      when _TAXaAMT.CGSTAmount = 0 and _TAXaAMT.SGSTAmount = 0
      then  ZPR_KG_KR_EXPENSE_AMOUNT.ExpenseAmount + _TAXaAMT.IGSTAmount
      
      else 
      ZPR_KG_KR_EXPENSE_AMOUNT.ExpenseAmount
      end  as netpaid,
      ZPR_KG_KR_EXPENSE_AMOUNT.CompanyCodeCurrency
}
//where  ZPR_KG_KR_EXPENSE_AMOUNT.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
