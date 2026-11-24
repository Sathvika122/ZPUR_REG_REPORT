@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_FINAL_PREVIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_FINAL_PREVIEW  
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select distinct from ZPR_RE_DATA
//  (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )

 left outer join       ZPR_WE_DATA     
//    (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )   
    as _WEGLdata  on

                                                                _WEGLdata.FiscalYear             = ZPR_RE_DATA.FiscalYear
                                                            and _WEGLdata.CompanyCode            = ZPR_RE_DATA.CompanyCode
                                                            and _WEGLdata.PurchasingDocument     = ZPR_RE_DATA.PurchasingDocument
                                                            and _WEGLdata.PurchasingDocumentItem = ZPR_RE_DATA.PurchasingDocumentItem
  //and _WEGLdata.WEIndicator            = ZPR_RE_DATA.REIndicator
    left outer join       ZPR_RE_SUPPLIER 
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
        
    as _supplier  on  _supplier.SourceLedger       = ZPR_RE_DATA.SourceLedger
                                                            and _supplier.CompanyCode        = ZPR_RE_DATA.CompanyCode
                                                            and _supplier.FiscalYear         = ZPR_RE_DATA.FiscalYear
                                                            and _supplier.AccountingDocument = ZPR_RE_DATA.AccountingDocument
                                                            and _supplier.Ledger             = ZPR_RE_DATA.Ledger

    left outer join       ZPR_RE_TAX_FINAL 
//      (      p_ActualEntryDateFrom : $parameters.p_ActualEntryDateFrom,
//        p_ActualEntryDateTo   : $parameters.p_ActualEntryDateTo )
        as _taxamount on  _taxamount.CompanyCode            = ZPR_RE_DATA.CompanyCode
                                                            and _taxamount.FiscalYear             = ZPR_RE_DATA.FiscalYear
                                                            and _taxamount.AccountingDocument     = ZPR_RE_DATA.AccountingDocument
                                                            and _taxamount.AccountingDocumentItem = ZPR_RE_DATA.AccountingDocumentItem
  //and _taxamount.LedgerGLLineItem       = ZPR_RE_DATA.LedgerGLLineItem


    left outer join       I_Product           as _product   on _product.Product = ZPR_RE_DATA.Product


  

{
  key ZPR_RE_DATA.SourceLedger,
  key ZPR_RE_DATA.CompanyCode,
  key ZPR_RE_DATA.FiscalYear,
  key ZPR_RE_DATA.AccountingDocument,
  key ZPR_RE_DATA.LedgerGLLineItem,
  key ZPR_RE_DATA.Ledger,
      _supplier.Supplier,
      _supplier.SupplierFullName,
      _supplier.gst_number,
      _supplier.Country,
      _supplier.Region,
      ZPR_RE_DATA.AccountingDocumentType,
      ZPR_RE_DATA.ReversalReferenceDocument,
_taxamount.BusinessPlace,
      case
      when ZPR_RE_DATA.TransactionTypeDetermination = 'WRX'
      then _WEGLdata.GLAccount
        else
        ZPR_RE_DATA.GLAccount
      end                                   as GLAccount,
      case
         when ZPR_RE_DATA.TransactionTypeDetermination = 'WRX'
         then _WEGLdata.GLAccountLongName
           else
           ZPR_RE_DATA.GLAccountLongName
         end                                as GLAccountLongName,

      ZPR_RE_DATA.PurchasingDocument,
      ZPR_RE_DATA.PurchasingDocumentItem,
      ZPR_RE_DATA.Product,
      @Semantics.quantity.unitOfMeasure: 'UOM'
      ZPR_RE_DATA.Quantity , 
      ZPR_RE_DATA.UOM,
      
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
    // case 
   //  when ZPR_RE_DATA.Quantity <> 0
     //then 
   // cast( ZPR_RE_DATA.ExpenseAmount as abap.dec( 23, 2 ) ) /  cast(ZPR_RE_DATA.Quantity  as abap.dec( 23, 2 ))
     //else 
     //cast( 0 as abap.dec( 23, 2  )) 
     //end as Unit_Price,
      
 ///written by ramesh.g
case 
  when ZPR_RE_DATA.Quantity is null
    then cast(0 as abap.dec(23,2))
  when cast(ZPR_RE_DATA.Quantity as abap.dec(23,5)) = 0 
    then cast(0 as abap.dec(23,2))
  else
    cast(ZPR_RE_DATA.ExpenseAmount as abap.dec(23,2))
    /
    cast(ZPR_RE_DATA.Quantity as abap.dec(23,5))  
end as Unit_Price,
      
      
         
      _product._Text.ProductName,
     //'' as DocumentItemText,
     // _WEGLdata.DocumentItemText,
      _taxamount.IN_HSNOrSACCode,
      ZPR_RE_DATA.InvoiceReference as InvoiceReference,
      
      ZPR_RE_DATA.PostingDate,
      ZPR_RE_DATA.DocumentDate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_DATA.AmountInCompanyCodeCurrency  as AmountInCompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ZPR_RE_DATA.ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
      when ZPR_RE_DATA.TransactionTypeDetermination = 'WRX'
      then   ZPR_RE_DATA.WITAmount  end      as WITAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _taxamount.CGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _taxamount.IGST,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _taxamount.SGST,
    //  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      
      // @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      // ZPR_RE_DATA.Transportation as Transportationcharges,

      ZPR_RE_DATA.TESTFIELD1,
      ZPR_RE_DATA.CompanyCodeCurrency,
      ZPR_RE_DATA.TransactionTypeDetermination,
      ZPR_RE_DATA.TransactionCurrency, 
      ZPR_RE_DATA.FinancialAccountType,
      ZPR_RE_DATA.TaxCode,
      ZPR_RE_DATA.TaxCodeName
}
//where
//        ZPR_RE_DATA.AccountingDocumentType       = 'RE'
//  and  ( ZPR_RE_DATA.TransactionTypeDetermination = 'WRX'
//  or    ZPR_RE_DATA.TransactionTypeDetermination = 'BSX'
//  or    ZPR_RE_DATA.TransactionTypeDetermination = 'FR3' )
//  or(
//        ZPR_RE_DATA.TransactionTypeDetermination = 'KBS'
//    and ZPR_RE_DATA.FinancialAccountType         = 'S'
//  )
//  and  ZPR_RE_DATA.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

///written by rameshG
where
ZPR_RE_DATA.AccountingDocumentType = 'RE'
and (
      ZPR_RE_DATA.TransactionTypeDetermination = 'WRX'
   or ZPR_RE_DATA.TransactionTypeDetermination = 'BSX'
   or ZPR_RE_DATA.TransactionTypeDetermination = 'FR3'
   or (
           ZPR_RE_DATA.TransactionTypeDetermination = 'KBS'
       and ZPR_RE_DATA.FinancialAccountType         = 'S'
      )
)
//and ZPR_RE_DATA.PostingDate
//        between $parameters.p_ActualEntryDateFrom
//            and $parameters.p_ActualEntryDateTo
