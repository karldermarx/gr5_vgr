CLASS lhc_zgr5_i_rentop DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ZGR5_I_RENTOP RESULT result.

    METHODS cancel_rental_operation FOR MODIFY
      IMPORTING keys FOR ACTION ZGR5_I_RENTOP~cancel_rental_operation.
    METHODS validateEndDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~validateEndDate.
*    METHODS validateRentalFee FOR VALIDATE ON SAVE
*      IMPORTING keys FOR ZGR5_I_RENTOP~validateRentalFee.
    METHODS determineRentalId FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~determineRentalId.
    METHODS determineRentalStartDate FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~determineRentalStartDate.
      METHODS determineRentalFee FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~determineRentalFee.
    METHODS validateRating FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~validateRating.
    METHODS validateStatus FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~validateStatus.
    METHODS determineRentalOperationStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~determineRentalOperationStatus.
    METHODS determineVidStatus FOR DETERMINE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~determineVidStatus.
    METHODS validateUUID FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~validateUUID.
    METHODS validateEndDateNull FOR VALIDATE ON SAVE
      IMPORTING keys FOR ZGR5_I_RENTOP~validateEndDateNull.



ENDCLASS.

CLASS lhc_zgr5_i_rentop IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD cancel_rental_operation.
  "Read the data
  READ entity in local mode ZGR5_I_RENTOP
     BY \_Videogame
    fields ( RentalStatus )
    with CORRESPONDING #( keys )
    RESULT DATA(vidgames)

    fields ( RentalId RentalOperationStatus )
    with CORRESPONDING #( keys )
    RESULT DATA(rentops).

   "Sequential processing of the data - error case
   LOOP AT rentops into data(rentop).

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

    "Else Case
    rentop-RentalOperationStatus = 'RETURNED'.


    "Overwrite value
    MODIFY entity in local mode ZGR5_I_RENTOP
     update fields ( RentalOperationStatus )
     with value #( ( %tky = rentop-%tky RentalOperationStatus = rentop-RentalOperationStatus ) ).

     message = NEW zcm_gr5_videogame(
      severity = if_abap_behv_message=>severity-success
      textid   = zcm_gr5_videogame=>rentop_cancelled_successfully
      ).

     APPEND message TO reported-%other.

    "Set Videogame Status back to available when cancelling an operation
    DATA(videogame) = vidgames[ 1 ].

    MODIFY entity in local mode zgr5_i_vidgame
      update fields ( RentalStatus )
      with value #( ( %tky = videogame-%tky RentalStatus = 'A' ) ).

    ENDLOOP.

  ENDMETHOD.

"Checks if endDate is before startDate
  METHOD validateEndDate.
  "Read the data
  READ entity in local mode ZGR5_I_RENTOP
    fields ( RentalStartDate RentalReturnDate )
    with CORRESPONDING #( keys )
    RESULT DATA(rentops).
    "Sequential processing of the data
    loop at rentops into data(rentop).
        if rentop-RentalReturnDate < rentop-RentalStartDate.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_end_date ).
            APPEND message TO reported-%other.
        endif.
    endloop.
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
  read entity in local mode ZGR5_I_RENTOP
    fields ( RentalId )
    with CORRESPONDING #( keys )
    RESULT DATA(rentops).

    "Sequential processing of the data
    loop at rentops into DATA(rentop).

        select SINGLE from ZGR5_VGR_RENTOP
            fields max( rental_id  ) as max_rental_id
            INTO @DATA(max_rental_id).

        rentop-RentalId = max_rental_id + 1.

        MODIFY entity in LOCAL MODE ZGR5_I_RENTOP
            update fields ( RentalId )
            with value #( ( %tky = rentop-%tky RentalId = rentop-RentalId ) ).

    ENDLOOP.
  ENDMETHOD.

    METHOD determineRentalFee.
    "Read the data
    READ ENTITY IN LOCAL MODE ZGR5_I_RENTOP
      FIELDS ( RentalFee CukyField )
      WITH CORRESPONDING #( keys )
      RESULT DATA(rentops).

    "Sequential processing of the data
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
    "Read the data
    Read ENTITY IN LOCAL MODE ZGR5_I_RENTOP
        Fields ( RentalRating )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).

    "Sequential processing of the data
    LOOP AT rentops INTO DATA(rentop).
        if rentop-RentalRating < 0 or rentop-RentalRating > 10.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_rental_rating
                            rental_rating = rentop-RentalRating
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.

