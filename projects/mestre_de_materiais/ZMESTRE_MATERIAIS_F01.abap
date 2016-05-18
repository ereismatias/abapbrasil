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
*&  Include           ZMESTRE_MATERIAIS_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Form  f_seleciona_dados
*&---------------------------------------------------------------------*
FORM f_seleciona_dados.

  " Cópia de select do SQVI.
  SELECT marav~matnr marav~spras marav~mtart marav~mbrsh marav~matkl marav~bismt marav~meins marav~attyp marav~lvorm marav~ersda
         marav~ernam marav~laeda marav~aenam marav~magrv marav~mtpos_mara marav~tragr marav~vhart marav~mhdhb marav~spart
         tspa~spart tspat~vtext tspat~spart tspat~spras mvke~vkorg mvke~vtweg mvke~vrkme mvke~mtpos mvke~dwerk mvke~prodh
         mvke~pmatn mvke~kondm mvke~ktgrm mvke~matnr makt~maktx makt~matnr makt~spras marc~werks marc~prctr marc~indus marc~steuc
         marc~bwtty marc~ekgrp marc~dismm marc~dispo marc~beskz marc~sobsl marc~eisbe marc~bstmi marc~bstma marc~bstfe marc~mabst
         marc~basmg marc~maxlz marc~dzeit marc~mrppp marc~sauft marc~stlal marc~stlan marc~plnnr marc~losgr marc~aplal marc~frtme
         marc~lgpro marc~disgr marc~kausf marc~qmatv marc~qzgtp marc~takzt marc~rwpro marc~lfrhy marc~vrbwk marc~ladgr marc~mfrgr
         marc~sfcpf marc~uomgr marc~umrsl marc~matnr mbew~mtorg mbew~ownpr mbew~mtuse mbew~bwtar mbew~bwkey mbew~oihmtxgr
         mbew~lvorm mbew~stprs mbew~peinh mbew~vmstp mbew~vmver mbew~lfgja mbew~lfmon mbew~stprv mbew~zkprs mbew~pprdz mbew~pprdl
         mbew~pprdv mbew~pdatz mbew~pdatl mbew~pdatv mbew~vmvpr mbew~vmpei mbew~vjver mbew~vjstp mbew~vjpei mbew~laepr mbew~bklas
         mbew~lplpr mbew~vplpr mbew~lbkum mbew~salk3 mbew~vprsv mbew~verpr mbew~salkv mbew~vmkum mbew~vmsal mbew~vmbkl mbew~vmsav
         mbew~vjkum mbew~vjsal mbew~vjvpr mbew~vjbkl mbew~vjsav mbew~bwtty mbew~zkdat mbew~hkmat mbew~vksal mbew~matnr
    INTO TABLE it_material
    FROM ( marav
         LEFT OUTER JOIN tspa
         ON  tspa~spart = marav~spart
         INNER JOIN tspat
         ON  tspat~spras = marav~spras
         AND tspat~spart = tspa~spart
         INNER JOIN mvke
         ON  mvke~matnr = marav~matnr
         LEFT OUTER JOIN makt
         ON  makt~matnr = marav~matnr
         AND makt~spras = marav~spras
         LEFT OUTER JOIN marc
         ON  marc~matnr = marav~matnr
         INNER JOIN mbew
         ON  mbew~matnr = marc~matnr
         AND mbew~bwkey = marc~werks )
   WHERE marav~matnr IN so_matnr
     AND marav~spras IN so_spras
     AND marav~mtart IN so_mtart
     AND marav~mbrsh IN so_mbrsh
     AND marav~matkl IN so_matkl
     AND marav~lvorm IN so_lvorm
     AND marav~spart IN so_spart
     AND mvke~vkorg  IN so_vkorg
     AND mvke~vtweg  IN so_vtweg.

  IF sy-subrc NE 0.
    MESSAGE i398(00) WITH text-003.
    LEAVE LIST-PROCESSING.
  ENDIF.

  " Verifica se o Produto Controlado está em branco.
  IF NOT p_class IS INITIAL.
    " Busca o Nº classe interno e o Tipo de classe de um determinado Nº classe.
    SELECT SINGLE clint klart
      INTO (v_clint, v_klart)
      FROM klah
     WHERE class EQ p_class.

    IF sy-subrc EQ 0.
      " Busca as 'Característica interna' de um determinado
      " Nº classe para criar os campos dinamicamente.
      SELECT clint imerk klart
        INTO TABLE it_ksml
        FROM ksml
       WHERE clint EQ v_clint
         AND klart EQ v_klart.
      IF sy-subrc EQ 0.
        SORT it_ksml BY imerk.
        " Busca as características de campos (estrutura/tipo) do de todas as
        " 'Característica interna' de um determinado Nº classe.
        SELECT *
          INTO TABLE it_cabn
          FROM cabn
           FOR ALL ENTRIES IN it_ksml
         WHERE atinn = it_ksml-imerk.
        IF sy-subrc EQ 0.
          " Busca os textos da 'Característica interna' de um determinado Nº classe.
          SELECT *
            INTO TABLE it_cabnt
            FROM cabnt
             FOR ALL ENTRIES IN it_cabn
           WHERE atinn = it_cabn-atinn
             AND spras EQ sy-langu.
          IF sy-subrc EQ 0.
            SORT it_cabnt BY atinn.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
