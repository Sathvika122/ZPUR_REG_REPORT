@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_DATA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_DATA 
// with parameters
//
//    
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo : abap.dats

 as select from I_JournalEntryItem
{
    key SourceLedger,
    key CompanyCode,
    key FiscalYear,
    key AccountingDocument,
    key LedgerGLLineItem,
    key Ledger,
    AccountingDocumentItem,
    AccountingDocumentType,
   Supplier,
   I_JournalEntryItem._Supplier.SupplierName as SupplierFullName,
   I_JournalEntryItem._Supplier.TaxNumber3 as gst_number,
I_JournalEntryItem._Supplier.Country,
I_JournalEntryItem._Supplier.Region,
PurchasingDocument,
PurchasingDocumentItem,
ReversalReferenceDocument,
  @Semantics.quantity.unitOfMeasure: 'UOM'
ReferenceQuantity  as Quantity , 
ReferenceQuantityUnit as UOM,
Product,
I_JournalEntryItem._JournalEntry.DocumentReferenceID as InvoiceReference,
PostingDate,
DocumentDate,
TaxCode , 
I_JournalEntryItem._TaxCode._Text.TaxCodeName,
GLAccount,
I_JournalEntryItem._GLAccountText.GLAccountLongName,
I_JournalEntryItem._GLAccountText.Language,
  @Semantics.amount.currencyCode: 'TransactionCurrency'
AmountInTransactionCurrency,
@Semantics.amount.currencyCode: 'CompanyCodeCurrency'
AmountInCompanyCodeCurrency,
TransactionCurrency,


  case
           when I_JournalEntryItem.FinancialAccountType = 'K'
                and I_JournalEntryItem.TransactionTypeDetermination = 'EGK'
           then 'SUPPLIER'

           when I_JournalEntryItem.FinancialAccountType = 'K'
                and I_JournalEntryItem.TransactionTypeDetermination = 'KBS'
           then 'SUPPLIER'

           when I_JournalEntryItem.FinancialAccountType = 'A'
                and I_JournalEntryItem.TransactionTypeDetermination = 'ANL' 
           then 'EXPENSIVE'

           when I_JournalEntryItem.FinancialAccountType = 'S'
                and I_JournalEntryItem.TransactionTypeDetermination = 'KBS' 
           then 'EXPENSIVE'

           when I_JournalEntryItem.FinancialAccountType = 'S'
                and I_JournalEntryItem.TransactionTypeDetermination = ''
           then 'EXPENSIVE'
//           when ( I_JournalEntryItem.FinancialAccountType = 'S'
//                and I_JournalEntryItem.TransactionTypeDetermination = '' )
//           then 'EXPENSIVE'
           else '0'
       end                                               as TESTFIELD1,
       
        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_JournalEntryItem.FinancialAccountType = 'S'
                and (I_JournalEntryItem.TransactionTypeDetermination = 'KBS' or I_JournalEntryItem.TransactionTypeDetermination = '' ) and  I_JournalEntryItem.GLAccount <> '0021603002' /// CR11 KR Doc changes and I_JournalEntryItem.CostCenter <> ''
     
           then I_JournalEntryItem.AmountInCompanyCodeCurrency

       end                                               as ExpenseAmount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_JournalEntryItem.TransactionTypeDetermination = 'WIT' or I_JournalEntryItem.GLAccount = '0021603002'
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end 
                                                as WITAmount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
        case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JII' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as IGSTAmount,
       
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
        case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JIC' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as CGSTAmount,
       
                 @Semantics.amount.currencyCode: 'CompanyCodeCurrency'  
        case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JIS' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as SGSTAmount,
       
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JRI' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversaligst,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
                case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JRC' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversalCgst,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case
           when I_JournalEntryItem.TransactionTypeDetermination = 'JRS' 
           then I_JournalEntryItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversalSgst,
       
       
       
       
       I_JournalEntryItem.CompanyCodeCurrency,
       TransactionTypeDetermination,
       FinancialAccountType
}
where
  (I_JournalEntryItem.AccountingDocumentType = 'KR'

  or

  I_JournalEntryItem.AccountingDocumentType = 'KG' )

// I_JournalEntryItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
and SourceLedger = '0L' and Ledger = '0L'
