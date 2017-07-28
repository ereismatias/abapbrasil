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
* Programa utilizado para desenvolvimento da                         *
* "inteligência" artificial no SAP/ABAP.                             *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  28/07/2017  Evandro Matias  Cod. Inicial                      *
**********************************************************************

REPORT zwa_ia.

DATA: v_resp TYPE i.

PARAMETERS: p_ent TYPE char255.

" Analisando a pergunta.


" Respondendo a pergunta.

CALL FUNCTION 'GENERAL_GET_RANDOM_INT'
  EXPORTING
    range  = '3'
  IMPORTING
    random = v_resp.

IF v_resp = '0'.
  WRITE: 'Não entendi direito sua pergunta, poderia repetir. Obrigada!'.
ELSEIF v_resp = '1'.
  WRITE: 'Desculpe ainda estou aprendendo, mas agora são:', sy-uzeit.
ELSEIF v_resp = '2'.
  WRITE: 'Não sei se posso te ajudar com isso, mas hoje é dia', sy-datum.
ELSE.
  WRITE: 'Dizem os especialistas que hoje tem 50% de chances de chover a noite, foi essa sua pergunta?'.
ENDIF.