ENDFORM.                    "f_seleciona_dados

*&---------------------------------------------------------------------*
*&      Form  f_call
*&---------------------------------------------------------------------*
FORM f_call.

  CALL SCREEN 9000.

ENDFORM.                    "f_call

*&---------------------------------------------------------------------*
*&      Form  F_FIELD_CATALOG
*&---------------------------------------------------------------------*
FORM f_monta_fieldcat.

  " Declarações para tratamento de tabela dinâmica.
  DATA: lo_columns      TYPE REF TO cl_salv_columns_table,
        lo_aggregations TYPE REF TO cl_salv_aggregations ,
        lo_salv_table   TYPE REF TO cl_salv_table        ,
        lr_table        TYPE REF TO data                 ,
        rt_fcat         TYPE lvc_t_fcat                  .

  FIELD-SYMBOLS: <table>  TYPE STANDARD TABLE.

  " Declarações para execução da Função.
  DATA: it_class      TYPE TABLE OF sclass  ,
        it_objectdata	TYPE TABLE OF clobjdat.

  DATA: wa_class      TYPE sclass  ,
        wa_objectdata	TYPE clobjdat.

  DATA: vl_class     TYPE klah-class,
        vl_classtype TYPE klah-klart,
        vl_clint     TYPE klah-clint,
        vl_object    TYPE ausp-objek,
        vl_campo(30) TYPE c         .

  TYPES: BEGIN OF ty_objeto            ,
           matnr     TYPE mara-matnr   ,
           class     TYPE klah-class   ,
           classtype TYPE klah-klart   ,
           clint     TYPE klah-clint   ,
           object    TYPE ausp-objek   ,
           carac     LIKE it_objectdata,
         END OF ty_objeto              .

  DATA: it_objetos TYPE TABLE OF ty_objeto,
        wa_objetos TYPE ty_objeto         .

* Cria um tabela desprotegida a partir de uma tabela interna
  CREATE DATA lr_table LIKE it_material.
  ASSIGN lr_table->* TO <table>.

* SALV Instance
  TRY.
      cl_salv_table=>factory(
        EXPORTING
          list_display = abap_false
        IMPORTING
          r_salv_table = lo_salv_table
        CHANGING
          t_table      = <table> ).
    CATCH cx_salv_msg.                                  "#EC NO_HANDLER
  ENDTRY.

* Obtém os objetos da coluna
  lo_columns  = lo_salv_table->get_columns( ).

* Obtém as agregações
  lo_aggregations = lo_salv_table->get_aggregations( ).
  it_field = cl_salv_controller_metadata=>get_lvc_fieldcatalog( r_columns      = lo_columns
                                                                r_aggregations = lo_aggregations ).

