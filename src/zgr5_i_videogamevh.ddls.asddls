@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value Help: Videogame'

define view entity ZGR5_I_VIDEOGAMEVH
  as select from zgr5_vgr_vidgame
{
  @ObjectModel.text.element: ['VideogameTitle']
  @UI.hidden: true
  key videogame_uuid         as VideogameUuid,
     /* videogame_id           as VideogameId,*/
      vidgame_id             as VidgameId,
      videogame_title        as VideogameTitle,
      system_title           as SystemTitle,
      videogame_genre        as VideogameGenre,
      videogame_release_year as VideogameReleaseYear,
      rental_status          as RentalStatus
}
