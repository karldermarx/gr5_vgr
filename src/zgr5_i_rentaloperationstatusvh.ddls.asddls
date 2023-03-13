@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Rental Operation Status'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZGR5_I_RENTALOPERATIONSTATUSVH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T(p_domain_name: 'ZGR5_VGR_RENTALOPERATIONSTATUS')
{
    @UI.hidden: true
    key domain_name,
    
    @UI.hidden: true
    key value_position,
    
    @UI.hidden: true
    key language,
    
    @EndUserText:{label: 'RentalOperationStatus', quickInfo: 'RentalOperationStatus' }
    @ObjectModel.text.element: ['RentalOperationStatusText']
    value_low as RentalOperationStatus,
    @EndUserText:{label: 'RentalOperationStatus Text', quickInfo: 'RentalOperationStatus Text' }
    text as RentalOperationStatusText
}
