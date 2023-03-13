@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View: Rental Operation'
define view entity ZGR5_I_RENTOP
  as select from zgr5_vgr_rentop
  association        to parent ZGR5_I_VIDGAME as _Videogame    on $projection.VideogameUuid = _Videogame.VideogameUuid
  association [1..1] to ZGR5_I_CustomerText   as _CustomerText on $projection.CustomerUuid = _CustomerText.CustomerUuid
{
  key rental_operation_uuid           as RentalOperationUuid,
      rental_id                       as RentalId,
      videogame_uuid                  as VideogameUuid,
      customer_uuid                   as CustomerUuid,
      rental_start_date               as RentalStartDate,
      rental_return_date              as RentalReturnDate,
      cuky_field                      as CukyField,
      @Semantics.amount.currencyCode: 'CukyField'

      rental_fee                      as RentalFee,
      rental_rating                   as RentalRating,
      /* Transient Data*/
      rental_operation_status         as RentalOperationStatus,
      case rental_operation_status
           when 'RETURNED' then 0
           when 'BORROWED' then 1
           else 3
      end                             as RentalOperationStatusCrit,

      case when dats_days_between($session.user_date, rental_return_date) > 14
                and rental_operation_status = 'BORROWED' then 3

           when dats_days_between($session.user_date, rental_return_date) >= 7
                and rental_operation_status = 'BORROWED' then 2

           when dats_days_between($session.user_date, rental_return_date) < 7
                and rental_operation_status = 'BORROWED' then 1
           else 0
      end                             as RentalDateCriticality,

      _CustomerText.Name              as CustomerName,
      _CustomerText.CustomerFirstname as CustomerFirstname,
      _CustomerText.CustomerLastname  as CustomerLastname,
      _Videogame.VideogameTitle       as VideogameTitle,

      /* Associations */
      _Videogame
}
