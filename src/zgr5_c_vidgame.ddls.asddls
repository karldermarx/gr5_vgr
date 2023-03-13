@EndUserText.label: 'Projection View: Videogame'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
@Metadata.allowExtensions: true
define root view entity ZGR5_C_VIDGAME
  provider contract transactional_query
  as projection on ZGR5_I_VIDGAME
{
  key VideogameUuid,
      VidgameId,
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold: 0.7
      VideogameTitle,
      
      @EndUserText.label: 'System Title'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGR5_I_SYSTEMTITLEVH', element: 'SystemTitle' } }]
      SystemTitle,
      
      VideogameGenre,
      VideogameReleaseYear,
      
      @EndUserText.label: 'Average Rating'
      AverageRating,
      AverageRatingSuccess,
      
      @EndUserText.label: 'Rental Status'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGR5_I_STATUSVH', element: 'RentalStatus' } }]
      RentalStatus,
      
      /* Transient Data */
      StatusCriticality,
      
      /* Associations */
      _RentalOperation : redirected to composition child ZGR5_C_RENTOP
}
