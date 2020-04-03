class ZCO_OA_ERP_CAPITAL_LOGISTIC_SI definition
  public
  inheriting from CL_PROXY_CLIENT
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !LOGICAL_PORT_NAME type PRX_LOGICAL_PORT_NAME optional
    raising
      CX_AI_SYSTEM_FAULT .
  methods OA_ERP_CAPITAL_LOGISTIC_SI
    importing
      !OUTPUT type ZERP_CAPITAL_LOGISTIC_MT
    raising
      CX_AI_SYSTEM_FAULT .
protected section.
private section.
ENDCLASS.



CLASS ZCO_OA_ERP_CAPITAL_LOGISTIC_SI IMPLEMENTATION.


  method CONSTRUCTOR.

  super->constructor(
    class_name          = 'ZCO_OA_ERP_CAPITAL_LOGISTIC_SI'
    logical_port_name   = logical_port_name
  ).

  endmethod.


  method OA_ERP_CAPITAL_LOGISTIC_SI.

  data:
    ls_parmbind type abap_parmbind,
    lt_parmbind type abap_parmbind_tab.

  ls_parmbind-name = 'OUTPUT'.
  ls_parmbind-kind = cl_abap_objectdescr=>importing.
  get reference of OUTPUT into ls_parmbind-value.
  insert ls_parmbind into table lt_parmbind.

  if_proxy_client~execute(
    exporting
      method_name = 'OA_ERP_CAPITAL_LOGISTIC_SI'
    changing
      parmbind_tab = lt_parmbind
  ).

  endmethod.
ENDCLASS.
