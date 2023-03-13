@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Customer'

define view entity ZGR5_I_CustomerVH 
    as select from zgr5_vgr_cust
{
    key customer_uuid       as CustomerUuid,
    customer_id             as CustomerId,
    
    @EndUserText.label: 'Firstname'
    customer_firstname      as CustomerFirstname,
    
    @EndUserText.label: 'Lastname'
    customer_lastname       as CustomerLastname,
    
    customer_accession_date as CustomerAccessionDate,
    
    /* Transient Data */
    @UI.hidden: true
    concat_with_space(customer_firstname, customer_lastname, 1) as CustomerName
}