"Validate, if the Videogame is available while creating a new rental operation
  METHOD validateStatus.
    "Read the data
    READ ENTITY IN LOCAL MODE zgr5_i_rentop
        FIELDS ( RentalId )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).
    "Sequential processing of the data
    LOOP AT rentops INTO DATA(rentop).
      SELECT SINGLE rental_status  FROM zgr5_vgr_vidgame
       WHERE ( videogame_uuid = @rentop-VideogameUuid )
       INTO @DATA(rental_status).


        if rental_status = 'N' or rental_status = 'B'.
           DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>videogame_not_available
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.


  METHOD determineRentalOperationStatus.
  "Read data

  READ ENTITY IN LOCAL MODE zgr5_i_rentop
    FIELDS ( RentalOperationStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).

        LOOP AT rentops INTO DATA(rentop).
            rentop-RentalOperationStatus = 'BORROWED'.

        MODIFY ENTITY IN LOCAL MODE ZGR5_I_RENTOP
            UPDATE FIELDS ( RentalOperationStatus )
            WITH VALUE #( ( %tky = rentop-%tky RentalOperationStatus = rentop-RentalOperationStatus ) ).

        ENDLOOP.
  ENDMETHOD.

  METHOD determineVidStatus.
  "Read data
  READ ENTITY IN LOCAL MODE zgr5_i_rentop
    by \_Videogame
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
  "Read the data
  Read ENTITY IN LOCAL MODE ZGR5_I_RENTOP
        Fields ( CustomerUuid )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).

    "Sequential processing of the data
    LOOP AT rentops INTO DATA(rentop).
        if rentop-CustomerUuid = '00000000000000000000000000000000'.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_uuid
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
    ENDMETHOD.

"Checks if EndDate is null
  METHOD validateEndDateNull.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_rentop
        Fields ( RentalReturnDate )
        WITH CORRESPONDING #( keys )
        RESULT DATA(rentops).

    "Sequential processing of the data
    LOOP AT rentops INTO DATA(rentop).
        if rentop-RentalReturnDate IS INITIAL.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_rent_end
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.

"Startdate automatically to today
  METHOD determineRentalStartDate.
  "Read data
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
  "Read the data
  read entity in local mode ZGR5_I_Vidgame
    fields ( VidgameId )
    with CORRESPONDING #( keys )
    RESULT DATA(vidgames).

    "Sequential processing of the data
    loop at vidgames into DATA(vidgame).

        select SINGLE from ZGR5_VGR_VIDGAME
            fields max( Vidgame_id ) as max_videogame_id
            INTO @DATA(max_videogame_id).

        vidgame-VidgameId = max_videogame_id  + 1.

        MODIFY entity in LOCAL MODE ZGR5_I_Vidgame
            update fields ( VidgameId )
            with value #( ( %tky = vidgame-%tky VidgameId = vidgame-VidgameId ) ).

    endloop.
  ENDMETHOD.


  METHOD validateGameTitle.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_vidgame
        Fields ( VideogameTitle )
        WITH CORRESPONDING #( keys )
        RESULT DATA(vidgames).

    "Sequential processing of the data
    LOOP AT vidgames INTO DATA(vidgame).
        if vidgame-VideogameTitle IS INITIAL.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_game_title
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
    ENDMETHOD.

  METHOD validateGameGenre.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_vidgame
        Fields ( VideogameGenre )
        WITH CORRESPONDING #( keys )
        RESULT DATA(vidgames).

    "Sequential processing of the data
    LOOP AT vidgames INTO DATA(vidgame).
        if vidgame-VideogameGenre IS INITIAL.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_game_genre
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateReleaseYear.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_vidgame
        Fields ( VideogameReleaseYear )
        WITH CORRESPONDING #( keys )
        RESULT DATA(vidgames).

    "Sequential processing of the data
    LOOP AT vidgames INTO DATA(vidgame).
        if vidgame-VideogameReleaseYear IS INITIAL OR vidgame-VideogameReleaseYear CA 'ABCDEFGHIJKLMNOPQRSTUVWXYZÄÖÜß' OR vidgame-VideogameReleaseYear < 1939.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_rel_year
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.

  METHOD validateSystemTitle.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_vidgame
        Fields ( SystemTitle )
        WITH CORRESPONDING #( keys )
        RESULT DATA(vidgames).

    "Sequential processing of the data
    LOOP AT vidgames INTO DATA(vidgame).
        if vidgame-SystemTitle IS INITIAL.
            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_sys_title
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.
"Check by creating a new vidgame if it is null
  METHOD validateRentalStatus.
  "Read the data
  Read ENTITY IN LOCAL MODE zgr5_i_vidgame
        Fields ( RentalStatus )
        WITH CORRESPONDING #( keys )
        RESULT DATA(vidgames).

    "Sequential processing of the data
    LOOP AT vidgames INTO DATA(vidgame).
        if vidgame-RentalStatus IS INITIAL.

            DATA(message) = NEW zcm_gr5_videogame(
                            severity = if_abap_behv_message=>severity-error
                            textid   = zcm_gr5_videogame=>invalid_or_missing_rent_status
                             ).
            APPEND message TO reported-%other.
        endif.

    ENDLOOP.
  ENDMETHOD.



ENDCLASS.
