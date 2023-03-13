@AbapCatalog.sqlViewName: 'ZGR5_I_AVRAT'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Average Rating'
define view ZGR5_I_AVGRATING 
    as select from zgr5_vgr_rentop
    {
    key videogame_uuid as VideogameUuid,
    
    avg(rental_rating as abap.dec( 3, 1 )) as  AverageRating

    
    }

    where rental_rating != 0.0
    group by 
    videogame_uuid

    //Videogametitle//
