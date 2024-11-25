REPORT zhrrmusic.

TABLES: zhrtmusic,   "Tabela transparente Z
        sscrfields.  "Tabela transparente standard

DATA: lv_valida      TYPE abap_bool,
      it_zhrtmusic   TYPE TABLE OF zhrtmusic,
      it_final_music TYPE TABLE OF zhrtmusic,
      g_ucomm        TYPE syucomm,
      t_fieldcat     TYPE slis_t_fieldcat_alv,
      s_fieldcat     TYPE slis_fieldcat_alv.

"Tela de seleção
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: p_id     TYPE z_id_ouvinte,
            p_art    TYPE z_artista_pref,
            p_musica TYPE z_music_pref.
SELECTION-SCREEN SKIP.

"Opções na tela de seleção
SELECTION-SCREEN BEGIN OF LINE.
SELECTION-SCREEN: POSITION 1,  PUSHBUTTON (27) but01 USER-COMMAND but01.
SELECTION-SCREEN: POSITION 30, PUSHBUTTON (27) but02 USER-COMMAND but02.
SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK b1.

"INITIALIZATION - Esse comando força a execução de processos antes mesmo de mostrar a tela de seleção
INITIALIZATION.
  LOOP AT SCREEN. "Loop na tela de seleção
    CASE screen-name.
      WHEN 'BUT01'.
        but01 = 'Confirmar envio de dados'. "Troca de BUT01 por 'Confirmar envio de dados'
      WHEN 'BUT02'.
        but02 = 'Mostrar dados já salvos'.  "Troca de BUT02 por 'Mostrar dados já salvos'
    ENDCASE.
  ENDLOOP.

AT SELECTION-SCREEN.

  PERFORM f_monta_saida. "O fieldcat tem que ser montado antes de chamar o display_alv

  IF sscrfields-ucomm EQ 'BUT01'.
    g_ucomm = sscrfields-ucomm.
    sscrfields-ucomm = 'ONLI'. "Vai fingir um F8
  ENDIF.

  IF sscrfields-ucomm EQ 'BUT02'.
    PERFORM f_display_alv.
  ENDIF.

START-OF-SELECTION.

  PERFORM f_valida_dados.
  PERFORM f_grava_dados.
  PERFORM f_mensagem.

FORM f_valida_dados .
  IF p_id IS INITIAL.
    lv_valida = abap_true.
  ENDIF.

  IF p_art IS INITIAL.
    lv_valida = abap_true.
  ENDIF.

  IF p_musica IS INITIAL.
    lv_valida = abap_true.
  ENDIF.
ENDFORM.

FORM f_grava_dados .
  IF lv_valida <> abap_false.
    lv_valida = abap_false.
  ELSE.

    APPEND INITIAL LINE TO it_zhrtmusic ASSIGNING FIELD-SYMBOL(<fs_zhrtmusic>).
    <fs_zhrtmusic>-id_ouvinte   = p_id.
    <fs_zhrtmusic>-artista_pref = p_art.
    <fs_zhrtmusic>-music_pref   = p_musica.

    IF lines( it_zhrtmusic ) > 0.
      MODIFY zhrtmusic FROM TABLE it_zhrtmusic.
    ELSE.
      lv_valida = abap_true.
    ENDIF.
  ENDIF.
ENDFORM.

FORM f_mensagem .
  IF p_id IS NOT INITIAL.
    WRITE 'Dados salvo com sucesso'.
  ELSE.
    WRITE 'Preencha os dados'.
  ENDIF.
ENDFORM.

END-OF-SELECTION.

FORM f_display_alv .
  SELECT *
    INTO TABLE it_final_music
    FROM zhrtmusic.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = t_fieldcat
    TABLES
      t_outtab      = it_final_music
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.
ENDFORM.

FORM f_monta_saida .
  PERFORM f_monta_fieldcat USING 'ID_OUVINTE'    'ID Ouvinte' 0.
  PERFORM f_monta_fieldcat USING 'ARTISTA_PREF'  'Artista Preferido' 1.
  PERFORM f_monta_fieldcat USING 'MUSIC_PREF'    'Música Preferida' 2.
ENDFORM.

FORM f_monta_fieldcat USING i_fname i_ftext i_fpos.
  s_fieldcat-fieldname = i_fname.
  s_fieldcat-seltext_m = i_ftext.
  s_fieldcat-col_pos   = i_fpos.
  APPEND s_fieldcat TO t_fieldcat.

  CLEAR s_fieldcat.
ENDFORM.
