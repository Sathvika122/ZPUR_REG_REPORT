@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_NET_AMOUNT'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_NET_AMOUNT
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

 as select  distinct from ZPR_RE_EXPENSE_AMOUNT
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

    left outer join ZPR_RE_TAX_AMOUNT
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
    
     as _TAXaAMT on  _TAXaAMT.SourceLedger       = ZPR_RE_EXPENSE_AMOUNT.SourceLedger
                                                           and _TAXaAMT.Ledger             = ZPR_RE_EXPENSE_AMOUNT.Ledger
    //and _TAXaAMT.SourceLedger       = ZPR_RE_EXPENSE_AMOUNT.SourceLedger
                                                           and

                                                               _TAXaAMT.LedgerGLLineItem   = ZPR_RE_EXPENSE_AMOUNT.LedgerGLLineItem
                                                           and

                                                               _TAXaAMT.AccountingDocument = ZPR_RE_EXPENSE_AMOUNT.AccountingDocument
                                                           and

                                                               _TAXaAMT.FiscalYear         = ZPR_RE_EXPENSE_AMOUNT.FiscalYear
  left outer join   ZPR_TAX_SC_SD_RE
//    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
     as _TAXSCSD on  _TAXSCSD.AccountingDocument = ZPR_RE_EXPENSE_AMOUNT.AccountingDocument
                                                           and _TAXSCSD.FiscalYear         = ZPR_RE_EXPENSE_AMOUNT.FiscalYear
                                                           and _TAXSCSD.CompanyCode        = ZPR_RE_EXPENSE_AMOUNT.CompanyCode
    //and
    // _TAXSCSD.AccountingDocumentItem         = ZGL_EXCHANCE_1.LedgerGLLineItem
    //and _TAXSCSD.PurchasingDocumentItem = ZGL_EXCHANCE_1.PurchasingDocumentItem
                                                           and _TAXSCSD.tax_item_group     = ZPR_RE_EXPENSE_AMOUNT.PurchasingDocumentItem


left outer join ZPR_SC_SD_RE_TAX
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
 as __TAXSCSDsgst_cgst on   __TAXSCSDsgst_cgst.AccountingDocument     = ZPR_RE_EXPENSE_AMOUNT.AccountingDocument
                                                    and __TAXSCSDsgst_cgst.FiscalYear             = ZPR_RE_EXPENSE_AMOUNT.FiscalYear
                                                    and __TAXSCSDsgst_cgst.CompanyCode            = ZPR_RE_EXPENSE_AMOUNT.CompanyCode
    //and
    // _TAXSCSD.AccountingDocumentItem         = ZGL_EXCHANCE_1.LedgerGLLineItem
                                                    //and _TAXSCSD.PurchasingDocumentItem = ZGL_EXCHANCE_1.PurchasingDocumentItem
                                                    and __TAXSCSDsgst_cgst.tax_item_group     = ZPR_RE_EXPENSE_AMOUNT.PurchasingDocumentItem







{
   key ZPR_RE_EXPENSE_AMOUNT.SourceLedger,
  key ZPR_RE_EXPENSE_AMOUNT.CompanyCode,
  key ZPR_RE_EXPENSE_AMOUNT.FiscalYear,
  key ZPR_RE_EXPENSE_AMOUNT.AccountingDocument,
  key ZPR_RE_EXPENSE_AMOUNT.LedgerGLLineItem,
  key ZPR_RE_EXPENSE_AMOUNT.Ledger,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
//      case
//      when _TAXaAMT.CGST <> 0   and _TAXaAMT.SGST <> 0
//      then
//      ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount + _TAXaAMT.CGST + _TAXaAMT.SGST
//
//      when ZPR_RE_EXPENSE_AMOUNT.FinancialAccountType = 'M' and ZPR_RE_EXPENSE_AMOUNT.TransactionTypeDetermination = 'BSX'   and __TAXSCSDsgst_cgst.CGST <> 0 and __TAXSCSDsgst_cgst.sgst <> 0
//      then ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount + __TAXSCSDsgst_cgst.sgst + __TAXSCSDsgst_cgst.CGST
//
//
//        when ZPR_RE_EXPENSE_AMOUNT.FinancialAccountType = 'M' and ZPR_RE_EXPENSE_AMOUNT.TransactionTypeDetermination = 'BSX'  and _TAXSCSD.igst <> 0
//      then ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount + _TAXSCSD.igst
//
//
//      when  _TAXaAMT.CGST = 0   and _TAXaAMT.SGST = 0
//      then ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount + _TAXaAMT.IGST
//      else
//      ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount

//written by ramesh>G
case

  when
    coalesce( cast( _TAXaAMT.CGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) <> 0
    and
    coalesce( cast( _TAXaAMT.SGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) <> 0

  then
    cast( ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount as abap.decfloat34 )
    +
    coalesce( cast( _TAXaAMT.CGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )
    +
    coalesce( cast( _TAXaAMT.SGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )

  when
    ZPR_RE_EXPENSE_AMOUNT.FinancialAccountType = 'M'
    and ZPR_RE_EXPENSE_AMOUNT.TransactionTypeDetermination = 'BSX'
    and coalesce( cast( __TAXSCSDsgst_cgst.CGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) <> 0
    and coalesce( cast( __TAXSCSDsgst_cgst.sgst as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) <> 0

  then
    cast( ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount as abap.decfloat34 )
    +
    coalesce( cast( __TAXSCSDsgst_cgst.CGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )
    +
    coalesce( cast( __TAXSCSDsgst_cgst.sgst as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )

  when
    ZPR_RE_EXPENSE_AMOUNT.FinancialAccountType = 'M'
    and ZPR_RE_EXPENSE_AMOUNT.TransactionTypeDetermination = 'BSX'
    and coalesce( cast( _TAXSCSD.igst as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) <> 0

  then
    cast( ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount as abap.decfloat34 )
    +
    coalesce( cast( _TAXSCSD.igst as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )

  when
    coalesce( cast( _TAXaAMT.CGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) = 0
    and
    coalesce( cast( _TAXaAMT.SGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) ) = 0

  then
    cast( ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount as abap.decfloat34 )
    +
    coalesce( cast( _TAXaAMT.IGST as abap.decfloat34 ), cast( 0 as abap.decfloat34 ) )

  else
    cast( ZPR_RE_EXPENSE_AMOUNT.ExpenseAmount as abap.decfloat34 )

end as netamount,
////end by ramesh.G
      ZPR_RE_EXPENSE_AMOUNT.CompanyCodeCurrency
}
//where  ZPR_RE_EXPENSE_AMOUNT.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
