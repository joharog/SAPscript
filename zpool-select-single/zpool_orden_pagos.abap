*&---------------------------------------------------------------------*
*& Pool de subrutin  ZPOOL_ORDEN_PAGOS
*&---------------------------------------------------------------------*

program zpool_orden_pagos.

form busqueda tables intab  structure itcsy
                     outtab structure itcsy.

  tables: bseg, t007a, t007s, t012t, t042z, bkpf.

*///////////////////////////////      INTAB
  data: vp_augbl type bseg-augbl.
  data: vp_bukrs type bseg-bukrs.
  data: vp_belnr type bseg-belnr.

*///////////////////////////////      OUTTAB
  data: vp_text1 type t007s-text1.
  data: vp_text2 type t012t-text1.
  data: vp_text3 type t042z-text1.

*///////////////////////////////      FILTERS
  data: vp_mwskz type bseg-mwskz.
  data: vp_hbkid type bseg-hbkid.
  data: vp_zlsch type bseg-zlsch.
  data: vp_zuonr type bseg-zuonr.

*///////////////////////////////      
  read table intab index 1.
  if sy-subrc = 0.
    vp_augbl = intab-value.
  endif.

  read table intab index 2.
  if sy-subrc = 0.
    vp_bukrs = intab-value.
  endif.

  read table intab index 3.
  if sy-subrc = 0.
    vp_belnr = intab-value.
  endif.

*//////////////////////////////////////////////////////
*Master Query to BSEG
  select single mwskz "AUGBL BELNR BUKRS
    from bseg into vp_mwskz "VP_AUGBL, VP_BELNR, VP_BUKRS,
    where  augbl = vp_augbl and
           belnr = vp_belnr and
           bukrs = vp_bukrs and
           koart = 'K'.

*Tipo de Retencion IVA
  select single text1
    from t007s
    into  vp_text1
    where kalsm = 'ZTAXAR'  and   
          mwskz = vp_mwskz.      

  read table outtab index 1.
  if sy-subrc = 0.
    if vp_text1 is initial.
      outtab-value = ' '.
      modify outtab index 1.
    else.
      outtab-value = vp_text1.    "Tipo de Retencion IVA. (Salida SAPscript)
      modify outtab index 1.
    endif.
  endif.

*Master Query to BSEG-2
  select single hbkid zlsch zuonr
    from bseg into (vp_hbkid, vp_zlsch, vp_zuonr)
    where  augbl = vp_augbl and
           bukrs = vp_bukrs and
           koart = 'K'.

*Banco Debito
  select single text1
    from t012t
    into vp_text2
    where bukrs = vp_bukrs  and
          hbkid = vp_hbkid  and
          spras = 'S'.

  read table outtab index 2.
  if sy-subrc = 0.
    if vp_text2 is initial. "Si vino vacío
      outtab-value = ' '.
      modify outtab index 2.
    else.
      outtab-value = vp_text2.    "Banco Debito. (Salida SAPscript)
      modify outtab index 2.
    endif.
  endif.

*Tipo de Pago
  select single text2
    from t042zt
    into vp_text3
    where land1 = 'AR' and
          spras = 'S'  and
          zlsch = vp_zlsch.

  read table outtab index 3.
  if sy-subrc = 0.
    if vp_text3 is initial.
      outtab-value = ' '.
      modify outtab index 3.
    else.
      outtab-value = vp_text3.    "Tipo de Pago. (Salida SAPscript)
      modify outtab index 3.
    endif.
  endif.

*Número de Cheque
  read table outtab index 4.
  if sy-subrc = 0.
    if vp_zuonr is initial.
      outtab-value = ' '.
      modify outtab index 4.
    else.
      outtab-value = vp_zuonr.    "Número de Cheque. (Salida SAPscript)
      modify outtab index 4.
    endif.
  endif.

endform.           "FIN BUSQUEDA
