@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'PR_ASSET_DATA_ENTRY'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #XL,
    dataClass: #MIXED
}
define view entity ZPR_ASSET_DATA_ENTRY
// with parameters
//    p_ActualEntryDateFrom : abap.dats,
//    p_ActualEntryDateTo   : abap.dats
 as select from I_OperationalAcctgDocItem



{
    key I_OperationalAcctgDocItem.FiscalYear,
  key I_OperationalAcctgDocItem.AccountingDocument,
  key I_OperationalAcctgDocItem.CompanyCode,
  key I_OperationalAcctgDocItem.AccountingDocumentItem,
      I_OperationalAcctgDocItem.GLAccount,
      I_OperationalAcctgDocItem.TransactionTypeDetermination,
      I_OperationalAcctgDocItem.FinancialAccountType,
      I_OperationalAcctgDocItem.MasterFixedAsset,
      I_OperationalAcctgDocItem.TaxItemGroup,
      I_OperationalAcctgDocItem.PostingKey,
      I_OperationalAcctgDocItem.AccountingDocumentType,
      I_OperationalAcctgDocItem.IN_HSNOrSACCode,
      I_OperationalAcctgDocItem.BusinessPlace,
      @Semantics.quantity.unitOfMeasure: 'GoodsMovementEntryUnit'
  
      I_OperationalAcctgDocItem.QuantityInEntryUnit,
       I_OperationalAcctgDocItem.GoodsMovementEntryUnit, 
      case
        when I_OperationalAcctgDocItem.TaxItemGroup = '000'
        then
          '999'
        else
          I_OperationalAcctgDocItem.TaxItemGroup
      end                                               as TAXITEM_NEW,
      // CR11
      I_OperationalAcctgDocItem._JournalEntry.AccountingDocumentCreationDate,
      I_OperationalAcctgDocItem.ClearingAccountingDocument,
      I_OperationalAcctgDocItem.ClearingJournalEntryFiscalYear,

      I_OperationalAcctgDocItem.TransactionCurrency,
      I_OperationalAcctgDocItem.Supplier,
      I_OperationalAcctgDocItem.PurchasingDocument,
      I_OperationalAcctgDocItem._Supplier.TaxNumber3,
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
      I_OperationalAcctgDocItem._Supplier.BusinessPartnerPanNumber,
      I_OperationalAcctgDocItem._Supplier.Country,
      case
            when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'ANL'
             and I_OperationalAcctgDocItem.FinancialAccountType = 'A'
             and I_OperationalAcctgDocItem.TaxCode <> ''
            then
            'EXENSIVE'
            when I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS'
             and I_OperationalAcctgDocItem.FinancialAccountType = 'S'
             and I_OperationalAcctgDocItem.TaxCode <> ''
            then
            'EXENSIVE'
            when I_OperationalAcctgDocItem.TransactionTypeDetermination = ''
             and I_OperationalAcctgDocItem.FinancialAccountType = 'S'
             and I_OperationalAcctgDocItem.TaxCode <> ''
             and I_OperationalAcctgDocItem.GLAccount <> '0021603002' 
            then
            'EXENSIVE'
            when I_OperationalAcctgDocItem.FinancialAccountType = 'K'
            then
            'SUPPLIER'
            else
            'TAX'
            end                                         as TEST2,
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      I_OperationalAcctgDocItem.AmountInTransactionCurrency,
      
      //CR11....
      I_OperationalAcctgDocItem.CompanyCodeCurrency,
      
      @Aggregation.default: #SUM
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      I_OperationalAcctgDocItem.AmountInCompanyCodeCurrency,
      
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
       case
           when I_OperationalAcctgDocItem.FinancialAccountType = 'S'
                and (I_OperationalAcctgDocItem.TransactionTypeDetermination = 'KBS' or I_OperationalAcctgDocItem.TransactionTypeDetermination = 'WRX')
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
}
//where  I_OperationalAcctgDocItem.PostingDate between $parameters.p_ActualEntryDateFrom and $parameters.p_ActualEntryDateTo
