AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_pasta.

  CALL FUNCTION '/SAPDMC/LSM_F4_SERVER_FILE'
    EXPORTING
      directory        = ' '
      filemask         = ' '
    IMPORTING
      serverfile       = p_pasta
    EXCEPTIONS
      canceled_by_user = 1
      OTHERS           = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ELSE.
    CONCATENATE p_pasta '/' INTO p_pasta.
  ENDIF.
