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
* Busca a localização exata de um determinado caractere em uma string*
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  12/09/2018  Evandro Matias  Cod. Inicial                      *
**********************************************************************
report z_busca_caractere_string.

DATA: v_busca     TYPE string VALUE `loren`,
      v_texto     TYPE string,
      t_resultado TYPE match_result_tab.

FIELD-SYMBOLS <fs_busca> LIKE LINE OF t_resultado.

" Case-sensitive
FIND ALL OCCURRENCES OF v_busca IN
     `Lorem ipsum dolor sit amet, loren consectetur adipiscing elit, loren sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.`
     RESULTS t_resultado.

LOOP AT t_resultado ASSIGNING <fs_busca>.
  cl_demo_output=>write( |{ <fs_busca>-offset } {
                            <fs_busca>-length }| ).
ENDLOOP.

cl_demo_output=>display( ).
