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
* Implementação Fuleira de Blockchain p/ utilização no SAP via ABAP  *
* Ainda faltam algumas coisas, isso é projeto para alguns meses.     *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  19/09/2018  Evandro Matias  Cod. Inicial                      *
**********************************************************************

TYPES: BEGIN OF ty_block             ,
         index        TYPE i         ,
         timestamp    TYPE timestampl,
         hash         TYPE string    ,
         previoushash TYPE string    ,
         data         TYPE string    ,
       END OF ty_block               .

DATA: it_blockchain TYPE TABLE OF ty_block,
      wa_blockchain TYPE ty_block         .

DATA: lo_digest TYPE REF TO cl_abap_message_digest.

DATA: v_hash   TYPE string,
      v_phash  TYPE string,
      v_index  TYPE i     ,
      v_tx     TYPE string,
      v_tabix  TYPE c     ,
      v_vtx(7) TYPE c     .

PARAMETERS: p_tx001 TYPE string LOWER CASE DEFAULT 'SAP',
            p_tx002 TYPE string LOWER CASE DEFAULT 'Systeme',
            p_tx003 TYPE string LOWER CASE DEFAULT 'Anwendungen und',
            p_tx004 TYPE string LOWER CASE DEFAULT 'Produkte in',
            p_tx005 TYPE string LOWER CASE DEFAULT 'der Datenverarbeitun'.

FIELD-SYMBOLS: <fs_tx> TYPE string.

START-OF-SELECTION.

  DO 5 TIMES.
    CLEAR: v_tx, v_vtx.
    v_tabix = sy-tabix.
    CONCATENATE 'P_TX00' v_tabix INTO v_vtx.
    ASSIGN (v_vtx) TO <fs_tx>.
    IF <fs_tx> IS ASSIGNED.
      v_tx = <fs_tx>.
      PERFORM f_create_block USING v_tx.
    ENDIF.
    UNASSIGN <fs_tx>.
  ENDDO.

  SORT it_blockchain BY index.

  LOOP AT it_blockchain INTO wa_blockchain.
    WRITE: / 'Block Number: ', wa_blockchain-index,
           / 'Timestamp   : ', wa_blockchain-timestamp,
           / 'Hash        : ', wa_blockchain-hash,
           / 'Prev. Hash  : ', wa_blockchain-previoushash,
           / 'Data        : ', wa_blockchain-data,
           /.
  ENDLOOP.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  f_generate_hash
*&---------------------------------------------------------------------*
FORM f_generate_hash USING p_data TYPE string
                  CHANGING p_hash TYPE string.
  DATA: vl_length        TYPE i     .

  vl_length = strlen( p_data ).

  cl_abap_message_digest=>calculate_hash_for_char(
    EXPORTING
      if_algorithm     = 'SHA256'
      if_data          = p_data
      if_length        = vl_length
    IMPORTING
      ef_hashstring    = p_hash ).

ENDFORM.                    "f_generate_hash

*&---------------------------------------------------------------------*
*&      Form  f_create_block
*&---------------------------------------------------------------------*
FORM f_create_block USING p_input TYPE string.

  DATA: vl_cdata     TYPE string,
        vl_msg       TYPE string,
        vl_ok        TYPE c     ,
        vl_index     TYPE string,
        vl_timestamp TYPE string.

  CLEAR: v_index, v_phash, v_hash, wa_blockchain, vl_cdata, vl_index, vl_timestamp, vl_ok, vl_msg.
  PERFORM f_get_index_and_phash.
  wa_blockchain-index = v_index.
  GET TIME STAMP FIELD wa_blockchain-timestamp.
  wa_blockchain-previoushash = v_phash.
  wa_blockchain-data = p_input.
  vl_index = wa_blockchain-index.
  vl_timestamp = wa_blockchain-timestamp.
  CONCATENATE vl_index vl_timestamp wa_blockchain-previoushash wa_blockchain-data INTO vl_cdata.
  PERFORM f_generate_hash USING vl_cdata CHANGING v_hash.
  wa_blockchain-hash = v_hash.

  " Valida cada bloco novo criado.
  PERFORM f_is_valid_blockchain USING vl_ok
                             CHANGING vl_msg.

  IF vl_ok IS INITIAL.
    APPEND wa_blockchain TO it_blockchain.
  ELSE.
    WRITE: / vl_msg.
  ENDIF.

  " Bloco Criado a cada 1 Segundo.
  WAIT UP TO 1 SECONDS.

