**********************************************************************
*                                                                    *
*            ********************************************            *
*            *                    AGFE                  *            *
*            ********************************************            *
*            *        CONFIDENCAL E PROPRIETÁRIO        *            *
*            *       TODOS OS DIREITOS RESERVADOS       *            *
*            ********************************************            *
*                                                                    *
**********************************************************************
* DATA                : 21/01/2016                                   *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* VER  DATA        AUTOR          DESCRIÇÃO                          *
* 0.1  21/01/2016                 CÓDIGO INICIAL                     *
**********************************************************************

REPORT zagfe.

TYPES: BEGIN OF ty_assets,
         x TYPE xstring,
       END OF ty_assets,

       BEGIN OF ty_achievements,
         ach TYPE string,
       END OF ty_achievements.

DATA it_ach TYPE TABLE OF ty_achievements.
DATA wa_ach TYPE ty_achievements.

DATA: zdindin LIKE sy-tabix, " Cash Atual
      zcash   LIKE sy-tabix, " Cash Total
      zhini   LIKE sy-uzeit, " Início do Game
      zhgam   LIKE sy-uzeit,
      zline   LIKE sy-tabix VALUE 1,
      zltim   LIKE sy-tabix VALUE 1,
      zlines  LIKE sy-tabix,
      zfunc   LIKE sy-tabix,
      zetot   LIKE sy-tabix,
      zetim   LIKE sy-tabix,
      zespc   LIKE sy-tabix,
      zgere   LIKE sy-tabix,
      zcome   LIKE sy-tabix,
      zabap   LIKE sy-tabix.

DATA: zaline TYPE c,
      zaclic TYPE c,
      zaabap TYPE c,
      zafunc TYPE c.

" Custo dos Recursos
DATA: zcus_abap TYPE i VALUE 25,
      zcus_func TYPE i VALUE 35,
      zcus_gere TYPE i VALUE 55,
      zcus_come TYPE i VALUE 99.

DATA : fnam(30), fval(50).


*----------------------------------------------------------------------*
*       CLASS app IMPLEMENTATION
*----------------------------------------------------------------------*
*       Definição para a classe agfe
*----------------------------------------------------------------------*
CLASS agfe DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS main.

ENDCLASS.                    "app DEFINITION

*----------------------------------------------------------------------*
*       CLASS diefce IMPLEMENTATION
*----------------------------------------------------------------------*
*       Implementação dos métodos da classe agfe
*----------------------------------------------------------------------*
CLASS agfe IMPLEMENTATION.
  METHOD main.

    GET TIME.
    zhini = sy-uzeit.
    PERFORM f_tela.

    CALL FUNCTION 'ZAGFE_TIMER'
      STARTING NEW TASK 'IF'
      PERFORMING start_refresh ON END OF TASK.



  ENDMETHOD.                    "main
ENDCLASS.                    "agfe IMPLEMENTATION

AT LINE-SELECTION.
  PERFORM f_comando.

AT USER-COMMAND.
  IF sy-ucomm = 'REFR'.

    GET TIME.
    PERFORM f_calcula.
    PERFORM f_achievements.
    PERFORM f_tela.

    CALL FUNCTION 'ZAGFE_TIMER'
      STARTING NEW TASK 'IF'
      PERFORMING start_refresh ON END OF TASK.

  ENDIF.



START-OF-SELECTION.

  agfe=>main( ). "Chamada do Programa

END-OF-SELECTION.

*----------------------------------------------------------------
* Program Subroutines
*----------------------------------------------------------------
FORM start_refresh USING taskname.
  SET USER-COMMAND 'REFR'.

ENDFORM.                    "START_REFRESH

