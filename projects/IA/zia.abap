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
* 002  14/09/2017  Evandro Matias  Pois é, ainda não andou!          *
**********************************************************************

REPORT zwa_ia.

DATA: v_resp TYPE i,
      v_exit TYPE c,
      v_off  TYPE i,
      v_len  TYPE i.

PARAMETERS: p_ent TYPE char255.

SEARCH p_ent FOR 'HORA' ABBREVIATED. " Mudar para REGEX

IF sy-subrc EQ 0 AND v_exit IS INITIAL.
  WRITE: / 'Olá, agora são:', sy-uzeit.
  v_exit = abap_on.
ENDIF.

SEARCH p_ent FOR 'DATA' ABBREVIATED.

IF sy-subrc EQ 0 AND v_exit IS INITIAL.
  WRITE: 'Olá, hoje é dia:', sy-datum.
  v_exit = abap_on.
ENDIF.

SEARCH p_ent FOR 'DIA' ABBREVIATED.

IF sy-subrc EQ 0 AND v_exit IS INITIAL.
  WRITE: 'Olá, hoje é dia:', sy-datum.
  v_exit = abap_on.
ENDIF.

SEARCH p_ent FOR 'CONCATENATE' ABBREVIATED.

IF sy-subrc EQ 0 AND v_exit IS INITIAL.
  WRITE: 'Olá, o comando CONCATENATE serve para "juntar" duas variáveis, segue exemplo do comando:',
         /, / 'CONCATENATE ´VI´ ´DA´ INTO v_final',
         /, / 'Com esse comando o resultado final será VIDA'.
  v_exit = abap_on.
ENDIF.

" Analisando a pergunta.


" Respondendo a pergunta.

CALL FUNCTION 'GENERAL_GET_RANDOM_INT'
  EXPORTING
    range  = '3'
  IMPORTING
    random = v_resp.

IF v_exit IS INITIAL.
  IF v_resp = '0'.
    WRITE: 'Não entendi direito sua pergunta, poderia repetir. Obrigada!'.
  ELSEIF v_resp = '1'.
    WRITE: 'Desculpe ainda estou aprendendo, mas agora são:', sy-uzeit.
  ELSEIF v_resp = '2'.
    WRITE: 'Não sei se posso te ajudar com isso, mas hoje é dia', sy-datum.
  ELSE.
    WRITE: 'Dizem os especialistas que hoje tem 50% de chances de chover a noite, foi essa sua pergunta?'.
  ENDIF.
ENDIF.

* RESULTADO ESPERADO
*
* Faça sua pergunta: Que horas são?
* Resposta: Olá, agora são: 13:29:51

* Faça sua pergunta: Que dia é hoje?
* Olá, hoje é dia: 14.09.2018

* Faça sua pergunta: Para que serve o Concatenate?
* Olá, o comando CONCATENATE serve para "juntar" duas variáveis, segue exemplo do comando:
* CONCATENATE ´VI´ ´DA´ INTO v_final
* Com esse comando o resultado final será VIDA

* Mas isso é IA ? Não, de forma alguma, mas algumas startups fazem isso. Isso ai está mais para um chatbot.
