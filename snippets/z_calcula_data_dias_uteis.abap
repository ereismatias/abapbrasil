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
* DATA                : 29/07/2016                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Calcular próximo dia útil a partir de uma determinada e quantidade *
* de dias.                                                           *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  29/07/2016  Evandro Matias  Cod. Inicial                      *
**********************************************************************
REPORT z_calcula_data_dias_uteis NO STANDARD PAGE HEADING.

DATA: v_saida TYPE sy-datum,
      v_calc  TYPE i       .

DATA: it_data TYPE TABLE OF iscal_day.

PARAMETER: p_data TYPE sy-datum,
           p_dias TYPE i       .

v_saida = p_data + 1.

WHILE v_calc < p_dias.

  FREE it_data.
  CALL FUNCTION 'HOLIDAY_GET'
    EXPORTING
      holiday_calendar           = 'BR'
      factory_calendar           = 'BR'
      date_from                  = v_saida
      date_to                    = v_saida
    TABLES
      holidays                   = it_data
    EXCEPTIONS
      factory_calendar_not_found = 1
      holiday_calendar_not_found = 2
      date_has_invalid_format    = 3
      date_inconsistency         = 4
      OTHERS                     = 5.

  IF it_data[] IS INITIAL.
    ADD 1 TO v_calc. "Count working days

    IF v_calc = p_dias.
      EXIT.
    ENDIF.

  ENDIF.

  ADD 1 TO v_saida.

ENDWHILE.

WRITE: /  'Data Inicial: ', p_data,
       /  'Data Final: ', v_saida.
