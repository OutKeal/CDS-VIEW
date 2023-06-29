@AbapCatalog.sqlViewName: 'ZCDS_GRIR_DIG'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '未清GRIR清单' 
define view ZCDS_GRIR_DIGEST as select from 
ekbe inner join ekko on ekbe.ebeln = ekko.ebeln
inner join ekpo on ekbe.ebeln = ekpo.ebeln and ekbe.ebelp = ekpo.ebelp
{
ekbe.ebeln,
ekbe.ebelp, 
ekko.bsart,
ekko.bedat,
ekko.ekorg,
ekko.bukrs,
ekbe.werks,
ekko.lifnr,
ekpo.matnr,
@EndUserText.label: '含税单价'
division( ekpo.brtwr , ekpo.menge , 2 ) as price,
@EndUserText.label: '采购总数量'
ekpo.menge as menge_po1,
@EndUserText.label: '采购总金额'
ekpo.brtwr as brtwr_po,
@EndUserText.label: '未清数量'
sum( case
when vgabe = '1' and shkzg = 'H' then - ekbe.menge
when vgabe = '1' and shkzg = 'S' then ekbe.menge
when vgabe = '2' and shkzg = 'S' then - ekbe.menge 
when vgabe = '2' and shkzg = 'H' then ekbe.menge
end  ) as quantity,

@EndUserText.label: '未清金额'
sum( case
when vgabe = '1' and shkzg = 'H' then - ekbe.dmbtr
when vgabe = '1' and shkzg = 'S' then ekbe.dmbtr
when vgabe = '2' and shkzg = 'S' then - ekbe.arewr
when vgabe = '2' and shkzg = 'H' then ekbe.arewr
end ) as amount

}

where ( vgabe = '1' or vgabe = '2' )
and ekpo.wepos = 'X'
and ekpo.repos = 'X'
group by
ekbe.ebeln,
ekbe.ebelp,
ekko.bsart,
ekko.bedat,
ekko.ekorg,
ekko.bukrs,
ekbe.werks,
ekko.lifnr,
ekpo.matnr,
ekpo.menge ,
ekpo.brtwr
having
sum( case
when vgabe = '1' and shkzg = 'H' then - ekbe.menge
when vgabe = '1' and shkzg = 'S' then ekbe.menge
when vgabe = '2' and shkzg = 'S' then - ekbe.menge
when vgabe = '2' and shkzg = 'H' then ekbe.menge
end  ) <> 0
