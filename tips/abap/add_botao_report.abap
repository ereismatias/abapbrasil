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
* DATA                : 12/05/2016                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Adicionar botão na tela inicial de programa (report).              *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  12/05/2016  Evandro Matias  Cod. Inicial                      *
**********************************************************************

REPORT zwa_teste2.

TABLES: sscrfields.

DATA : bt_icone TYPE smp_dyntxt.

PARAMETERS p_input TYPE c.

INITIALIZATION.

  SELECTION-SCREEN: FUNCTION KEY 1.
  bt_icone-icon_id  = '@15@'.
  bt_icone-text     = 'EXECUTAR2'.
  bt_icone-quickinfo = 'Executar 2'.
  sscrfields-functxt_01 = bt_icone.

AT SELECTION-SCREEN.

  IF sy-ucomm = 'FC01'. " Verifica ação do comando adicional.
    PERFORM faz_o_que_vc_quer.
  ENDIF.

START-OF-SELECTION.

  MESSAGE i888(sabapdocu) WITH 'Hello World'.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  faz_o_que_vc_quer
*&---------------------------------------------------------------------*
*       Form chamado de acordo com a ação do botão.
*----------------------------------------------------------------------*
FORM faz_o_que_vc_quer.

  MESSAGE i888(sabapdocu) WITH 'Hello World Novamente.'.

ENDFORM.                    "faz_o_que_vc_quer
