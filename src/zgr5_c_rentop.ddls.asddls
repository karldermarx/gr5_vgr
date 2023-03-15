@EndUserText.label: 'Projection View: Rental Operation'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true

define view entity ZGR5_C_RENTOP
  as projection on ZGR5_I_RENTOP
{
  key RentalOperationUuid,
      /*RentalOperationId,*/
      RentalId,
      
      VideogameUuid,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGR5_I_VideogameVH', element: 'VideogameTitle' } }]
      VideogameTitle,
      
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZGR5_I_CustomerVH', element: 'CustomerUuid' } }]
      CustomerUuid,
      @EndUserText.label: 'Customer Name'
      CustomerName,
      
      RentalStartDate,
      RentalReturnDate,
      RentalDateCriticality,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      CukyField,
      RentalFee,
      RentalRating,
      @Consumption.valueHelpDefinition: [{entity: { name: 'ZGR5_I_RENTALOPERATIONSTATUSVH', element: 'RentalOperationStatus'} }]
      RentalOperationStatus,
      RentalOperationStatusCrit,

      /* Associations */
      _Videogame : redirected to parent ZGR5_C_VIDGAME
}
