CLASS zcm_gr5_videogame DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "Interfaces
    INTERFACES if_abap_behv_message.
    INTERFACES if_t100_message.
    INTERFACES if_t100_dyn_msg.

    TYPES: ty_user TYPE c LENGTH 12.

    "Message Constants
    CONSTANTS:
      BEGIN OF button_pressed,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '001',
        attr1 TYPE scx_attrname VALUE 'USER',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF BUTTON_PRESSED.

    CONSTANTS:
      BEGIN OF rentop_already_cancelled,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '002',
        attr1 TYPE scx_attrname VALUE 'RENTOP_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF rentop_already_cancelled.

    CONSTANTS:
      BEGIN OF rentop_cancelled_successfully,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '003',
        attr1 TYPE scx_attrname VALUE 'RENTOP_ID',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF rentop_cancelled_successfully.

    CONSTANTS:
      BEGIN OF invalid_end_date,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '004',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_end_date.

     CONSTANTS:
      BEGIN OF invalid_rental_fee,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '005',
        attr1 TYPE scx_attrname VALUE 'RENTAL_FEE',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_rental_fee.

      CONSTANTS:
      BEGIN OF videogame_already_returned,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '006',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF videogame_already_returned.

    CONSTANTS:
      BEGIN OF invalid_rental_rating,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '007',
        attr1 TYPE scx_attrname VALUE 'RENTAL_RATING',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_rental_rating.

     CONSTANTS:
      BEGIN OF videogame_not_available,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '008',
        attr1 TYPE scx_attrname VALUE 'RENTAL_AVAILABILITY',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF videogame_not_available.

     CONSTANTS:
      BEGIN OF invalid_or_missing_uuid,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '009',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_uuid.

     CONSTANTS:
      BEGIN OF invalid_or_missing_game_title,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '010',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_game_title.

      CONSTANTS:
      BEGIN OF invalid_or_missing_game_genre,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '011',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_game_genre.

      CONSTANTS:
      BEGIN OF invalid_or_missing_rel_year,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '012',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_rel_year.

      CONSTANTS:
      BEGIN OF invalid_or_missing_sys_title,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '013',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_sys_title.

      CONSTANTS:
      BEGIN OF invalid_or_missing_rent_status,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '014',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_rent_status.

      CONSTANTS:
      BEGIN OF invalid_or_missing_rent_start,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '015',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_rent_start.

      CONSTANTS:
      BEGIN OF invalid_or_missing_rent_end,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '016',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF invalid_or_missing_rent_end.

      CONSTANTS:
      BEGIN OF vidgame_is_borrowed,
        msgid TYPE symsgid VALUE 'ZGR5_VIDEOGAME',
        msgno TYPE symsgno VALUE '017',
        attr1 TYPE scx_attrname VALUE '',
        attr2 TYPE scx_attrname VALUE '',
        attr3 TYPE scx_attrname VALUE '',
        attr4 TYPE scx_attrname VALUE '',
      END OF vidgame_is_borrowed.

    "Define Attributs
    DATA user TYPE ty_user.
    DATA rentop_id TYPE zgr5_vgr_rental_id.
    DATA rental_fee TYPE zgr5_vgr_rental_fee.
    DATA rental_rating TYPE zgr5_vgr_rating.
    DATA rental_availability TYPE zgr5_vgr_rental_status.


    "Constructor
    METHODS constructor
      IMPORTING
        severity    TYPE if_abap_behv_message=>t_severity DEFAULT if_abap_behv_message=>severity-error
        textid      LIKE if_t100_message=>t100key DEFAULT if_t100_message=>default_textid
        previous    LIKE previous OPTIONAL
        user TYPE ty_user OPTIONAL
        rentop_id TYPE zgr5_vgr_rental_id OPTIONAL
        rental_fee TYPE zgr5_vgr_rental_fee OPTIONAL
        rental_rating TYPE zgr5_vgr_rating OPTIONAL
        rental_availability TYPE zgr5_vgr_rental_status Optional.

     " Oben stehendes wäre in Java folgendes:
     " public Videogame(Severity severity, String textId, Object previous, User user) {
     " super(previous)
     " this.severity = severity;
     " this.textId = textId;
     " this.user = user;
     "}

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.



CLASS ZCM_GR5_VIDEOGAME IMPLEMENTATION.


  METHOD constructor ##ADT_SUPPRESS_GENERATION.
    super->constructor( previous = previous ).

    if_t100_message~t100key = textid.
    me->if_abap_behv_message~m_severity = severity.


    "Exceptions and error messages"
    me->user = user.
    me->rentop_id = rentop_id.
    me->rental_fee = rental_fee.
    me->rental_rating = rental_rating.
    me->rental_availability = rental_availability.
  ENDMETHOD.
ENDCLASS.
