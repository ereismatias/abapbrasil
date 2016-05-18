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
*&  Include           ZMESTRE_MATERIAIS_SCR
*&---------------------------------------------------------------------*

" Tela de Seleção
SELECTION-SCREEN BEGIN OF BLOCK bloco1 WITH FRAME TITLE text-001.
SELECT-OPTIONS: so_matnr FOR marav-matnr OBLIGATORY      ,
                so_mtart FOR marav-mtart                 ,
                so_werks FOR marc-werks                  ,
                so_vkorg FOR mvke-vkorg                  ,
                so_vtweg FOR mvke-vtweg                  ,
                so_spart FOR marav-spart                 ,
                so_mbrsh FOR marav-mbrsh                 ,
                so_spras FOR marav-spras DEFAULT sy-langu,
                so_matkl FOR marav-matkl                 ,
                so_steuc FOR marc-steuc                  ,
                so_lvorm FOR marav-lvorm                 .
SELECTION-SCREEN SKIP.
PARAMETERS: p_class TYPE klah-class MATCHCODE OBJECT znumclasse.
SELECTION-SCREEN END OF BLOCK bloco1.

SELECTION-SCREEN BEGIN OF BLOCK stdsel WITH FRAME TITLE text-002.
PARAMETERS p_layout TYPE slis_vari MODIF ID lay.
SELECTION-SCREEN END OF BLOCK stdsel.