* Apenas configurações iniciais do FieldCat para a tabela principal.
  LOOP AT it_field INTO wa_field.
    wa_field-col_opt = abap_on.
    wa_field-no_out = abap_on.
    wa_field-col_pos = 100.

    IF wa_field-fieldname EQ 'MARAV_MTART' OR
       wa_field-fieldname EQ 'MARAV_MATKL' OR
       wa_field-fieldname EQ 'MARAV_MEINS' OR
       wa_field-fieldname EQ 'MBEW_MTORG'  OR
       wa_field-fieldname EQ 'MBEW_OWNPR'  OR
       wa_field-fieldname EQ 'MBEW_MTUSE'  OR
       wa_field-fieldname EQ 'MARAV_MBRSH' OR
       wa_field-fieldname EQ 'MARC_PRCTR'  OR
       wa_field-fieldname EQ 'MARC_INDUS'  OR
       wa_field-fieldname EQ 'MARC_STEUC'  OR
       wa_field-fieldname EQ 'MBEW_BKLAS'  OR
       wa_field-fieldname EQ 'MVKE_VTWEG'  OR
       wa_field-fieldname EQ 'MVKE_PRODH'  OR
       wa_field-fieldname EQ 'MVKE_VKORG'  OR
       wa_field-fieldname EQ 'MARAV_SPART'.
      CLEAR: wa_field-no_out.
    ELSEIF wa_field-fieldname EQ 'MARC_WERKS'.
      CLEAR wa_field-no_out.
      wa_field-key = abap_on.
      wa_field-col_pos = 001.
    ELSEIF wa_field-fieldname EQ 'MARAV_MATNR'.
      CLEAR wa_field-no_out.
      wa_field-key = abap_on.
      wa_field-col_pos = 002.
      wa_field-hotspot = abap_on.
    ELSEIF wa_field-fieldname EQ 'MAKT_MAKTX'.
      CLEAR wa_field-no_out.
      wa_field-key = abap_on.
      wa_field-col_pos = 003.
    ENDIF.

    MODIFY it_field FROM wa_field.
  ENDLOOP.

* Caso tenha algum número de Classe é necessário adicionar campos
* dinamicamente em nosso tabela final e também no FieldCat.
  IF NOT p_class IS INITIAL.

* Adiciona os campos de 'Característica interna' de um determinado Nº de Classo no FieldCat.
    LOOP AT it_cabn INTO wa_cabn.
      CLEAR: wa_field, wa_cabnt.
      READ TABLE it_cabnt INTO wa_cabnt WITH KEY atinn = wa_cabn-atinn
                                                 BINARY SEARCH.
      wa_field-fieldname = wa_cabn-atnam.
      wa_field-datatype = wa_cabn-atfor.
      wa_field-intlen = wa_cabn-anzst.
      wa_field-reptext = wa_cabnt-atbez.
      wa_field-scrtext_l = wa_cabnt-atbez.
      wa_field-scrtext_m = wa_cabnt-atbez.
      wa_field-scrtext_s = wa_cabnt-atbez.
      wa_field-col_pos = 101.
      APPEND wa_field TO it_field.

    ENDLOOP.
  ENDIF.

* Com o FieldCat preparado, com todos os campos finais, criamos uma tabela dinâmica
* que será apresentada no ALV.
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      i_style_table             = 'X'
      it_fieldcatalog           = it_field
    IMPORTING
      ep_table                  = gt_dyn_table
    EXCEPTIONS
      generate_subpool_dir_full = 1
      OTHERS                    = 2.

