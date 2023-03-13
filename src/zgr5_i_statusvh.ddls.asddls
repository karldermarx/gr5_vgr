@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Status'

define view entity ZGR5_I_StatusVH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZGR5_VGR_RENTALSTATUS') 
{
    @UI.hidden: true
    key domain_name,
    
    @UI.hidden: true
    key value_position,
    
    @UI.hidden: true
    key language,
    
    @EndUserText: {label: 'Rental Status', quickInfo: 'Rental Status'}
    @ObjectModel.text.element: ['RentalStatus']
    value_low   as RentalStatus,
    
    @EndUserText: {label: 'Rental Status Text', quickInfo: 'Rental Status Text'}
    text        as StatusText
}
