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
* DATA                : 13/05/2016                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Código para busca valores fixos de um determinado domínio.         *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  13/05/2016  Evandro Matias  Cod. Inicial                      *
**********************************************************************

REPORT zget_domain.

" Declarações da GETDOMAIN
DATA: wa_taba TYPE dd07v.
DATA: it_taba TYPE STANDARD TABLE OF dd07v,
      it_tabn TYPE STANDARD TABLE OF dd07v.

" Função para valores fixos de um determinado domínio.
CALL FUNCTION 'DD_DOMA_GET'
  EXPORTING
    domain_name = 'ZDOMINIO'
    langu       = sy-langu
    withtext    = 'X'
  TABLES
    dd07v_tab_a = it_taba
    dd07v_tab_n = it_tabn.
IF sy-subrc EQ 0.
  SORT it_taba BY domvalue_l.
ENDIF.

READ TABLE it_taba INTO wa_taba WITH KEY domvalue_l = wa_estrutura-campo
                                         BINARY SEARCH.
