@EndUserText.label: 'Projection View: Rental Operation'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity ZGR5_C_RENTOP_CUSTOMER 
    as projection on ZGR5_I_RENTOP
{
    key RentalOperationUuid,
    RentalId,
    VideogameUuid,
    CustomerUuid,
    RentalStartDate,
    RentalReturnDate,
    CukyField,
    RentalFee,
    RentalOperationStatus,
    RentalOperationStatusCrit,
    RentalDateCriticality,
    RentalRating,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    CustomerFirstname,
    @Search.defaultSearchElement: true
    @Search.fuzzinessThreshold: 0.7
    CustomerLastname,
    @EndUserText.label: 'Customer Name'
    CustomerName,
    VideogameTitle,
    
    /* Associations */
    _Videogame : redirected to parent ZGR5_C_VIDEOGAME_CUSTOMER
}
