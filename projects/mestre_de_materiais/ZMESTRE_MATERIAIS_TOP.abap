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
*&  Include           ZMESTRE_MATERIAIS_TOP
*&---------------------------------------------------------------------*

" Tables
TABLES: marav, tspa, tspat, mvke, makt, marc, mbew, t001, mara.

" Tipos (Estrutura)
TYPES: BEGIN OF ty_material                 ,
         marav_matnr      LIKE marav-matnr  ,
         marav_spras      LIKE marav-spras  ,
         marav_mtart      LIKE marav-mtart  ,
         marav_mbrsh      LIKE marav-mbrsh  ,
         marav_matkl      LIKE marav-matkl  ,
         marav_bismt      LIKE marav-bismt  ,
         marav_meins      LIKE marav-meins  ,
         marav_attyp      LIKE marav-attyp  ,
         marav_lvorm      LIKE marav-lvorm  ,
         marav_ersda      LIKE marav-ersda  ,
         marav_ernam      LIKE marav-ernam  ,
         marav_laeda      LIKE marav-laeda  ,
         marav_aenam      LIKE marav-aenam  ,
         marav_magrv      LIKE marav-magrv  ,
         marav_mtpos_mara LIKE marav-mtpos_mara,
         marav_tragr      LIKE marav-tragr  ,
         marav_vhart      LIKE marav-vhart  ,
         marav_mhdhb      LIKE marav-mhdhb  ,
         marav_spart      LIKE marav-spart  ,
         tspa_spart       LIKE tspa-spart   ,
         tspat_vtext      LIKE tspat-vtext  ,
         tspat_spart      LIKE tspat-spart  ,
         tspat_spras      LIKE tspat-spras  ,
         mvke_vkorg       LIKE mvke-vkorg   ,
         mvke_vtweg       LIKE mvke-vtweg   ,
         mvke_vrkme       LIKE mvke-vrkme   ,
         mvke_mtpos       LIKE mvke-mtpos   ,
         mvke_dwerk       LIKE mvke-dwerk   ,
         mvke_prodh       LIKE mvke-prodh   ,
         mvke_pmatn       LIKE mvke-pmatn   ,
         mvke_kondm       LIKE mvke-kondm   ,
         mvke_ktgrm       LIKE mvke-ktgrm   ,
         mvke_matnr       LIKE mvke-matnr   ,
         makt_maktx       LIKE makt-maktx   ,
         makt_matnr       LIKE makt-matnr   ,
         makt_spras       LIKE makt-spras   ,
         marc_werks       LIKE marc-werks   ,
         marc_prctr       LIKE marc-prctr   ,
         marc_indus       LIKE marc-indus   ,
         marc_steuc       LIKE marc-steuc   ,
         marc_bwtty       LIKE marc-bwtty   ,
         marc_ekgrp       LIKE marc-ekgrp   ,
         marc_dismm       LIKE marc-dismm   ,
         marc_dispo       LIKE marc-dispo   ,
         marc_beskz       LIKE marc-beskz   ,
         marc_sobsl       LIKE marc-sobsl   ,
         marc_eisbe       LIKE marc-eisbe   ,
         marc_bstmi       LIKE marc-bstmi   ,
         marc_bstma       LIKE marc-bstma   ,
         marc_bstfe       LIKE marc-bstfe   ,
         marc_mabst       LIKE marc-mabst   ,
         marc_basmg       LIKE marc-basmg   ,
         marc_maxlz       LIKE marc-maxlz   ,
         marc_dzeit       LIKE marc-dzeit   ,
         marc_mrppp       LIKE marc-mrppp   ,
         marc_sauft       LIKE marc-sauft   ,
         marc_stlal       LIKE marc-stlal   ,
         marc_stlan       LIKE marc-stlan   ,
         marc_plnnr       LIKE marc-plnnr   ,
         marc_losgr       LIKE marc-losgr   ,
         marc_aplal       LIKE marc-aplal   ,
         marc_frtme       LIKE marc-frtme   ,
         marc_lgpro       LIKE marc-lgpro   ,
         marc_disgr       LIKE marc-disgr   ,
         marc_kausf       LIKE marc-kausf   ,
         marc_qmatv       LIKE marc-qmatv   ,
         marc_qzgtp       LIKE marc-qzgtp   ,
         marc_takzt       LIKE marc-takzt   ,
         marc_rwpro       LIKE marc-rwpro   ,
         marc_lfrhy       LIKE marc-lfrhy   ,
         marc_vrbwk       LIKE marc-vrbwk   ,
         marc_ladgr       LIKE marc-ladgr   ,
         marc_mfrgr       LIKE marc-mfrgr   ,
         marc_sfcpf       LIKE marc-sfcpf   ,
         marc_uomgr       LIKE marc-uomgr   ,
         marc_umrsl       LIKE marc-umrsl   ,
         marc_matnr       LIKE marc-matnr   ,
         mbew_mtorg       LIKE mbew-mtorg   ,
         mbew_ownpr       LIKE mbew-ownpr   ,
         mbew_mtuse       LIKE mbew-mtuse   ,
         mbew_bwtar       LIKE mbew-bwtar   ,
         mbew_bwkey       LIKE mbew-bwkey   ,
         mbew_oihmtxgr    LIKE mbew-oihmtxgr,
         mbew_lvorm       LIKE mbew-lvorm   ,
         mbew_stprs       LIKE mbew-stprs   ,
         mbew_peinh       LIKE mbew-peinh   ,
         mbew_vmstp       LIKE mbew-vmstp   ,
         mbew_vmver       LIKE mbew-vmver   ,
         mbew_lfgja       LIKE mbew-lfgja   ,
         mbew_lfmon       LIKE mbew-lfmon   ,
         mbew_stprv       LIKE mbew-stprv   ,
         mbew_zkprs       LIKE mbew-zkprs   ,
         mbew_pprdz       LIKE mbew-pprdz   ,
         mbew_pprdl       LIKE mbew-pprdl   ,
         mbew_pprdv       LIKE mbew-pprdv   ,
         mbew_pdatz       LIKE mbew-pdatz   ,
         mbew_pdatl       LIKE mbew-pdatl   ,
         mbew_pdatv       LIKE mbew-pdatv   ,
         mbew_vmvpr       LIKE mbew-vmvpr   ,
         mbew_vmpei       LIKE mbew-vmpei   ,
         mbew_vjver       LIKE mbew-vjver   ,
         mbew_vjstp       LIKE mbew-vjstp   ,
         mbew_vjpei       LIKE mbew-vjpei   ,
         mbew_laepr       LIKE mbew-laepr   ,
         mbew_bklas       LIKE mbew-bklas   ,
         mbew_lplpr       LIKE mbew-lplpr   ,
         mbew_vplpr       LIKE mbew-vplpr   ,
         mbew_lbkum       LIKE mbew-lbkum   ,
         mbew_salk3       LIKE mbew-salk3   ,
         mbew_vprsv       LIKE mbew-vprsv   ,
         mbew_verpr       LIKE mbew-verpr   ,
         mbew_salkv       LIKE mbew-salkv   ,
         mbew_vmkum       LIKE mbew-vmkum   ,
         mbew_vmsal       LIKE mbew-vmsal   ,
         mbew_vmbkl       LIKE mbew-vmbkl   ,
         mbew_vmsav       LIKE mbew-vmsav   ,
         mbew_vjkum       LIKE mbew-vjkum   ,
         mbew_vjsal       LIKE mbew-vjsal   ,
         mbew_vjvpr       LIKE mbew-vjvpr   ,
         mbew_vjbkl       LIKE mbew-vjbkl   ,
         mbew_vjsav       LIKE mbew-vjsav   ,
         mbew_bwtty       LIKE mbew-bwtty   ,
         mbew_zkdat       LIKE mbew-zkdat   ,
         mbew_hkmat       LIKE mbew-hkmat   ,
         mbew_vksal       LIKE mbew-vksal   ,
         mbew_matnr       LIKE mbew-matnr   ,
       END OF ty_material                   ,

       BEGIN OF ty_ksml                     ,
         clint TYPE ksml-clint              ,
         imerk TYPE ksml-imerk              ,
         klart TYPE ksml-klart              ,
       END OF ty_ksml                       .