* Crio nosso WorkArea de trabalho para os dados de nosso tabela dinâmica.
  ASSIGN gt_dyn_table->* TO <fs_dyn_table>.
  CREATE DATA gw_line LIKE LINE OF <fs_dyn_table>.
  ASSIGN gw_line->* TO <fs_line>.

  IF NOT p_class IS INITIAL.
    it_matnr_aux[] = it_material[].
    SORT it_matnr_aux BY marav_matnr.
    DELETE ADJACENT DUPLICATES FROM it_matnr_aux COMPARING marav_matnr.
    " Realizar a consulta na função CLAF_CLASSIFICATION_OF_OBJECTS apenas
    " uma vez para cada material.
    LOOP AT it_matnr_aux INTO wa_material.
      CLEAR: vl_class, vl_classtype, vl_clint, vl_object, wa_objetos.
      FREE: wa_objetos-carac.

      vl_class = p_class.
      vl_classtype = v_klart.
      vl_clint = v_clint.
      vl_object = wa_material-marav_matnr.

      " Para o registro de Característica interna de um determinado Nº Classe
      " para um material específico utilizado a função abaixo.
      CALL FUNCTION 'CLAF_CLASSIFICATION_OF_OBJECTS'
        EXPORTING
          class              = vl_class
          classtext          = 'X'
          classtype          = vl_classtype
          clint              = vl_clint
          language           = sy-langu
          object             = vl_object
          key_date           = sy-datum
          initial_charact    = 'X'
        TABLES
          t_class            = it_class
          t_objectdata       = wa_objetos-carac " Dentro da WK tem uma tabela com os registro
        EXCEPTIONS                              " das características de cada material.
          no_classification  = 1
          no_classtypes      = 2
          invalid_class_type = 3
          OTHERS             = 4.
      IF sy-subrc EQ 0.
        wa_objetos-class = vl_class.
        wa_objetos-classtype = vl_classtype.
        wa_objetos-clint = vl_clint.
        wa_objetos-object = vl_object.
        APPEND wa_objetos TO it_objetos.
      ENDIF.
    ENDLOOP.

    IF NOT it_objetos[] IS INITIAL.
      SORT it_objetos BY class classtype clint object.
    ENDIF.
    FREE: it_matnr_aux.
  ENDIF.

  " Adiciono os registros selecionados de select em nossa tabela dinamica.
  LOOP AT it_material INTO wa_material.
    CLEAR <fs_line>.
    " Apenas envio para o campo correspondente.
    MOVE-CORRESPONDING wa_material TO <fs_line>.
    IF NOT p_class IS INITIAL.
      FREE: it_class, it_objectdata.
      CLEAR: vl_class, vl_classtype, vl_clint, vl_object.

      vl_class = p_class.
      vl_classtype = v_klart.
      vl_clint = v_clint.
      vl_object = wa_material-marav_matnr.

      " Busca a característica de Nº Classe para um determinado material.
      READ TABLE it_objetos INTO wa_objetos WITH KEY class = vl_class
                                                     classtype = vl_classtype
                                                     clint = vl_clint
                                                     object = vl_object
                                                     BINARY SEARCH.
      IF sy-subrc EQ 0.
        IF NOT wa_objetos-carac[] IS INITIAL.
          " Com os registros selecionado é necessário enviar para o campo correto.
          LOOP AT wa_objetos-carac INTO wa_objectdata.
            CLEAR vl_campo.
            " No FieldSymbol eu faço o espelho do campo da Característica e envio o dado correspondente.
            vl_campo = wa_objectdata-atnam.
            ASSIGN COMPONENT vl_campo OF STRUCTURE <fs_line> TO <fs1>.
            <fs1> = wa_objectdata-ausp1.
            UNASSIGN <fs1>.
          ENDLOOP.
        ENDIF.
      ENDIF.
    ENDIF.

    " Após preencher todos os campos (inclusive os gerados dinamicamente)
    " eu adiciono esse registro em nosso tabela dinâmica para exibir no ALV.
    APPEND <fs_line> TO <fs_dyn_table>.
  ENDLOOP.

ENDFORM.                    "f_monta_fieldcat

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
MODULE status_9000 OUTPUT.

  SET PF-STATUS 'ZF1MMR_MM'.
  SET TITLEBAR 'ZF1MMR_MM'.

  IF r_grid IS INITIAL.

    " Declaração do Handler.
    DATA: r_handler TYPE REF TO lcl_event_handler.

** Monta Fieldcat
    PERFORM f_monta_fieldcat.

    v_repid = sy-repid.
    v_dynnr = sy-dynnr.

* Cria objetos para os grids
    CREATE OBJECT r_grid
      EXPORTING
        i_parent = cl_gui_container=>screen0.

    gs_layout-zebra         = abap_on.
    gs_layout-grid_title    = text-010.
    gs_variant-report       = sy-repid.
    gs_variant-username     = sy-uname.

* Cria objeto event handler.
    CREATE OBJECT r_handler.

* Seta o Método HOTSPOT para o GRID abaixo.
    SET HANDLER r_handler->hotspot_click FOR r_grid.

* Faz a chamada do ALV.
    CALL METHOD r_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
        is_variant      = gs_variant
        i_save          = 'A'
      CHANGING
        it_outtab       = <fs_dyn_table> " Tabela Dinâmica
        it_fieldcatalog = it_field.
  ELSE.
    " Caso o objeto GRID esteja criado, apenas dar um Refresh
    " na exibição com os dados novos.
    CALL METHOD r_grid->refresh_table_display.
  ENDIF.

ENDMODULE.                 " STATUS_9000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9000  INPUT
*&---------------------------------------------------------------------*
MODULE user_command_9000 INPUT.

  IF sy-ucomm EQ 'EXIT'.
    LEAVE TO SCREEN 0.
  ENDIF.

ENDMODULE.                 " USER_COMMAND_9000  INPUT