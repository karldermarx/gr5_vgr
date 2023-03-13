@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: System Title'

define view entity ZGR5_I_SYSTEMTITLEVH as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZGR5_VGR_SYSTEM_TITLE')
{
    @UI.hidden: true
    key domain_name,
    
    @UI.hidden: true
    key value_position,
    
    @UI.hidden: true
    key language,
    
    @EndUserText: {label: 'System Title', quickInfo: 'System Title'}
    @ObjectModel.text.element: ['SystemTitle']
    value_low as SystemTitle,
    
    @EndUserText: {label: 'System Title Text', quickInfo: 'System Title Text'}
    text as Statustext
}
