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
* DATA                : 18/05/2016                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Relatório de Mestre de Materias com campos ALV dinâmicos oriundos  *
* de Características Internas do Nº Classe                           *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  18/05/2016  Evandro Matias  Cod. Inicial                      *
**********************************************************************
*&---------------------------------------------------------------------*
*&  Include           ZMESTRE_MATERIAIS_CLS
*&---------------------------------------------------------------------*

*----------------------------------------------------------------------*
*       CLASS app IMPLEMENTATION
*----------------------------------------------------------------------*
*       Definição para a classe app
*----------------------------------------------------------------------*
CLASS app DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS main.

ENDCLASS.                    "app DEFINITION

*----------------------------------------------------------------------*
*       CLASS proj espec IMPLEMENTATION
*----------------------------------------------------------------------*
*       Implementação dos métodos da classe app
*----------------------------------------------------------------------*
CLASS app IMPLEMENTATION.

  METHOD main.
    PERFORM f_seleciona_dados.
    PERFORM f_call.
  ENDMETHOD.                    "main

ENDCLASS.                    "app IMPLEMENTATION.

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS:
          hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
                        IMPORTING e_row_id e_column_id es_row_no.

ENDCLASS.                    "lcl_event_handler DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD hotspot_click.

    CONSTANTS: c_mm03 TYPE tcode VALUE 'MM03'.

    CLEAR <fs_line>.
    READ TABLE <fs_dyn_table> INTO <fs_line> INDEX es_row_no-row_id.

    IF e_column_id-fieldname EQ 'MARAV_MATNR'.
      ASSIGN COMPONENT 'MARAV_MATNR' OF STRUCTURE <fs_line> TO <fs1>.
      IF NOT <fs1> IS INITIAL.
        SET PARAMETER ID: 'MAT' FIELD <fs1>.
        CALL TRANSACTION c_mm03 AND SKIP FIRST SCREEN.
      ENDIF.
      UNASSIGN <fs1>.
    ENDIF.

  ENDMETHOD .                    "handle_hotspot_click

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION