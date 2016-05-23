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
* DATA                : 23/05/2016                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Função utilizada para cálculo de data.                             *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  23/05/2016  Evandro Matias  Cod. Inicial                      *
**********************************************************************

REPORT zcalcula_data.

DATA: v_data_ent TYPE sy-datum,
      v_data_sai TYPE sy-datum.

v_data_ent = sy-datum.

" Função para cálculo de data.
CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
  EXPORTING
    date      = v_data_ent " Data de entrada
    days      = '0' " Usando dias
    months    = '5' " Usando meses
    signum    = '-' " Soma ou Subtrai um determinada data.
    years     = '0' " Usando anos
  IMPORTING
    calc_date = v_data_sai. " Data de saída

WRITE: / v_data_ent, v_data_sai.
