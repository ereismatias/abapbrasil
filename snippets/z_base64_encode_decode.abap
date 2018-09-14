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
* DATA                : 14/09/2018                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Base64 - ENCODE/DECODE                                             *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  14/09/2018  Evandro Matias  Cod. Inicial                      *
**********************************************************************

REPORT z_base64_encode_decode.

DATA: v_encode TYPE string,
      v_decode TYPE string,
      v_texto  TYPE string.

DATA: lo_b64 TYPE REF TO cl_http_utility.

CREATE OBJECT: lo_b64.

v_texto = 'Teste'.

WRITE: /, v_texto.
v_encode = lo_b64->if_http_utility~encode_base64( v_texto ).
WRITE: /, v_encode.
v_decode = lo_b64->if_http_utility~decode_base64( v_encode ).
WRITE: /, v_decode.

* RESULTADO ESPERADO:
*
* Teste
*
* VGVzdGU=
*
* Teste
*
