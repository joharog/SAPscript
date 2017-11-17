# zpool-select-single

Add four (4) new fields to show using BSEG table with associated doc number BELNR, society BUKRS and compensation AUGBL, this last one is used to get doc number from invoice header.


**Tips**
- FORM `name` tables intab structure `itcsy` outtab structure `itcsy` \
*Define a subrutine in a program to use in a SAPscript window*

- PERFORM `name` IN PROGRAM `zprogram` \
*Call a subrutine inside SAPscript window*

- USING `&TABLE-VARIABLE&` \
*Pass a variable from SAPscript to program*

``` 
READ TABLE INTAB INDEX 1.
  IF SY-SUBRC = 0.
    VARIABLE = INTAB-VALUE.
    ENDIF.
```
*Must use this statement in program to receive a variable with clause USING, every INDEX n have to be in orden in SAPscript.*
