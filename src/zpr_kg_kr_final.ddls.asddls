@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_FINAL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
@Analytics.dataCategory: #CUBE 
@VDM.viewType: #COMPOSITE
define view entity ZPR_KG_KR_FINAL
//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
  as select from    ZPR_KG_KR_DATA
//                 (
//                    p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo
//                    )

    left outer join ZPR_KG_KR_SUPPLIER
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo ) 
                    as _supplier      on  _supplier.SourceLedger       = ZPR_KG_KR_DATA.SourceLedger
                                                                                                and _supplier.CompanyCode        = ZPR_KG_KR_DATA.CompanyCode
                                                                                                and _supplier.FiscalYear         = ZPR_KG_KR_DATA.FiscalYear
                                                                                                and _supplier.AccountingDocument = ZPR_KG_KR_DATA.AccountingDocument
                                                                                                and _supplier.Ledger             = ZPR_KG_KR_DATA.Ledger

    left outer join ZPR_KG_KR_BUSINESS_PLACE
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
                     as _businessplace on  _businessplace.CompanyCode        = ZPR_KG_KR_DATA.CompanyCode
                                                                                                and _businessplace.FiscalYear         = ZPR_KG_KR_DATA.FiscalYear
                                                                                                and _businessplace.AccountingDocument = ZPR_KG_KR_DATA.AccountingDocument

    left outer join I_Product                                                 as _product       on _product.Product = ZPR_KG_KR_DATA.Product

    left outer join ZPR_KG_KR_TAX_ENTRY
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

                                                                              as _taxamount     on  _taxamount.CompanyCode            = ZPR_KG_KR_DATA.CompanyCode
                                                                                                and _taxamount.FiscalYear             = ZPR_KG_KR_DATA.FiscalYear
                                                                                                and _taxamount.AccountingDocument     = ZPR_KG_KR_DATA.AccountingDocument
                                                                                                and _taxamount.AccountingDocumentItem = ZPR_KG_KR_DATA.AccountingDocumentItem

//    left outer join ZPR_KG_KR_REVERSAL_TAX
//
//                    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//                    p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
//
//
//                                                                              as _TAXaAMT       on  _TAXaAMT.SourceLedger       = ZPR_KG_KR_DATA.SourceLedger
//                                                                                                and _TAXaAMT.Ledger             = ZPR_KG_KR_DATA.Ledger
//    //and _TAXaAMT.SourceLedger       = ZRE_EXPENSE_AMOUNT_ITEM.SourceLedger
//                                                                                                and _TAXaAMT.LedgerGLLineItem   = ZPR_KG_KR_DATA.LedgerGLLineItem
//                                                                                                and _TAXaAMT.AccountingDocument = ZPR_KG_KR_DATA.AccountingDocument
//                                                                                                and _TAXaAMT.FiscalYear         = ZPR_KG_KR_DATA.FiscalYear
{
  key ZPR_KG_KR_DATA.SourceLedger,
  key ZPR_KG_KR_DATA.CompanyCode,
  key ZPR_KG_KR_DATA.FiscalYear,
  key ZPR_KG_KR_DATA.AccountingDocument,
  key ZPR_KG_KR_DATA.Ledger,
      ZPR_KG_KR_DATA.AccountingDocumentType,
      ZPR_KG_KR_DATA.LedgerGLLineItem,
      _supplier.Supplier,
      _supplier.SupplierFullName,
      _supplier.gst_number,
      _supplier.Country,
      _supplier.Region,
      ZPR_KG_KR_DATA.ReversalReferenceDocument,
      ZPR_KG_KR_DATA.PurchasingDocument,
      ZPR_KG_KR_DATA.PurchasingDocumentItem,
      ZPR_KG_KR_DATA.Product,
      _taxamount.IN_HSNOrSACCode,
      _product._Text.ProductName,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      ZPR_KG_KR_DATA.Quantity,
      ZPR_KG_KR_DATA.UOM,
      //           @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      cast(0 as  abap.dec( 23, 2  ) ) as  Unit_Price,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.Quantity <> 0
      then
      cast( ZPR_KG_KR_DATA.ExpenseAmount as abap.dec( 23, 2 ) )
      else
      cast( 0 as abap.dec( 23, 2  ))
      end                                        as Unit_Price,



      _businessplace.BusinessPlace,
      ZPR_KG_KR_DATA.InvoiceReference,
      ZPR_KG_KR_DATA.PostingDate,
      ZPR_KG_KR_DATA.DocumentDate,
      ZPR_KG_KR_DATA.GLAccount,
      ZPR_KG_KR_DATA.GLAccountLongName,
      ZPR_KG_KR_DATA.Language,
      ZPR_KG_KR_DATA.TESTFIELD1,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_DATA.AmountInCompanyCodeCurrency as AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_DATA.ExpenseAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_KG_KR_DATA.WITAmount                   as Tds_Amount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then   _taxamount.Total_CGST_CC
      end                                        as CGSTAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then _taxamount.Total_IGST_CC end          as IGSTAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then   _taxamount.Total_SGST_CC end        as SGSTAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // _taxamount.
      _supplier.AmountInCompanyCodeCurrency      as NetAmount,


      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then  _taxamount.reversalCgst
      end                                        as ReversalCGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then  _taxamount.reversaligst
      end                                        as ReversalIGST,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_KG_KR_DATA.TESTFIELD1 = 'EXPENSIVE'
      then  _taxamount.reversalSgst
      end                                        as ReversalSGST,


      ZPR_KG_KR_DATA.CompanyCodeCurrency,
      ZPR_KG_KR_DATA.TaxCode,
      ZPR_KG_KR_DATA.TaxCodeName,
      ZPR_KG_KR_DATA.TransactionTypeDetermination,
      ZPR_KG_KR_DATA.FinancialAccountType
      //  ZPR_KG_KR_DATA.CompanyCodeCurrency
}
where
      ZPR_KG_KR_DATA.TESTFIELD1  = 'EXPENSIVE'
  //and ZPR_KG_KR_DATA.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
