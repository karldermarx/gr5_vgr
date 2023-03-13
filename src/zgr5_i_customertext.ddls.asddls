@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Text: Customer'

define view entity ZGR5_I_CustomerText 
as select from zgr5_vgr_cust 
{
    key customer_uuid       as CustomerUuid,
    customer_firstname      as CustomerFirstname,
    customer_lastname       as CustomerLastname,
    
    /* Transient Data */
    concat_with_space(customer_firstname, customer_lastname, 1) as Name
}
