@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_RE_DATA_ENTRY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_RE_DATA_ENTRY 
// with parameters 
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
as select from I_OperationalAcctgDocItem


{
    key  I_OperationalAcctgDocItem.AccountingDocument,
  key  I_OperationalAcctgDocItem.FiscalYear,
  key  I_OperationalAcctgDocItem.CompanyCode,
  key  I_OperationalAcctgDocItem.AccountingDocumentItem,
       I_OperationalAcctgDocItem.FinancialTransactionType,
       I_OperationalAcctgDocItem.FinancialAccountType,
       I_OperationalAcctgDocItem.TransactionTypeDetermination,
       I_OperationalAcctgDocItem.GLAccount,
       I_OperationalAcctgDocItem.MasterFixedAsset,
       I_OperationalAcctgDocItem.TaxItemGroup,
       I_OperationalAcctgDocItem.TransactionCurrency,
       I_OperationalAcctgDocItem.AccountingDocumentType,
       I_OperationalAcctgDocItem.AccountAssignmentNumber,
I_OperationalAcctgDocItem.IN_HSNOrSACCode,
BusinessPlace,
       // CR11
       I_OperationalAcctgDocItem._JournalEntry.AccountingDocumentCreationDate,
       I_OperationalAcctgDocItem.CompanyCodeCurrency,
       I_OperationalAcctgDocItem.ClearingAccountingDocument,
       I_OperationalAcctgDocItem.ClearingJournalEntryFiscalYear,
       
       @Aggregation.default: #SUM
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency,
       @Aggregation.default: #SUM
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       I_OperationalAcctgDocItem.AmountInTransactionCurrency,

       I_OperationalAcctgDocItem.Supplier,
       I_OperationalAcctgDocItem.PurchasingDocument,
       I_OperationalAcctgDocItem._Supplier.TaxNumber3,
       I_OperationalAcctgDocItem._Supplier.BusinessPartnerPanNumber,
       I_OperationalAcctgDocItem._Supplier.Region,
       I_OperationalAcctgDocItem.IN_GSTPlaceOfSupply,
       I_OperationalAcctgDocItem.PostingDate,
       I_OperationalAcctgDocItem.DocumentDate,
       I_OperationalAcctgDocItem._GLAccountInChartOfAccounts._Text.GLAccountName,
       I_OperationalAcctgDocItem._GLAccountInChartOfAccounts._Text.Language,
       I_OperationalAcctgDocItem.PurchasingDocumentItem,
       I_OperationalAcctgDocItem._JournalEntry.DocumentReferenceID,
       I_OperationalAcctgDocItem._TaxCode.TaxCode,
       I_OperationalAcctgDocItem._TaxCode._Text.TaxCodeName,
       I_OperationalAcctgDocItem._TaxCode._Text.Language as taxcodelang,
       I_OperationalAcctgDocItem._Supplier.SupplierName,
       I_OperationalAcctgDocItem._Supplier.Country,
         cast(I_OperationalAcctgDocItem.AccountAssignmentNumber  as abap.char( 5 )) as REIndicator,
       case

           when ( I_OperationalAcctgDocItem.FinancialAccountType = 'K'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS' )
                or ( I_OperationalAcctgDocItem.FinancialAccountType = 'K'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = '' )
                
           then 'SUPPLIER'

           when ( I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WRX' )
                or 
                ( I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = '' )
                
                or 
                ( I_OperationalAcctgDocItem.FinancialAccountType = 'M'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'BSX' )
           then 'EXPENSIVE'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JII'
           then 'TAX'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JIC'
           then 'TAX'

          when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JIS'
           then 'TAX'
          when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WIT'
           then 'TAX'
  when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JIM'
           then 'TAX'
           else '0'
       end                                               as TESTFIELD1,
       
       //CR11
       
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and (I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS' or I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WRX' or I_OperationalAcctgDocItem.TransactionTypeDetermination = '')
       //               or I_OperationalAcctgDocItem.TransactionTypeDetermination = '' or I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WRX' ) or I_OperationalAcctgDocItem.AccountingDocumentType = 'KZ'

           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency
           when I_OperationalAcctgDocItem.FinancialAccountType = 'A'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'ANL' //and I_OperationalAcctgDocItem.AssetClass <> ''
            then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency

       end                                               as ExpenseAmount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WIT' or I_OperationalAcctgDocItem.GLAccount = '0021603002'
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency
           else null
       end                                               as WITAmount
       
       //    case
       //    when I_OperationalAcctgDocItem.FinancialTransactionType = 'K'
       //         and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'EGK'
       //    then 'SUPPLIER'
       //
       //    when I_OperationalAcctgDocItem.FinancialTransactionType = 'K'
       //         and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS'
       //    then 'SUPPLIER'
       //
       //    when I_OperationalAcctgDocItem.FinancialTransactionType = 'A'
       //         and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'ANL'
       //    then 'EXPENSIVE'
       //
       //    when I_OperationalAcctgDocItem.FinancialTransactionType = 'S'
       //         and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS'
       //    then 'EXPENSIVE'
       //
       //    when I_OperationalAcctgDocItem.FinancialTransactionType = 'S'
       //         and I_OperationalAcctgDocItem.TransactionTypeDetermination is null
       //    then 'EXPENSIVE'
       //
       //    else '0'
       //end as TESTFIELD
}

where
(  I_OperationalAcctgDocItem.AccountingDocumentType = 'WE'

  or

  I_OperationalAcctgDocItem.AccountingDocumentType = 'RE' )
//and  I_OperationalAcctgDocItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
