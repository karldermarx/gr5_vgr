CLASS zgr5_vgr_cl_generator DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zgr5_vgr_cl_generator IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.

    "Strukturen deklarieren
    DATA videogame TYPE zgr5_vgr_vidgame.
    DATA rental TYPE zgr5_vgr_rentop.
    DATA customer TYPE zgr5_vgr_cust.

    "Interne Tabellen deklarieren
    DATA videogames TYPE TABLE OF zgr5_vgr_vidgame.
    DATA rentals TYPE TABLE OF zgr5_vgr_rentop.
    DATA customers TYPE TABLE OF zgr5_vgr_cust.

    "Alle Daten der Datenbanktabellen löschen
    DELETE FROM zgr5_vgr_vidgame.
    out->write( |deleteted videogames: {  sy-dbcnt }| ).
    DELETE FROM zgr5_vgr_rentop.
    out->write( |deleteted rental operations: {  sy-dbcnt }| ).
    DELETE FROM zgr5_vgr_cust.
    out->write( |deleteted customers: {  sy-dbcnt }| ).

    "Interne Tabellen befüllen
    "Struktur befüllen (1)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '1'.
    videogame-videogame_title = 'Grand Theft Auto V'.
    videogame-system_title = 'PS4'.
    videogame-videogame_genre = 'Action-Adventure'.
    videogame-videogame_release_year = '2013'.
*    videogame-average_rating = '9.0'.
    videogame-rental_status = 'A'.
    APPEND videogame TO videogames.


    "Struktur befüllen (2)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '2'.
    videogame-videogame_title = 'The Witcher 3: Wild Hunt'.
    videogame-system_title = 'PC'.
    videogame-videogame_genre = 'Action-RPG'.
    videogame-videogame_release_year = '2015'.
*   videogame-average_rating = '9.3'.
    videogame-rental_status = 'A'.
    APPEND videogame TO videogames.


    "Struktur befüllen (3)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '3'.
    videogame-videogame_title = 'Cyberpunk 2077'.
    videogame-system_title = 'XBOX ONE'.
    videogame-videogame_genre = 'Action-Adventure'.
    videogame-videogame_release_year = '2020'.
*    videogame-average_rating = '7.3'.
    videogame-rental_status = 'B'.
    APPEND videogame TO videogames.

    "Struktur 3-1-1
    "Struktur 3 als Customer
    customer-client = sy-mandt.
    customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    customer-customer_id = '0000002'.
    customer-customer_firstname = 'Svenjamin'.
    customer-customer_lastname = 'Keusch'.
    customer-customer_accession_date = '20230118'.
    APPEND customer TO customers.

    "Struktur 3-2-1
    "Struktur 3 als Rental Operation
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '3'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230128'.
    rental-rental_return_date = '20230228'.
    rental-rental_operation_status = 'RETURNED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 5.
    APPEND rental TO rentals.


    "Struktur 3-1-2
    customer-client = sy-mandt.
    customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    customer-customer_id = '0000005'.
    customer-customer_firstname = 'Spike'.
    customer-customer_lastname = 'Rauschhart'.
    customer-customer_accession_date = '20230218'.
    APPEND customer TO customers.

    "Struktur 3-2-2
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '6'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230228'.
    rental-rental_return_date = '20230311'.
    rental-rental_operation_status = 'BORROWED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 0.
    APPEND rental TO rentals.


    "Struktur befüllen (4)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '4'.
    videogame-videogame_title = 'Minecraft'.
    videogame-system_title = 'NSW'.
    videogame-videogame_genre = 'Sandbox'.
    videogame-videogame_release_year = '2011'.
*    videogame-average_rating = '8.0'.
    videogame-rental_status = 'N'.
    APPEND videogame TO videogames.


    "Struktur befüllen (5)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '5'.
    videogame-videogame_title = 'The Legend of Zelda: Breath of the Wild'.
    videogame-system_title = 'NSW'.
    videogame-videogame_genre = 'Action-Adventure'.
    videogame-videogame_release_year = '2017'.
