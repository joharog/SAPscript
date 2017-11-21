*&---------------------------------------------------------------------*
*& Pool de subrutin  ZPOOL_ORDEN_PAGOS
*&---------------------------------------------------------------------*

program zpool_orden_pagos.

form busqueda tables intab  structure itcsy
                     outtab structure itcsy.

  tables: bseg, t007a, t007s, t012t, t042z, bkpf, skat.

  types: begin of st_bseg,
           bukrs like bseg-bukrs,
           augbl like bseg-augbl,
           ktosl like bseg-ktosl,
           hkont like bseg-hkont,
         end of st_bseg.

  types: begin of st_skat,
           saknr like skat-saknr,
           ktopl like skat-ktopl,
           txt20 like skat-txt20,
         end of st_skat.

  data: ti_bseg type table of st_bseg.
  data: ti_skat type table of st_skat.

  field-symbols: <fs_bseg> type st_bseg,
                 <fs_skat> type st_skat.
               
*///////////////////////////////      INTAB
  data: vp_augbl type bseg-augbl.
  data: vp_bukrs type bseg-bukrs.
  data: vp_belnr type bseg-belnr.

*///////////////////////////////      OUTTAB
  data: vp_text1 type string.
  data: vp_text2 type t012t-text1.
  data: vp_text3 type t042z-text1.

*///////////////////////////////      FILTERS
  data: vp_mwskz type bseg-mwskz.
  data: vp_hbkid type bseg-hbkid.
  data: vp_zlsch type bseg-zlsch.
  data: vp_zuonr type bseg-zuonr.
  data: vp_hkont type bseg-hkont.

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

*///////////////////////////////      RETENCION IVA        
   select bukrs belnr ktosl hkont
    from bseg into table ti_bseg
    where  belnr = vp_augbl and
           bukrs = vp_bukrs and
           ktosl = 'WIT'.

  select saknr ktopl txt20
    from skat
    into table ti_skat
    for all entries in ti_bseg
    where saknr = ti_bseg-hkont.

  loop at ti_bseg assigning <fs_bseg>.
    read table ti_skat assigning <fs_skat> with key saknr = <fs_bseg>-hkont.
    concatenate <fs_skat>-txt20 vp_text1 into vp_text1 separated by space.
  endloop.

  read table outtab index 1.
  if sy-subrc = 0.
    if vp_text1 is initial.
      outtab-value = ' '.
      modify outtab index 1.
    else.
      outtab-value = vp_text1.        (Salida SAPscript)
      modify outtab index 1.
    endif.
  endif.

*///////////////////////////////      MASTER_QUERY 
  select single hbkid zlsch zuonr
    from bseg into (vp_hbkid, vp_zlsch, vp_zuonr)
    where  augbl = vp_augbl and
           bukrs = vp_bukrs and
           koart = 'K'.

*///////////////////////////////      BANCO DEBITO
  select single text1
    from t012t
    into vp_text2
    where bukrs = vp_bukrs  and
          hbkid = vp_hbkid  and
          spras = 'S'.

  read table outtab index 2.
  if sy-subrc = 0.
    if vp_text2 is initial.
      outtab-value = ' '.
      modify outtab index 2.
    else.
      outtab-value = vp_text2.        (Salida SAPscript)
      modify outtab index 2.
    endif.
  endif.

*///////////////////////////////      TIPO DE PAGO
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
      outtab-value = vp_text3.        (Salida SAPscript)
      modify outtab index 3.
    endif.
  endif.

*///////////////////////////////      NUMERO DE CHEQUE
  read table outtab index 4.
  if sy-subrc = 0.
    if vp_zuonr is initial.
      outtab-value = ' '.
      modify outtab index 4.
    else.
      outtab-value = vp_zuonr.        (Salida SAPscript)
      modify outtab index 4.
    endif.
  endif.

endform.           "FIN BUSQUEDA