ENDFORM.                    "f_create_block

*&---------------------------------------------------------------------*
*&      Form  f_get_index_and_phash
*&---------------------------------------------------------------------*
FORM f_get_index_and_phash.

  DATA: vl_cdata     TYPE string,
        vl_index     TYPE string,
        vl_timestamp TYPE string.

  DATA: wa_blockchainl TYPE ty_block.

  CLEAR: wa_blockchainl, vl_cdata, vl_index, vl_timestamp.
  IF it_blockchain[] IS INITIAL.
    " Criando Bloco Genesis
*    clear wa_blockchain.
    wa_blockchainl-index = 1.
    GET TIME STAMP FIELD wa_blockchainl-timestamp.
    CLEAR wa_blockchainl-previoushash.
    wa_blockchainl-data = 'Implementação Fuleira do Blockchain em SAP ABAP'.
    vl_index = wa_blockchainl-index.
    vl_timestamp = wa_blockchainl-timestamp.
    CONCATENATE vl_index vl_timestamp wa_blockchainl-previoushash wa_blockchainl-data INTO vl_cdata.
    PERFORM f_generate_hash USING vl_cdata CHANGING v_hash.
    wa_blockchainl-hash = v_hash.
    APPEND wa_blockchainl TO it_blockchain.
  ELSE.
    SORT it_blockchain BY index DESCENDING.
    READ TABLE it_blockchain INTO wa_blockchainl INDEX 1.
  ENDIF.

  v_index = wa_blockchainl-index + 1.
  v_phash = wa_blockchainl-hash.

  CLEAR v_hash.

ENDFORM.                    "f_get_index_and_phash

*&---------------------------------------------------------------------*
*&      Form  f_valid_block
*&---------------------------------------------------------------------*
FORM f_is_valid_blockchain USING p_ok TYPE c
                        CHANGING p_msg TYPE string.

  DATA: vl_cdata     TYPE string,
        vl_index     TYPE string,
        vl_timestamp TYPE string.

  DATA: wa_blockchainl TYPE ty_block.
  CLEAR: wa_blockchainl.

  IF it_blockchain[] IS INITIAL.
    p_msg = 'Blockchain ainda não foi criado'.
    p_ok = abap_on.
  ELSE.
    SORT it_blockchain BY index DESCENDING.
    READ TABLE it_blockchain INTO wa_blockchainl INDEX 1.
  ENDIF.


  " Verifica se a Sequência de Blocos está ok!

  " Verifica se houve mudança nos registros dos blocos!

ENDFORM.                    "f_valid_block

*&---------------------------------------------------------------------*
*&      Form  f_miner
*&---------------------------------------------------------------------*
FORM f_miner.

  " Criar RFC para minerar bloco?
  " Ou criar um minerador em C#/Java para brincar mais ainda? SAP JCo?
  " Se for um minerador C#/Java, qual seria o caso de uso?

ENDFORM.                    "f_miner

*&---------------------------------------------------------------------*
*&      Form  f_coinbase
*&---------------------------------------------------------------------*
FORM f_coinbase.

  " Essa é a parte complicada, criar a moeda, as transações e a carteira.

ENDFORM.                    "f_coinbase

*&---------------------------------------------------------------------*
*&      Form  f_tx
*&---------------------------------------------------------------------*
FORM f_tx.

  " Send to pool!

ENDFORM.                    "f_tx

*&---------------------------------------------------------------------*
*&      Form  f_wallet
*&---------------------------------------------------------------------*
FORM f_wallet.

  " Create Wallet
  " Send TX
  " Check Balance
  " Create token ????

ENDFORM.                    "f_wallet

*&---------------------------------------------------------------------*
*&      Form  f_pool
*&---------------------------------------------------------------------*
FORM f_pool.

  " Pool de TX

ENDFORM.                    "f_pool

*&---------------------------------------------------------------------*
*&      Form  f_api
*&---------------------------------------------------------------------*
FORM f_api.

  " Criar RFC para APIs?

ENDFORM.                    "f_api
