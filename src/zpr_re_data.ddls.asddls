@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_DATA'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_DATA
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
      I_JournalEntryItem.Supplier,
      I_JournalEntryItem._Supplier.SupplierName            as SupplierFullName,
      I_JournalEntryItem._Supplier.TaxNumber3              as gst_number,
      I_JournalEntryItem._Supplier.Country,
      I_JournalEntryItem._Supplier.Region,
      PurchasingDocument,
      PurchasingDocumentItem,
      ReversalReferenceDocument,
      Product,
      I_JournalEntryItem._JournalEntry.DocumentReferenceID as InvoiceReference,
      PostingDate,
      DocumentDate,
      TaxCode,
      I_JournalEntryItem._TaxCode._Text.TaxCodeName,
      GLAccount,
      I_JournalEntryItem._GLAccountText.GLAccountLongName,
      I_JournalEntryItem._GLAccountText.Language,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      AmountInTransactionCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,
      CompanyCodeCurrency,
      AccountAssignmentNumber,
      
      @Semantics.quantity.unitOfMeasure: 'UOM'
ReferenceQuantity  as Quantity , 
ReferenceQuantityUnit as UOM,

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
                    and I_JournalEntryItem.TransactionTypeDetermination = 'FR3'
               then 'EXPENSIVE'

      when AccountingDocumentType = 'RE'
                    and( I_JournalEntryItem.TransactionTypeDetermination = 'KBS')  and FinancialAccountType = 'S'
               then ''


               when I_JournalEntryItem.FinancialAccountType = 'S'
                    and( I_JournalEntryItem.TransactionTypeDetermination = 'KBS' or I_JournalEntryItem.TransactionTypeDetermination = 'WRX')
               then 'EXPENSIVE'

               when I_JournalEntryItem.FinancialAccountType = 'S'
                    and I_JournalEntryItem.TransactionTypeDetermination = '' and  I_JournalEntryItem.GLAccount <> '0021603002'
               then 'EXPENSIVE'
      //           when ( I_JournalEntryItem.FinancialAccountType = 'S'
      //                and I_JournalEntryItem.TransactionTypeDetermination = '' )
      //           then 'EXPENSIVE'
               else '0'
           end                                             as TESTFIELD1,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
          when (I_JournalEntryItem.FinancialAccountType = 'S' or I_JournalEntryItem.FinancialAccountType = 'M')
               and (I_JournalEntryItem.TransactionTypeDetermination = 'FR3'  or   I_JournalEntryItem.TransactionTypeDetermination = 'KBS' or I_JournalEntryItem.TransactionTypeDetermination = '' or I_JournalEntryItem.TransactionTypeDetermination = 'BSX'
               or I_JournalEntryItem.TransactionTypeDetermination = 'WRX')  /// CR11 KR Doc changes and I_JournalEntryItem.CostCenter <> ''

          then I_JournalEntryItem.AmountInCompanyCodeCurrency

      end                                                  as ExpenseAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
        when I_JournalEntryItem.TransactionTypeDetermination = 'KBS' and AccountingDocumentType = 'RE' and  FinancialAccountType = 'S'
        then I_JournalEntryItem.AmountInCompanyCodeCurrency
        else null
      end                                                  as Transportation,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
          when I_JournalEntryItem.TransactionTypeDetermination = 'WIT'
          then I_JournalEntryItem.AmountInCompanyCodeCurrency
          else null
      end                                                  as WITAmount,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
         when I_JournalEntryItem.TransactionTypeDetermination = 'JII'
         then I_JournalEntryItem.AmountInCompanyCodeCurrency
         else null
      end                                                  as IGSTAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
         when I_JournalEntryItem.TransactionTypeDetermination = 'JIC'
         then I_JournalEntryItem.AmountInCompanyCodeCurrency
         else null
      end                                                  as CGSTAmount,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      case
         when I_JournalEntryItem.TransactionTypeDetermination = 'JIS'
         then I_JournalEntryItem.AmountInCompanyCodeCurrency
         else null
      end                                                  as SGSTAmount,
      I_JournalEntryItem.TransactionCurrency,
      TransactionTypeDetermination,
      FinancialAccountType


}
//where
////  AccountingDocumentType = 'WE'
//
//  or
//
//  AccountingDocumentType = 'RE'
//and  I_JournalEntryItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
//and SourceLedger = '0L' and Ledger = '0L'
  //written by rameshG
  
  where (
    AccountingDocumentType = 'WE'
    or AccountingDocumentType = 'RE'
)
//and I_JournalEntryItem.PostingDate 
//    between $parameters.p_ActualEntryDateFrom 
//    and $parameters.p_ActualEntryDateTo
and SourceLedger = '0L' 
and Ledger = '0L'
