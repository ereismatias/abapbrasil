**********************************************************************
*                                                                    *
*            ********************************************            *
*            *     NÃO É CONFIDENCAL OU PROPRIETÁRIO    *            *
*            *        USE E ABUSE - COMPARTILHE         *            *
*            ********************************************            *
*                                                                    *
**********************************************************************
* PROGRAMADOR         : Evandro Reis Matias                          *
* SITE                : www.evandro.dev                              *
* DATA                : 10/12/2020                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Alterar variante de um programa quando não tem transação ou o      *
* usuário não pode ter acesso à transação VARCH (cópia)              *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  10/12/2020  Evandro Matias  Cod. Inicial                      *
**********************************************************************
REPORT z_change_variant MESSAGE-ID db.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE text-001.
PARAMETERS: p_repo LIKE rsvar-report DEFAULT 'RVKRED07', "-> Altere para o programa desejado.
            p_vari LIKE rsvar-variant.
SELECTION-SCREEN END OF BLOCK b1.

*******************************************
*  AT SELECTION-SCREEN ON p_repo.
*******************************************
AT SELECTION-SCREEN ON p_repo.
  IF p_repo IS INITIAL.
    MESSAGE e607.
  ENDIF.

AT SELECTION-SCREEN ON p_vari.
  IF p_vari IS INITIAL.
    MESSAGE e611.      "Entrar um nome de variante
  ENDIF.

********************************************
*  AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_repo
********************************************

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_repo.

  CALL FUNCTION 'REPOSITORY_INFO_SYSTEM_F4'
    EXPORTING
      object_type          = 'PROG'
      object_name          = p_repo
      suppress_selection   = 'X'
    IMPORTING
      object_name_selected = p_repo
    EXCEPTIONS
      cancel               = 01
      OTHERS               = 02.
  CASE sy-subrc.
    WHEN 01.
      EXIT.
    WHEN 02.
      MESSAGE s093 WITH text-002.
      EXIT.
  ENDCASE.

********************************************
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vari.

  CALL FUNCTION 'RS_VARIANT_CATALOG'
    EXPORTING
      report              = p_repo
    IMPORTING
      sel_variant         = p_vari
*     SEL_VARIANT_TEXT    =
    EXCEPTIONS
      no_report           = 1
      report_not_existent = 2
      report_not_supplied = 3
      no_variants         = 4
      no_variant_selected = 5
      OTHERS              = 6.
  CASE sy-subrc.
    WHEN 1.
      MESSAGE s287. "Programa não tem seleções (tipo S)
    WHEN 2.
      MESSAGE s628 WITH p_repo. "O report não está na biblioteca
    WHEN 3.
      MESSAGE s607.   " Indicar um nome de programa
    WHEN 4.
      MESSAGE s613 WITH p_repo.  "Não foi criada nenhuma variante para o report.
    WHEN 5.
    WHEN 6.
      MESSAGE s093 WITH text-002.
  ENDCASE.

AT SELECTION-SCREEN OUTPUT.

  LOOP AT SCREEN.
    IF screen-name = 'P_REPO'.
      screen-input = '0'.
    ENDIF.
    MODIFY SCREEN.
  ENDLOOP.

************************************************
START-OF-SELECTION.
************************************************

  CALL FUNCTION 'RS_VARIANT_CHANGE'
    EXPORTING
      report               = p_repo
      variant              = p_vari
      value_or_attr        = 'V'
    EXCEPTIONS
      not_authorized       = 1
      not_executed         = 2
      no_report            = 3
      report_not_existent  = 4
      report_not_supplied  = 5
      variant_locked       = 6
      variant_not_existent = 7
      variant_protected    = 8
      OTHERS               = 9.
  CASE sy-subrc.
    WHEN 1.
      MESSAGE s278 WITH p_vari."Sem autorização para modificar a variante
    WHEN 2.
    WHEN 3.
      MESSAGE s287. "Programa não tem seleções (tipo S)
    WHEN 4.
      MESSAGE s628 WITH p_repo. "O report não está na biblioteca
    WHEN 5.
      MESSAGE s607.   " Indicar um nome de programa
    WHEN 6.
      MESSAGE s622.      "Diretório de variantes atualmente bloqueado..
    WHEN 7.
      MESSAGE s612 WITH p_vari p_repo.
      "Variante X para report X não existe
    WHEN 8.
      MESSAGE s647 WITH p_vari.           " Variante protegida
    WHEN 9.
      MESSAGE s093 WITH text-002.
  ENDCASE.
