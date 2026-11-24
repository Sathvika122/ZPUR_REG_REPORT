@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_KG_KR_ENTRY_VIEW'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_KG_KR_ENTRY_VIEW  

//  with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats

as select from I_OperationalAcctgDocItem 
{
   key  I_OperationalAcctgDocItem.AccountingDocument,
  key  I_OperationalAcctgDocItem.FiscalYear,
  key  I_OperationalAcctgDocItem.CompanyCode,
       I_OperationalAcctgDocItem.FinancialTransactionType,
       I_OperationalAcctgDocItem.FinancialAccountType,
       I_OperationalAcctgDocItem.TransactionTypeDetermination,
       I_OperationalAcctgDocItem.GLAccount,
       I_OperationalAcctgDocItem.MasterFixedAsset,
        I_OperationalAcctgDocItem.AccountingDocumentItem,
       I_OperationalAcctgDocItem.TaxItemGroup,
       I_OperationalAcctgDocItem.IN_HSNOrSACCode,
       I_OperationalAcctgDocItem.BusinessPlace,
       
       //CR11
       case
       when (I_OperationalAcctgDocItem.TaxItemGroup = '000' and I_OperationalAcctgDocItem.FinancialAccountType = 'K' )
       then
       '999'
       when (I_OperationalAcctgDocItem.TaxItemGroup = '000' and I_OperationalAcctgDocItem.FinancialAccountType = 'S' and I_OperationalAcctgDocItem.GLAccount = '0021603002')
       then
       '999'
       when (I_OperationalAcctgDocItem.TaxItemGroup = '000' and I_OperationalAcctgDocItem.FinancialAccountType = 'S' and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WIT')
       then
       '999'
       else
       I_OperationalAcctgDocItem.TaxItemGroup
       end                                               as TAXITEM_NEW_1,
       I_OperationalAcctgDocItem.TransactionCurrency,
       I_OperationalAcctgDocItem.AccountingDocumentType,
       @Aggregation.default: #SUM
       @Semantics.amount.currencyCode: 'TransactionCurrency'
       I_OperationalAcctgDocItem.AmountInTransactionCurrency,

       //CR11
       I_OperationalAcctgDocItem.CompanyCodeCurrency,

       @Aggregation.default: #SUM
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency,
       I_OperationalAcctgDocItem.ClearingAccountingDocument,
       I_OperationalAcctgDocItem.ClearingJournalEntryFiscalYear,


       I_OperationalAcctgDocItem.Supplier,
       I_OperationalAcctgDocItem.PurchasingDocument,
//       I_OperationalAcctgDocItem.CostCenter,

       I_OperationalAcctgDocItem._Supplier.TaxNumber3,
       I_OperationalAcctgDocItem._Supplier.Region,
       I_OperationalAcctgDocItem.IN_GSTPlaceOfSupply,
       I_OperationalAcctgDocItem.PostingDate,
       I_OperationalAcctgDocItem.DocumentDate,
       I_OperationalAcctgDocItem._GLAccountInChartOfAccounts._Text.GLAccountName,
       I_OperationalAcctgDocItem._GLAccountInChartOfAccounts._Text.Language,
       I_OperationalAcctgDocItem.PurchasingDocumentItem,
       I_OperationalAcctgDocItem._JournalEntry.DocumentReferenceID,
       // CR11
       I_OperationalAcctgDocItem._JournalEntry.AccountingDocumentCreationDate,
       I_OperationalAcctgDocItem._TaxCode.TaxCode,
       I_OperationalAcctgDocItem._TaxCode._Text.TaxCodeName,
       I_OperationalAcctgDocItem._TaxCode._Text.Language as taxcodelang,
       I_OperationalAcctgDocItem._Supplier.SupplierName,
       I_OperationalAcctgDocItem._Supplier.Country,
       I_OperationalAcctgDocItem._Supplier.BusinessPartnerPanNumber,
       case
           when I_OperationalAcctgDocItem.FinancialAccountType = 'K'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'EGK'
           then 'SUPPLIER'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'K'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS'
           then 'SUPPLIER'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'A'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'ANL' 
           then 'EXPENSIVE'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS' or 
                I_OperationalAcctgDocItem.TransactionTypeDetermination = ''
           then 'EXPENSIVE'

           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and I_OperationalAcctgDocItem.TransactionTypeDetermination = '' and  I_OperationalAcctgDocItem.GLAccount <> '0021603002' 
           then 'EXPENSIVE'
//           when ( I_OperationalAcctgDocItem.FinancialAccountType = 'S'
//                and I_OperationalAcctgDocItem.TransactionTypeDetermination = '' )
//           then 'EXPENSIVE'
           else '0'
       end                                               as TESTFIELD1,
       
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and (I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS' or I_OperationalAcctgDocItem.TransactionTypeDetermination = '' ) and  I_OperationalAcctgDocItem.GLAccount <> '0021603002' /// CR11 KR Doc changes and I_OperationalAcctgDocItem.CostCenter <> ''
     
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency

       end                                               as ExpenseAmount,
       @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WIT' or I_OperationalAcctgDocItem.GLAccount = '0021603002'
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as WITAmount,
       
       
       
             @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case
           when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JRI' 
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversaligst,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
                case
           when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JRC' 
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversalCgst,
          @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
         case
           when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'JRS' 
           then I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency 
           else null
       end                                               as reversalSgst,
       I_OperationalAcctgDocItem.IsAutomaticallyCreated 
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
 ( I_OperationalAcctgDocItem.AccountingDocumentType = 'KR'

  or

  I_OperationalAcctgDocItem.AccountingDocumentType = 'KG' )
//and ( I_OperationalAcctgDocItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo

