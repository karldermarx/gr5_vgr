@EndUserText.label: 'Projection View: Videogame Customer'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZGR5_C_VIDEOGAME_CUSTOMER 
provider contract transactional_query
    as projection on ZGR5_I_VIDGAME
{
    key VideogameUuid,
    VidgameId,
    @Search.defaultSearchElement:true
    @Search.fuzzinessThreshold: 0.7
    VideogameTitle,
    SystemTitle,
    VideogameGenre,
    VideogameReleaseYear,
    AverageRating,
    @EndUserText.label: 'Rental Status'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGR5_I_STATUSVH', element: 'RentalStatus' } }]
    RentalStatus,
    StatusCriticality,
    AverageRatingSuccess,
    /* Associations */
    _RentalOperation : redirected to composition child ZGR5_C_RENTOP_CUSTOMER
}
