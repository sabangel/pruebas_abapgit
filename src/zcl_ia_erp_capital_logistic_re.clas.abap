class ZCL_IA_ERP_CAPITAL_LOGISTIC_RE definition
  public
  create public .

public section.

  interfaces ZII_IA_ERP_CAPITAL_LOGISTIC_RE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IA_ERP_CAPITAL_LOGISTIC_RE IMPLEMENTATION.


  METHOD zii_ia_erp_capital_logistic_re~ia_erp_capital_logistic_return.

    "Declaraciones
    DATA:
      lv_fecha                  TYPE datum,
      lv_pos                    TYPE zpos_factos,
      lv_valor_documento_c      TYPE c LENGTH 50,
      lv_descuento_confirming_c TYPE c LENGTH 50,
      lv_valor_recibo_prov_c    TYPE c LENGTH 50,
      ls_ztfactos_ftp_dat       TYPE ztfactos_ftp_dat,
      ls_linea                  TYPE zerp_capital_logistic_return_f,
      lt_ztfactos_ftp_dat       TYPE TABLE OF ztfactos_ftp_dat,
      lt_tabla                  TYPE zerp_capital_logistic_retu_tab.


    "Obtiene la fecha
    lv_fecha = sy-datum.

    "Crea una copia de los registros
    lt_tabla = input-erp_capital_logistic_return_fi-root-tabla.

    "Elimina el primer registro que es encabezado
    DELETE lt_tabla INDEX 1.

    "Recorre los registros retornados por capital
    LOOP AT lt_tabla INTO ls_linea.
      "Inicializa la estructura de datos
      CLEAR:
        lv_valor_documento_c,
        lv_descuento_confirming_c,
        lv_valor_recibo_prov_c,
        ls_ztfactos_ftp_dat.

      "Aumenta el contador de posiciones
      ADD 1 TO lv_pos.

      "Asigna los datos a la estructura
      SPLIT ls_linea-line
        AT cl_abap_char_utilities=>horizontal_tab
        INTO ls_ztfactos_ftp_dat-nro_documento
             ls_ztfactos_ftp_dat-nit_pagador
             ls_ztfactos_ftp_dat-razon_social_pag
             ls_ztfactos_ftp_dat-nit_tercero
             ls_ztfactos_ftp_dat-razon_social_tercero
             ls_ztfactos_ftp_dat-nueva_fecha_pago
             ls_ztfactos_ftp_dat-fecha_vencimiento
             lv_valor_documento_c
             lv_descuento_confirming_c
             ls_ztfactos_ftp_dat-fecha_pago_comprador
             lv_valor_recibo_prov_c
             ls_ztfactos_ftp_dat-fecha_max_des
             ls_ztfactos_ftp_dat-cod_barras
             ls_ztfactos_ftp_dat-notas
             ls_ztfactos_ftp_dat-status.

      "Elimina el signo pesos de los montos
      REPLACE ALL OCCURRENCES OF '$' IN lv_valor_documento_c      WITH ''.
      REPLACE ALL OCCURRENCES OF '$' IN lv_descuento_confirming_c WITH ''.
      REPLACE ALL OCCURRENCES OF '$' IN lv_valor_recibo_prov_c    WITH ''.
      "Elimina el separador de miles de los montos
      REPLACE ALL OCCURRENCES OF '.' IN lv_valor_documento_c      WITH ''.
      REPLACE ALL OCCURRENCES OF '.' IN lv_descuento_confirming_c WITH ''.
      REPLACE ALL OCCURRENCES OF '.' IN lv_valor_recibo_prov_c    WITH ''.
      "Cambia el separador de miles de coma a punto
      REPLACE ALL OCCURRENCES OF ',' IN lv_valor_documento_c      WITH '.'.
      REPLACE ALL OCCURRENCES OF ',' IN lv_descuento_confirming_c WITH '.'.
      REPLACE ALL OCCURRENCES OF ',' IN lv_valor_recibo_prov_c    WITH '.'.
      "Elimina los espacios
      CONDENSE lv_valor_documento_c      NO-GAPS.
      CONDENSE lv_descuento_confirming_c NO-GAPS.
      CONDENSE lv_valor_recibo_prov_c    NO-GAPS.

      "Asigna los valores numericos
      ls_ztfactos_ftp_dat-valor_documento      = lv_valor_documento_c.
      ls_ztfactos_ftp_dat-descuento_confirming = lv_descuento_confirming_c.
      ls_ztfactos_ftp_dat-valor_recibo_prov    = lv_valor_recibo_prov_c.

      "Asigna la fecha y la posicion
      ls_ztfactos_ftp_dat-fecha = lv_fecha.
      ls_ztfactos_ftp_dat-pos   = lv_pos.

      "Crea el registro en la tabla de datos
      APPEND ls_ztfactos_ftp_dat TO lt_ztfactos_ftp_dat.
    ENDLOOP.

    "Continua solo si se tienen datos
    CHECK NOT lt_ztfactos_ftp_dat IS INITIAL.

    "Crea y/o modifica los registros segun sea el caso
    MODIFY ztfactos_ftp_dat FROM TABLE lt_ztfactos_ftp_dat.

    "Establece los cambios
    COMMIT WORK AND WAIT.


  ENDMETHOD.
ENDCLASS.
