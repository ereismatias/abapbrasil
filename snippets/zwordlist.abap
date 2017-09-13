" Declarações
TYPES: BEGIN OF ty_wordlist,
         id          TYPE i,
         palavra(25) TYPE c,
       END OF ty_wordlist  .

DATA: it_wordlist TYPE TABLE OF ty_wordlist,
      it_file     LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE.
DATA: wa_wordlist TYPE ty_wordlist.

DATA: vl_random  TYPE qf00-ran_int,
      vl_string  TYPE string      ,
      vl_palavra TYPE string      .

" Tela
PARAMETERS: p_file LIKE rlgrap-filename,
            p_comb TYPE i              .

" F4 Help

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL FUNCTION 'F4_FILENAME'
    EXPORTING
      field_name = 'FILE_LOC'
    IMPORTING
      file_name  = p_file.

  " Início

START-OF-SELECTION.

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_file
      i_begin_col             = '1'
      i_begin_row             = '1'
      i_end_col               = '1'
      i_end_row               = '2047'
    TABLES
      intern                  = it_file
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.
  IF sy-subrc NE space.
    MESSAGE i398(00) WITH 'Erro, verifique a planilha'.
    LEAVE LIST-PROCESSING.
  ENDIF.

  LOOP AT it_file.
    CLEAR wa_wordlist.
    wa_wordlist-id = it_file-row.
    wa_wordlist-palavra = it_file-value.
    APPEND wa_wordlist TO it_wordlist.
  ENDLOOP.

  DO p_comb TIMES .
    CLEAR vl_string.
    DO 15 TIMES.
      CLEAR vl_random.
      CALL FUNCTION 'QF05_RANDOM_INTEGER'
        EXPORTING
          ran_int_max   = 2047
          ran_int_min   = 1
        IMPORTING
          ran_int       = vl_random
        EXCEPTIONS
          invalid_input = 1
          OTHERS        = 2.

      CLEAR: wa_wordlist, vl_palavra.
      READ TABLE it_wordlist INTO wa_wordlist INDEX vl_random.
      vl_palavra = wa_wordlist-palavra.
      CONCATENATE vl_string vl_palavra INTO vl_string SEPARATED BY space.
    ENDDO.
    WRITE: / vl_string.
  ENDDO.
