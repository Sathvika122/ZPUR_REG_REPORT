@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_DATA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XXL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_DATA 
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
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
   AssetClass,
   I_JournalEntryItem._Supplier.SupplierFullName,
   I_JournalEntryItem._Supplier.TaxNumber3 as gst_number,
I_JournalEntryItem._Supplier.Country,
I_JournalEntryItem._Supplier.Region,
PurchasingDocument,
PurchasingDocumentItem,
ReversalReferenceDocument,
Product,
 DocumentItemText   as  InvoiceReference,
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
ClearingAccountingDocument, 
ClearingJournalEntryFiscalYear,
  @Semantics.quantity.unitOfMeasure: 'UOM'
ReferenceQuantity  as Quantity , 
ReferenceQuantityUnit as UOM,
  case
            when TransactionTypeDetermination = 'ANL'
             and FinancialAccountType = 'A'
             and TaxCode <> ''
            then
            'EXENSIVE'
            when TransactionTypeDetermination = 'KBS'
             and FinancialAccountType = 'S'
             and TaxCode <> ''
            then
            'EXENSIVE'
            when TransactionTypeDetermination = ''
             and FinancialAccountType = 'S'
             and TaxCode <> ''
             and GLAccount <> '0021603002' 
            then
            'EXENSIVE'
            when FinancialAccountType = 'K'
            then
            'SUPPLIER'
            when TransactionTypeDetermination = 'JII'
             and FinancialAccountType = 'S'
             then 'tax' 
              when TransactionTypeDetermination = 'JIC'
             and FinancialAccountType = 'S'
             then 'tax'  
              when TransactionTypeDetermination = 'JIS'
             and FinancialAccountType = 'S'
             then 'tax'  
             else 
             null
            end                                         as TEST2,
       
        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_JournalEntryItem.FinancialAccountType = 'A'
                and (I_JournalEntryItem.TransactionTypeDetermination = 'ANL' or I_JournalEntryItem.TransactionTypeDetermination = '' ) /// CR11 KR Doc changes and I_JournalEntryItem.CostCenter <> ''
     
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
       I_JournalEntryItem.CompanyCodeCurrency,
       TransactionTypeDetermination,
       FinancialAccountType
}

// I_JournalEntryItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
where SourceLedger = '0L' and Ledger = '0L'