*    videogame-average_rating = '7.5'.
    videogame-rental_status = 'B'.
    APPEND videogame TO videogames.

    "Struktur 5-1
    "Struktur 5 als Customer
    customer-client = sy-mandt.
    customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    customer-customer_id = '0000003'.
    customer-customer_firstname = 'Schmuis'.
    customer-customer_lastname = 'Fellhahn'.
    customer-customer_accession_date = '20230123'.
    APPEND customer TO customers.

    "Struktur 5-2
    "Struktur 5 als Rental Operation
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '5'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230222'.
    rental-rental_return_date = '20230322'.
    rental-rental_operation_status = 'BORROWED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 0.
    APPEND rental TO rentals.


    "Struktur befüllen (6)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '6'.
    videogame-videogame_title = 'Red Dead Redemption 2'.
    videogame-system_title = 'PS4'.
    videogame-videogame_genre = 'Action-Adventure'.
    videogame-videogame_release_year = '2018'.
*    videogame-average_rating = '9.0'.
    videogame-rental_status = 'A'.
    APPEND videogame TO videogames.

    "Struktur 6-1
    "Struktur 6 als Customer
    customer-client = sy-mandt.
    customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    customer-customer_id = '0000004'.
    customer-customer_firstname = 'Sichael'.
    customer-customer_lastname = 'Mächer'.
    customer-customer_accession_date = '20230130'.
    APPEND customer TO customers.

    "Struktur 6-2
    "Struktur 6 als Rental Operation
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '1'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230130'.
    rental-rental_return_date = '20230228'.
    rental-rental_operation_status = 'RETURNED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 8.
    APPEND rental TO rentals.

    "Struktur 6-1-2
    "Struktur 6 als Customer
    customer-client = sy-mandt.
    customer-customer_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    customer-customer_id = '0000001'.
    customer-customer_firstname = 'Lukas Konrad'.
    customer-customer_lastname = 'Wegener'.
    customer-customer_accession_date = '20230105'.
    APPEND customer TO customers.

    "Struktur 6-2-2
    "Struktur 6 als Rental Operation
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '4'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230105'.
    rental-rental_return_date = '20230128'.
    rental-rental_operation_status = 'RETURNED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 9.
    APPEND rental TO rentals.


    "Struktur befüllen (7)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '7'.
    videogame-videogame_title = 'Super Mario Odyssey'.
    videogame-system_title = 'NSW'.
    videogame-videogame_genre = 'Platformer'.
    videogame-videogame_release_year = '2017'.
*    videogame-average_rating = '6.0'.
    videogame-rental_status = 'A'.
    APPEND videogame TO videogames.


    "Struktur befüllen (8)
    videogame-client = sy-mandt.
    videogame-videogame_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    videogame-vidgame_id = '8'.
    videogame-videogame_title = 'The Last of Us Part II'.
    videogame-system_title = 'PS4'.
    videogame-videogame_genre = 'Action-Adventure'.
    videogame-videogame_release_year = '2020'.
*    videogame-average_rating = '9.5'.
    videogame-rental_status = 'B'.
    APPEND videogame TO videogames.

    "Struktur 8-2
    "Struktur 8 als Rental Operation
    rental-client = sy-mandt.
    rental-rental_operation_uuid = cl_system_uuid=>create_uuid_x16_static( ).
    rental-rental_id = '2'.
    rental-videogame_uuid = videogame-videogame_uuid.
    rental-customer_uuid = customer-customer_uuid.
    rental-rental_start_date = '20230118'.
    rental-rental_return_date = '20230218'.
    rental-rental_operation_status = 'BORROWED'.
    rental-rental_fee = rental-rental_return_date - rental-rental_start_date + 1.
    rental-cuky_field = 'EUR'.
    rental-rental_rating = 9.
    APPEND rental TO rentals.


    INSERT zgr5_vgr_vidgame FROM TABLE @videogames.
    out->write( |inserted videogames: {  sy-dbcnt }| ).
    INSERT zgr5_vgr_rentop FROM TABLE @rentals.
    out->write( |inserted rental operations: {  sy-dbcnt }| ).
    INSERT zgr5_vgr_cust FROM TABLE @customers.
    out->write( |inserted customers: {  sy-dbcnt }| ).

  ENDMETHOD.

ENDCLASS.
