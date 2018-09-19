**********************************************************************
*                                                                    *
*            ********************************************            *
*            *     NÃO É CONFIDENCAL OU PROPRIETÁRIO    *            *
*            *        USE E ABUSE - COMPARTILHE         *            *
*            ********************************************            *
*                                                                    *
**********************************************************************
* PROGRAMADOR         : Evandro Reis Matias                          *
* SITE                : www.workingSAP.com                           *
* DATA                : 14/09/2018                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Jogo do Palpite                                                   *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  19/09/2018  Evandro Matias  Cod. Inicial                      *
**********************************************************************

DATA: v_int  TYPE i     ,
      v_zera TYPE c     ,
      v_cont TYPE i     ,
      v_palp TYPE string.

DATA: i_text TYPE string.

INITIALIZATION.

  PERFORM f_gera_n_aleatorio.
  CLEAR v_zera.

START-OF-SELECTION.

  CALL SCREEN 1001.

END-OF-SELECTION.


*&---------------------------------------------------------------------*
*&      Module  STATUS_1001  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_1001 OUTPUT.

  DATA: lt_table  TYPE TABLE OF char255,
        lst_table LIKE LINE OF lt_table.

  DATA: lo_container TYPE REF TO cl_gui_custom_container,
        lo_editor    TYPE REF TO cl_gui_textedit        .

  IF lo_editor IS INITIAL.

    CREATE OBJECT lo_container
      EXPORTING
        container_name = 'C_TEXTBOX'.

    CREATE OBJECT lo_editor
      EXPORTING
        parent                     = lo_container
        wordwrap_mode              = 2
        wordwrap_position          = 80
        wordwrap_to_linebreak_mode = 1.

    CALL METHOD lo_editor->set_toolbar_mode
      EXPORTING
        toolbar_mode = '0'.

    CALL METHOD lo_editor->set_readonly_mode
      EXPORTING
        readonly_mode = 1.

    CALL METHOD lo_editor->set_statusbar_mode
      EXPORTING
        statusbar_mode = '0'.

    PERFORM f_preenche_palpite.

    CALL METHOD lo_editor->set_text_as_r3table
      EXPORTING
        table = lt_table.

  ENDIF.

ENDMODULE.                 " STATUS_1001  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_1001  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_1001 INPUT.

  DATA: vl_first TYPE c.

  IF sy-ucomm EQ 'EXIT'.
    LEAVE TO SCREEN 0.
  ELSEIF sy-ucomm EQ 'SEND'.
    IF v_cont IS INITIAL.
      PERFORM f_preenche_palpite.
      vl_first = abap_on.
      CALL METHOD lo_editor->set_text_as_r3table
        EXPORTING
          table = lt_table.
      EXIT.
    ENDIF.

    IF i_text IS INITIAL.
      MESSAGE i398(00) WITH 'Não vale o ZERO e nem letras, ok?'.
    ELSEIF i_text CO '0123456789'.
      PERFORM f_preenche_palpite.
      CLEAR i_text.

      CALL METHOD lo_editor->set_text_as_r3table
        EXPORTING
          table = lt_table.

      IF v_zera = abap_on.
        CLEAR: v_zera, v_palp, v_cont.
        FREE: lt_table.
        PERFORM f_gera_n_aleatorio.
        PERFORM f_preenche_palpite.
      ENDIF.
    ELSE.
      MESSAGE i398(00) WITH 'Não vale o ZERO e nem letras, ok?'.
    ENDIF.
  ENDIF.

ENDMODULE.                 " USER_COMMAND_1001  INPUT

*&---------------------------------------------------------------------*
*&      Form  f_preenche_palpite
*&---------------------------------------------------------------------*
FORM f_preenche_palpite.

  DATA: vl_palpite TYPE i,
        vl_cont    TYPE i.

  IF lt_table[] IS INITIAL.
    lst_table = 'Digite um número e veja se consegue acertar o número aleátorio escolhido, de 1 até 100. Você tem 10 chances!'.
    APPEND lst_table TO lt_table.
  ELSE.
    FREE: lt_table[].
    vl_palpite = i_text.

    IF vl_palpite NE v_int.

      v_cont = v_cont + 1.
      vl_cont = 10 - v_cont.

      lst_table = 'Seus palpites foram:'.
      APPEND lst_table TO lt_table.

      IF v_cont = 1.
        v_palp = |{ v_palp } { vl_palpite }|.
      ELSE.
        v_palp = |{ v_palp } ; { vl_palpite }|.
      ENDIF.
      lst_table = v_palp.
      APPEND lst_table TO lt_table.

      lst_table = space.
      APPEND lst_table TO lt_table.

      IF vl_cont EQ 0.

        lst_table = 'Acabaram suas chances!'.
        APPEND lst_table TO lt_table.

        lst_table = space.
        APPEND lst_table TO lt_table.

        lst_table = |Eu tinha escolhido o nº: { v_int } |.
        APPEND lst_table TO lt_table.

        lst_table = space.
        APPEND lst_table TO lt_table.

        lst_table = 'Não desista. Vamos começar novamente? Eu já tenho um novo número.'.
        APPEND lst_table TO lt_table.

        v_zera = abap_on.

      ELSE.
        lst_table = |Você ainda tem { vl_cont } chances! |.
        APPEND lst_table TO lt_table.

        lst_table = space.
        APPEND lst_table TO lt_table.

        IF vl_palpite > v_int.
          lst_table = 'Seu palpite está para cima!'.
          APPEND lst_table TO lt_table.
        ELSE.
          lst_table = 'Seu palpite está para baixo!'.
          APPEND lst_table TO lt_table.
        ENDIF.

        lst_table = space.
        APPEND lst_table TO lt_table.

        lst_table = 'Digite um número e veja se consegue acertar o número aleátorio.'.
        APPEND lst_table TO lt_table.

      ENDIF.

    ELSE.

      lst_table = 'Parabéns, você acertou. Vamos começar novamente? Eu já tenho um novo número.'.
      APPEND lst_table TO lt_table.

      lst_table = |Palpite certeiro ein!!! { i_text } | .
      APPEND lst_table TO lt_table.

      v_zera = abap_on.

    ENDIF.
  ENDIF.

ENDFORM.                    "f_preenche_palpite

*&---------------------------------------------------------------------*
*&      Form  f_gera_n_aleatorio
*&---------------------------------------------------------------------*
FORM f_gera_n_aleatorio.

  CALL FUNCTION 'QF05_RANDOM_INTEGER'
    EXPORTING
      ran_int_max   = 100
      ran_int_min   = 1
    IMPORTING
      ran_int       = v_int
    EXCEPTIONS
      invalid_input = 1
      OTHERS        = 2.

ENDFORM.                    "f_gera_n_aleatorio
