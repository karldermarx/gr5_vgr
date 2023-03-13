@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Videogame'
define root view entity ZGR5_I_VIDGAME
  as select from zgr5_vgr_vidgame
  composition [0..*] of ZGR5_I_RENTOP    as _RentalOperation
  //Änderung für AVG Rating
  association [1..1] to ZGR5_I_AVGRATING as _AverageRating on $projection.VideogameUuid = _AverageRating.VideogameUuid

{
  key videogame_uuid               as VideogameUuid,
      /*videogame_id           as VideogameId,*/
      vidgame_id                   as VidgameId,
      videogame_title              as VideogameTitle,
      videogame_genre              as VideogameGenre,
      videogame_release_year       as VideogameReleaseYear,
      _AverageRating.AverageRating as AverageRating,
      system_title                 as SystemTitle,


      case rental_status
        when 'N' then 'Out of stock'
        when 'A' then 'Available'
        when 'B' then 'Booked'
        else 'Unknown Status'
      end                          as RentalStatus,


      case system_title
        when 'PC'         then 'PC'
        when 'XBOX ONE'   then 'Xbox One'
        when 'PS4'        then 'Playstation 4'
        when 'PS5'        then 'Playstation 5'
        when 'N64'        then 'Nintendo 64'
        when 'XBOX S / X' then 'Xbox Series S / X'
        when 'NSW'        then 'Nintendo Switch'
        else 'Unknown Plattform'
       end                         as SystemTitleDescription,
       

      /* Transient Data */
      case rental_status
        when 'N' then 0
        when 'A' then 3
        when 'B' then 1
        else 0
      end                          as StatusCriticality,

      case
       when _AverageRating.AverageRating < 6.1 then 1
       when _AverageRating.AverageRating< 8.0 then 2
       when _AverageRating.AverageRating >= 8.0 then 3
       else 0
       end                         as AverageRatingSuccess,



      /* Associations */
      _RentalOperation
}