" Tabela Interna
DATA: it_material  TYPE TABLE OF ty_material,
      it_matnr_aux TYPE TABLE OF ty_material,
      it_ksml      TYPE TABLE OF ty_ksml    ,
      it_cabn      TYPE TABLE OF cabn       ,
      it_cabnt     TYPE TABLE OF cabnt      .

" Estrutura (Work-Area)
DATA: wa_material TYPE ty_material,
      wa_ksml     TYPE ty_ksml    ,
      wa_cabnt    TYPE cabnt      ,
      wa_cabn     TYPE cabn       .

" Field-Symbol
FIELD-SYMBOLS: <fs_line>, <fs_dyn_table> TYPE STANDARD TABLE,
               <fs1>.

" Variáveis para Campos dinâmicos
DATA : gt_dyn_table  TYPE REF TO data,
       gw_line       TYPE REF TO data,
       gw_dyn_fcat   TYPE lvc_s_fcat ,
       gt_dyn_fcat   TYPE lvc_t_fcat .

* Objetos ALV
DATA: it_field TYPE lvc_t_fcat,
      wa_field TYPE lvc_s_fcat,
      it_sort  TYPE lvc_t_sort,
      wa_sort  TYPE lvc_s_sort.

" Variáveis
DATA: v_clint TYPE klah-clint,
      v_klart TYPE klah-klart.

* Cria referências para os objetos
DATA: r_grid    TYPE REF TO cl_gui_alv_grid         ,
      r_docking TYPE REF TO cl_gui_docking_container.

DATA: gs_layout  TYPE lvc_s_layo,
      gs_variant TYPE disvariant.

DATA: v_repid TYPE sy-repid,
      v_dynnr TYPE sy-dynnr.