*&---------------------------------------------------------------------*
*&      Form  f_tela
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_tela.
  sy-lsind = sy-lsind - 1.
  WRITE: / sy-uline(42).
  WRITE: / sy-vline, 'SAP  Clicker', sy-vline, 'Tempo de Game:', zhgam, sy-vline.
  WRITE: / sy-uline(42).
  WRITE: / sy-vline, 'Cash US$', zdindin, 42 sy-vline.
  WRITE: / sy-uline(42).
  "WRITE: /.
  IF zgere < 5.
    IF zfunc < 5.
      IF zabap < 5.
        WRITE: / sy-uline(20).
        WRITE: / sy-vline, 'Linhas de Código', sy-vline.
        WRITE: / sy-uline(25).
        WRITE: / sy-vline, 'Performance:' , 15 zline, 25 sy-vline.
        WRITE: / sy-vline, 'Tempo.:' , 15 zltim, 25 sy-vline.
        WRITE: / sy-vline, 'Total: ', 15 zlines, 25 sy-vline.
        WRITE: / sy-uline(25).
      ELSE.
        WRITE: / sy-uline(20), 30 sy-uline(21).
        WRITE: / sy-vline, 'Linhas de Código', sy-vline, 30 sy-vline, 'Especificação F.', 50 sy-vline.
        WRITE: / sy-uline(25), 30 sy-uline(26).
        WRITE: / sy-vline, 'Performance:' , 15 zline, 25 sy-vline, 30 sy-vline, 'Performance:', 45 zespc, 55 sy-vline.
        WRITE: / sy-vline, 'Tempo.:' , 15 zltim, 25 sy-vline, 30 sy-vline, 'Tempo:', 45 zetim, 55 sy-vline.
        WRITE: / sy-vline, 'Total: ', 15 zlines, 25 sy-vline, 30 sy-vline, 'Total:', 45 zetot, 55 sy-vline.
        WRITE: / sy-uline(25), 30 sy-uline(26).
      ENDIF.
    ELSE.
    ENDIF.
  ELSE.
  ENDIF.

  WRITE: / sy-uline(42).
  WRITE: / sy-vline, 'Recursos', 19 sy-vline, 20 'Taxa', 31 sy-vline, 32 'Total', 42 sy-vline.
  WRITE: / sy-uline(42).
  WRITE: / sy-vline, 'ABAP' , 19 sy-vline, zcus_abap, 31 sy-vline, 32 zabap,  42 sy-vline.
  IF zabap > 4.
    WRITE: / sy-vline, 'Funcional', 19 sy-vline, zcus_func, 31 sy-vline, 32 zfunc, 42 sy-vline.
  ENDIF.
  IF zfunc > 4.
    WRITE: / sy-vline, 'Gerente', 19 sy-vline, zcus_gere, 31 sy-vline, 32 zgere, 42 sy-vline.
  ENDIF.
  IF zgere > 4.
    WRITE: / sy-vline, 'Comercial', 19 sy-vline, zcus_come, 31 sy-vline, 32 zcome, 42  sy-vline.
  ENDIF.
  WRITE: / sy-uline(42).


  WRITE: / sy-uline(16).
  WRITE: / sy-vline, 'Achievements', 16 sy-vline.
  WRITE: / sy-uline(50).
  IF it_ach[] IS INITIAL.
    WRITE: / sy-vline, 'Putz, você ainda não tem nenhum Achievement.', 50 sy-vline.
  ELSE.
    LOOP AT it_ach INTO wa_ach.
      WRITE: / sy-vline, wa_ach-ach, 50 sy-vline.
    ENDLOOP.
  ENDIF.
  WRITE: / sy-uline(50).

ENDFORM.                    "f_tela

*&---------------------------------------------------------------------*
*&      Form  f_comando
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_comando.
  GET CURSOR FIELD fnam VALUE fval.
  CONDENSE fval.
  IF fval = 'Linhas de Código'.
    zlines = zlines + ( zline * 1 ).
    zdindin = zdindin + ( zline * 1 ).
  ENDIF.

  IF fval = 'Especificação F.'.
    zlines = zlines + ( zline * 1 ).
    zdindin = zdindin + ( zline * 1 ).
  ENDIF.

  IF fval = 'ABAP'.
    IF zdindin >= zcus_abap.
      zabap = zabap + 1.
      zdindin = zdindin - zcus_abap.
      zcus_abap = zcus_abap * '1.30'.
    ENDIF.

    IF zabap = 5.
      wa_ach-ach = 'Recurso Funcional - Desbloqueado'.
      APPEND wa_ach TO it_ach.
      CLEAR wa_ach.
      zafunc = abap_on.
    ENDIF.
  ENDIF.


  IF fval = 'Funcional'.
    IF zdindin >= zcus_func.
      zfunc = zfunc + 1.
      zdindin = zdindin - zcus_func.
      zcus_func = zcus_func * '1.30'.
    ENDIF.

    IF zfunc = 5.
      wa_ach-ach = 'Você desbloqueou o recurso Gerente.'.
      APPEND wa_ach TO it_ach.
      CLEAR wa_ach.
      zafunc = abap_on.
    ENDIF.
  ENDIF.

  IF fval = 'Carregar'.

  ENDIF.

  IF fval = 'Salvar'.

  ENDIF.

ENDFORM.                    "f_comando

*&---------------------------------------------------------------------*
*&      Form  f_calcula
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_calcula.
  " Tempo de Jogo.
  zhgam = sy-uzeit - zhini.
  " Cálcula trabalho dos ABAPS.
  zlines = zlines + ( zline * zabap ).
  zdindin = zdindin + ( zline * zabap ).
ENDFORM.                    "f_calcula

*&---------------------------------------------------------------------*
*&      Form  f_Achievements
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_achievements.

  IF zaclic IS INITIAL.
    IF zlines > 0.
      wa_ach-ach = 'Parabéns, você fez o seu primeiro click.'.
      APPEND wa_ach TO it_ach.
      CLEAR wa_ach.
      zaclic = abap_on.
    ENDIF.
  ENDIF.

  IF zaabap IS INITIAL.
    IF zabap > 0.
      wa_ach-ach = 'Parabéns, você alocou seu primeiro ABAP.'.
      APPEND wa_ach TO it_ach.
      CLEAR wa_ach.
      zaabap = abap_on.
    ENDIF.
  ENDIF.

  IF zafunc IS INITIAL.
    IF zfunc > 0.
      wa_ach-ach = 'Parabéns, você alocou seu primeiro Funcional.'.
      APPEND wa_ach TO it_ach.
      CLEAR wa_ach.
      zafunc = abap_on.
    ENDIF.
  ENDIF.

ENDFORM.                    "f_Achievements

*&---------------------------------------------------------------------*
*&      Form  f_savegame
*&---------------------------------------------------------------------*
FORM f_savegame.

ENDFORM.                    "f_savegame

*&---------------------------------------------------------------------*
*&      Form  f_loadgame
*&---------------------------------------------------------------------*
FORM f_loadgame.

ENDFORM.                    "f_loadgame
