CLASS lhc_zgr5_i_rentop DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zgr5_i_rentop RESULT result.

    METHODS cancel_rental_operation FOR MODIFY
      IMPORTING keys FOR ACTION zgr5_i_rentop~cancel_rental_operation.
    METHODS validateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~validateEndDate.
*    METHODS validateRentalFee FOR VALIDATE ON SAVE
*      IMPORTING keys FOR ZGR5_I_RENTOP~validateRentalFee.
    METHODS determineRentalId FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~determineRentalId.
    METHODS determineRentalStartDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~determineRentalStartDate.
    METHODS determineRentalFee FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~determineRentalFee.
    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~validateRating.
    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~validateStatus.
    METHODS determineRentalOperationStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~determineRentalOperationStatus.
    METHODS determineVidStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~determineVidStatus.
    METHODS validateUUID FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~validateUUID.
    METHODS validateEndDateNull FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_rentop~validateEndDateNull.



ENDCLASS.

CLASS lhc_zgr5_i_rentop IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel_rental_operation.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
       BY \_Videogame
      FIELDS ( RentalStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(vidgames)

      FIELDS ( RentalId RentalOperationStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).

      IF rentop-RentalOperationStatus = 'RETURNED'.
        DATA(message) = NEW zcm_gr5_videogame(
          severity = if_abap_behv_message=>severity-error
          textid   = zcm_gr5_videogame=>rentop_already_cancelled
          rentop_id = rentop-RentalId
           ).

        APPEND message TO reported-%other.
        APPEND CORRESPONDING #( rentop ) TO failed-zgr5_i_rentop.
        CONTINUE.
      ENDIF.

      rentop-RentalOperationStatus = 'RETURNED'.


      MODIFY ENTITY IN LOCAL MODE zgr5_i_rentop
       UPDATE FIELDS ( RentalOperationStatus )
       WITH VALUE #( ( %tky = rentop-%tky RentalOperationStatus = rentop-RentalOperationStatus ) ).

      message = NEW zcm_gr5_videogame(
       severity = if_abap_behv_message=>severity-success
       textid   = zcm_gr5_videogame=>rentop_cancelled_successfully
       ).

      APPEND message TO reported-%other.

      "Set Videogame Status back to available when cancelling an operation
      DATA(videogame) = vidgames[ 1 ].

      MODIFY ENTITY IN LOCAL MODE zgr5_i_vidgame
        UPDATE FIELDS ( RentalStatus )
        WITH VALUE #( ( %tky = videogame-%tky RentalStatus = 'A' ) ).

    ENDLOOP.

  ENDMETHOD.

  "Checks if endDate is before startDate
  METHOD validateEndDate.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      FIELDS ( RentalStartDate RentalReturnDate )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).
    LOOP AT rentops INTO DATA(rentop).
      IF rentop-RentalReturnDate < rentop-RentalStartDate.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_end_date ).
        APPEND message TO reported-%other.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

