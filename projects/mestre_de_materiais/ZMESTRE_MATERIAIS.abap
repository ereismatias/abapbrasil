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

REPORT zmestre_materiais.

INCLUDE: zmestre_materiais_top,
         zmestre_materiais_scr,
         zmestre_materiais_cls,
         zmestre_materiais_f01.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_layout.

  gs_variant-report = sy-repid.

  CALL FUNCTION 'REUSE_ALV_VARIANT_F4'
    EXPORTING
      is_variant = gs_variant
      i_save     = 'A'
    IMPORTING
      es_variant = gs_variant
    EXCEPTIONS
      not_found  = 2.
  IF sy-subrc = 0.
    p_layout = gs_variant-variant.
  ENDIF.

START-OF-SELECTION.

  app=>main( ). "Chamada do Programa

END-OF-SELECTION.
