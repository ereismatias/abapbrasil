
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
* DATA                : 03/04/2018                                   *
*--------------------------------------------------------------------*
* OBJETIVOS                                                          *
* Programa para automatizar a limpeza de cache do FIORI.             *
*--------------------------------------------------------------------*
* HISTÓRICO DE MUDANÇAS:                                             *
* MUD  DATA        AUTOR           DESCRIÇÃO                         *
* 001  03/04/2018  Evandro Matias  Cod. Inicial                      *
**********************************************************************
REPORT zfiori_clear_cache.

**********************************************************************
* CONSTANTES
**********************************************************************
CONSTANTS: c_syncc TYPE trdir-name VALUE '/UI2/CHIP_SYNCHRONIZE_CACHE',
           c_dcaai TYPE trdir-name VALUE '/UI2/DELETE_CACHE_AFTER_IMP',
           c_dcace TYPE trdir-name VALUE '/UI2/DELETE_CACHE',
           c_index TYPE trdir-name VALUE '/UI5/APP_INDEX_CALCULATE',
           c_invgl TYPE trdir-name VALUE '/UI2/INVALIDATE_GLOBAL_CACHES',
           c_invcl TYPE trdir-name VALUE '/UI2/INVALIDATE_CLIENT_CACHES'.

**********************************************************************
* TELA DE SELEÇÃO
**********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK bloco1 WITH FRAME TITLE text-001.
PARAMETERS: p_syncc TYPE c AS CHECKBOX DEFAULT 'X',
            p_dcaai TYPE c AS CHECKBOX DEFAULT 'X',
            p_dcace TYPE c AS CHECKBOX DEFAULT 'X',
            p_index TYPE c AS CHECKBOX DEFAULT 'X',
            p_invgl TYPE c AS CHECKBOX DEFAULT 'X',
            p_invcl TYPE c AS CHECKBOX DEFAULT 'X'.
SELECTION-SCREEN END OF BLOCK bloco1.


**********************************************************************
* START-OF-SELECTION
**********************************************************************
START-OF-SELECTION.

  IF p_syncc EQ abap_on.
    PERFORM f_cria_job USING c_syncc.
  ENDIF.

  IF p_dcaai EQ abap_on.
    PERFORM f_cria_job USING c_dcaai.
  ENDIF.

  IF p_dcace EQ abap_on.
    PERFORM f_cria_job USING c_dcace.
  ENDIF.

  IF p_index EQ abap_on.
    PERFORM f_cria_job USING c_index.
  ENDIF.

  IF p_invgl EQ abap_on.
    PERFORM f_cria_job USING c_invgl.
  ENDIF.

  IF p_invcl EQ abap_on.
    PERFORM f_cria_job USING c_invcl.
  ENDIF.

  WRITE / 'Pronto chefe. Só esperar uns 5 minutinhos prá acabar os jobs.'.

*&---------------------------------------------------------------------*
*&      Form  f_cria_job
*&---------------------------------------------------------------------*
FORM f_cria_job USING p_program TYPE trdir-name.

  DATA: vl_jobcount LIKE tbtcjob-jobcount          , "Número interno do job
        vl_jobname  LIKE tbtcjob-jobname           , "Nome de identificação do Job
        vl_released LIKE btch0000-char1            , "Retorno de status do job
        vl_jobdate  TYPE tbtcjob-sdlstrtdt,
        vl_jobtime  TYPE tbtcjob-sdlstrttm,
        vl_jobclass TYPE tbtcjob-jobclass VALUE 'A'.

  CLEAR: vl_jobcount, vl_jobname, vl_released, vl_jobdate,  vl_jobtime.

  CONCATENATE p_program
              sy-datum         " AAAAMMDD
              sy-uzeit         " HHMMSS
              INTO vl_jobname
              SEPARATED BY '_'.

  vl_jobdate = sy-datum.
  vl_jobtime = sy-uzeit + 1.

  CALL FUNCTION 'JOB_OPEN' " Abre um novo JOB.
    EXPORTING
      jobname          = vl_jobname
      sdlstrtdt        = vl_jobdate
      sdlstrttm        = vl_jobtime
      jobclass         = vl_jobclass
    IMPORTING
      jobcount         = vl_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc NE 0.
    " Erro na criação do job.
    WRITE: / 'JOB: ', vl_jobcount, ' - Programa: ', vl_jobname, ':', text-004.
  ENDIF.

  IF p_program = c_dcace.
    SUBMIT (p_program) VIA JOB vl_jobname NUMBER vl_jobcount
                                            WITH p_user-low = '*'
                                            WITH p_allcli = abap_on
                                             AND RETURN.
  ELSEIF p_program = c_index.
    SUBMIT (p_program) VIA JOB vl_jobname NUMBER vl_jobcount
                                            WITH p_all_d = space
                                            WITH p_all_a = abap_on
                                             AND RETURN.
  ELSEIF p_program = c_invgl.
    SUBMIT (p_program) VIA JOB vl_jobname NUMBER vl_jobcount
                                            WITH gv_test = space
                                            WITH gv_exe  = abap_on
                                             AND RETURN.
  ELSE.
    SUBMIT (p_program) VIA JOB vl_jobname NUMBER vl_jobcount
                                             AND RETURN.
  ENDIF.

  CALL FUNCTION 'JOB_CLOSE' " Finaliza JOB.
    EXPORTING
      jobcount         = vl_jobcount
      jobname          = vl_jobname
      sdlstrtdt        = vl_jobdate
      sdlstrttm        = vl_jobtime
      strtimmed        = 'X'   " Execução Imediata
    IMPORTING
      job_was_released = vl_released
    EXCEPTIONS
      OTHERS           = 9.
  IF sy-subrc NE 0.
    " Erro na inicialização do job.
    WRITE: / 'JOB: ', vl_jobcount, ' - Programa: ', vl_jobname, ':', text-002.
  ELSE.
    "Job criado com sucesso.
    WRITE: / 'JOB: ', vl_jobcount, ' - Programa:', vl_jobname, ':', text-003.
  ENDIF.

  WAIT UP TO 1 SECONDS.

ENDFORM.                    "f_cria_job