*  METHOD validateRentalFee.
*  "Read the data
*  READ entity in local mode ZGR5_I_RENTOP
*    fields ( RentalFee )
*    with CORRESPONDING #( keys )
*    RESULT DATA(rentops).
*    "Sequential processing of the data
*    loop at rentops into data(rentop).
*        if rentop-RentalFee <= 0.
*            DATA(message) = NEW zcm_gr5_videogame(
*                            severity = if_abap_behv_message=>severity-error
*                            textid   = zcm_gr5_videogame=>invalid_rental_fee ).
*            APPEND message TO reported-%other.
*        endif.
*    ENDLOOP.
*  ENDMETHOD.

  METHOD determineRentalId.
    "Read the data
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      FIELDS ( RentalId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).

      SELECT SINGLE FROM zgr5_vgr_rentop
          FIELDS MAX( rental_id  ) AS max_rental_id
          INTO @DATA(max_rental_id).

      rentop-RentalId = max_rental_id + 1.

      MODIFY ENTITY IN LOCAL MODE zgr5_i_rentop
          UPDATE FIELDS ( RentalId )
          WITH VALUE #( ( %tky = rentop-%tky RentalId = rentop-RentalId ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD determineRentalFee.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      FIELDS ( RentalFee CukyField )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      IF rentop-RentalReturnDate IS INITIAL.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_rent_end
                         ).
        APPEND message TO reported-%other.
      ELSE.
        rentop-RentalFee = ( rentop-RentalReturnDate - sy-datlo ) * 50 / 100 + 1.
        rentop-CukyField = 'EUR'.

        MODIFY ENTITY IN LOCAL MODE zgr5_i_rentop
          UPDATE FIELDS ( RentalFee CukyField )
          WITH VALUE #( ( %tky = rentop-%tky RentalFee = rentop-RentalFee CukyField = rentop-CukyField ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.


  "Check if Rating between 0 and 10
  METHOD validateRating.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
        FIELDS ( RentalRating )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      IF rentop-RentalRating < 0 OR rentop-RentalRating > 10.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_rental_rating
                        rental_rating = rentop-RentalRating
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  "Validate, if the Videogame is available while creating a new rental operation
  METHOD validateStatus.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
        FIELDS ( RentalId )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).
    LOOP AT rentops INTO DATA(rentop).
      SELECT SINGLE rental_status  FROM zgr5_vgr_vidgame
       WHERE ( videogame_uuid = @rentop-VideogameUuid )
       INTO @DATA(rental_status).


      IF rental_status = 'N' OR rental_status = 'B'.
        DATA(message) = NEW zcm_gr5_videogame(
                         severity = if_abap_behv_message=>severity-error
                         textid   = zcm_gr5_videogame=>videogame_not_available
                          ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  METHOD determineRentalOperationStatus.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      FIELDS ( RentalOperationStatus )
          WITH CORRESPONDING #( keys )
          RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      rentop-RentalOperationStatus = 'BORROWED'.

      MODIFY ENTITY IN LOCAL MODE zgr5_i_rentop
          UPDATE FIELDS ( RentalOperationStatus )
          WITH VALUE #( ( %tky = rentop-%tky RentalOperationStatus = rentop-RentalOperationStatus ) ).

    ENDLOOP.
  ENDMETHOD.

  METHOD determineVidStatus.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      BY \_Videogame
      FIELDS ( RentalStatus )
      WITH CORRESPONDING #( keys )
      RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      vidgame-RentalStatus = 'B'.
      MODIFY ENTITY IN LOCAL MODE zgr5_i_vidgame
          UPDATE FIELDS ( RentalStatus )
          WITH VALUE #( ( %tky = vidgame-%tky RentalStatus = vidgame-RentalStatus ) ).


    ENDLOOP.

  ENDMETHOD.

  METHOD validateUUID.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
          FIELDS ( CustomerUuid )
          WITH CORRESPONDING #( keys )
          RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      IF rentop-CustomerUuid = '00000000000000000000000000000000'.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_uuid
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  "Checks if EndDate is null
  METHOD validateEndDateNull.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
          FIELDS ( RentalReturnDate )
          WITH CORRESPONDING #( keys )
          RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      IF rentop-RentalReturnDate IS INITIAL.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_rent_end
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  "Startdate automatically to today
  METHOD determineRentalStartDate.
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
      FIELDS ( RentalId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).

    LOOP AT rentops INTO DATA(rentop).
      rentop-RentalStartDate = sy-datlo.
      MODIFY ENTITY IN LOCAL MODE zgr5_i_rentop
          UPDATE FIELDS ( RentalStartDate )
          WITH VALUE #( ( %tky = rentop-%tky RentalStartDate = rentop-RentalStartDate ) ).


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZGR5_I_VIDGAME DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zgr5_i_vidgame RESULT result.
    METHODS determinevidgameid FOR DETERMINE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~determinevidgameid.
    METHODS validategametitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~validategametitle.
    METHODS validategamegenre FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~validategamegenre.
    METHODS validatereleaseyear FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~validatereleaseyear.
    METHODS validatesystemtitle FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~validatesystemtitle.
    METHODS validaterentalstatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR zgr5_i_vidgame~validaterentalstatus.



ENDCLASS.

CLASS lhc_ZGR5_I_VIDGAME IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD determineVidgameId.
    READ ENTITY IN LOCAL MODE ZGR5_I_Vidgame
      FIELDS ( VidgameId )
      WITH CORRESPONDING #( keys )
      RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).

      SELECT SINGLE FROM zgr5_vgr_vidgame
          FIELDS MAX( Vidgame_id ) AS max_videogame_id
          INTO @DATA(max_videogame_id).

      vidgame-VidgameId = max_videogame_id  + 1.

      MODIFY ENTITY IN LOCAL MODE ZGR5_I_Vidgame
          UPDATE FIELDS ( VidgameId )
          WITH VALUE #( ( %tky = vidgame-%tky VidgameId = vidgame-VidgameId ) ).

    ENDLOOP.
  ENDMETHOD.


  METHOD validateGameTitle.
    READ ENTITY IN LOCAL MODE zgr5_i_vidgame
          FIELDS ( VideogameTitle )
          WITH CORRESPONDING #( keys )
          RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      IF vidgame-VideogameTitle IS INITIAL.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_game_title
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateGameGenre.
    READ ENTITY IN LOCAL MODE zgr5_i_vidgame
          FIELDS ( VideogameGenre )
          WITH CORRESPONDING #( keys )
          RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      IF vidgame-VideogameGenre IS INITIAL.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_game_genre
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateReleaseYear.
    READ ENTITY IN LOCAL MODE zgr5_i_vidgame
          FIELDS ( VideogameReleaseYear )
          WITH CORRESPONDING #( keys )
          RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      IF vidgame-VideogameReleaseYear IS INITIAL OR vidgame-VideogameReleaseYear CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß' OR vidgame-VideogameReleaseYear < 1939.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_rel_year
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateSystemTitle.
    READ ENTITY IN LOCAL MODE zgr5_i_vidgame
          FIELDS ( SystemTitle )
          WITH CORRESPONDING #( keys )
          RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      IF vidgame-SystemTitle IS INITIAL.
        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_sys_title
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.


  "Check by creating a new vidgame if it is null
  METHOD validateRentalStatus.
    READ ENTITY IN LOCAL MODE zgr5_i_vidgame
          FIELDS ( RentalStatus )
          WITH CORRESPONDING #( keys )
          RESULT DATA(vidgames).

    LOOP AT vidgames INTO DATA(vidgame).
      IF vidgame-RentalStatus IS INITIAL.

        DATA(message) = NEW zcm_gr5_videogame(
                        severity = if_abap_behv_message=>severity-error
                        textid   = zcm_gr5_videogame=>invalid_or_missing_rent_status
                         ).
        APPEND message TO reported-%other.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.



ENDCLASS.
