/****************************************************************************************************
	Universidad del Rosario - Facultad de Economía
	Proyecto Emprendimiento, desarrollo de capacidades empresariales e inclusión productiva.
	Autores: Paul Rodríguez - María José Pinzón Delgado
    Título: Análisis Tenderos
    Version: Stata 17
 
****************************************************************************************************/
cls
clear all
macro drop _all
set more off

/****************************************************************************************************
Ubicación de las carpetas
****************************************************************************************************/
if "`c(username)'" == "María José" {
	global Directorio "C:\Users\majo7\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
	cd "${Directorio}"
	}

else if "`c(username)'" == "mariajos.pinzon" {
	global Directorio "C:\Users\mariajos.pinzon\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
	cd "${Directorio}"
}

/**************************************************************************************************
Globals para las carpetas
**************************************************************************************************/
*	2.2. Output:
	global Graficas "${Directorio}\reporte censo\01_Graficas\"

*	2.3. Tablas:
	global Tablas "${Directorio}\reporte censo\02_Tablas\"

/**************************************************************************************************
Se abre la base de 2022
**************************************************************************************************/
use "$Directorio\derivedFU\TenderosFU01_FULL.dta", clear

/**************************************************************************************************
Tablas
**************************************************************************************************/
tab Municipio //tabla 1 Municipios incluidos en el ENET
tab consentimiento //tabla 2 ¿Está de acuerdo con participar en el estudio?
tab Educ //tabla 3  ¿Cuál es o fue el nivel de estudios más alto alcanzado?

/**************************************************************************************************
Gráficas
**************************************************************************************************/
**Enlistamiento
tab existenteBaseOriginal
tab existeLocal
graph hbar (mean) actG1 actG2 actG3 actG4 actG5 actG6 actG7 actG8 actG9 actG10 actG11, blabel(bar, format(%4.2f)) legend(order(1 "Tienda" 2 "Comida preparada" 3 "Peluquería y belleza" 4 "Ropa" 5 "Otras variedades" 6 "Papelería y comunicaciones" 7 "Vida nocturna" 8 "Productos bajo inventario" 9 "Salud" 10 "Servicios especializados" 11 "Ferretería y afines")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 01 Tipos de negocios encontrados en el terreno.jpg", replace
tab Tiene_otra_act
tab TipoEdificac
tab Abierto_establecimiento

graph hbar (mean) caracteristicasObs__1 caracteristicasObs__2 caracteristicasObs__3 caracteristicasObs__4 caracteristicasObs__5 caracteristicasObs__6 caracteristicasObs__8 caracteristicasObs__9, blabel(bar, format(%4.2f)) legend(order(1 "Letrero, aviso, o similar, con el nombre del establecimiento" 2 "Máquinas de baloto o servicios de apuestas" 3 "Recarga de celulares o de transporte público, pago de servicios públicos" 4 "Corresponsal bancario" 5 "Diploma visible que acredite formación en la prestación un servicio" 6 "Wi-Fi al público" 7 "Baño público para clientes" 8 "Kit de seguridad visible")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 02 El establecimiento cuenta con.jpg", replace

tab empleadosObs
tab consentimiento

**I. Características socioeconómicas
tab Genero Rol
tab Genero Rol, col
tab Genero Rol, row

preserve
gen genero=Genero
collapse (count) Genero, by(genero Rol)
egen N=total(Genero)
replace Genero=Genero*100/N
format %3.1f Genero
reshape wide Genero, i(Rol) j(genero)
graph hbar (mean) Genero1 Genero2, over(Rol) blabel(bar, format(%4.2f)) legend(order (1 "Mujer" 2 "Hombre")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 03 Género - rol de la persona encuestada.jpg", replace
restore

tab Edad
sum Edad
graph bar (percent), over(Edad, label(labsize(tiny))) scheme(plotplainblind)
graph export "$Graficas\Gráfica 04 Edad.jpg", replace

tab Educ
tab Relac
tab GeneroDuenos
tab EducDuenos
tab Origen

tab CotizaAny_salud
tab CotizaAny_pension

tab CotizaAny_salud CotizaAny_pension

gen SeguridadSocial=.
replace SeguridadSocial=1 if CotizaAny_pension==1 & CotizaAny_salud==1 | CotizaAny_salud==2 | CotizaAny_salud==3
replace SeguridadSocial=1 if CotizaAny_pension==4 & CotizaAny_salud==1 | CotizaAny_salud==2 | CotizaAny_salud==3
replace SeguridadSocial=2 if CotizaAny_salud==4 & CotizaAny_pension==2
replace SeguridadSocial=2 if CotizaAny_salud==4 & CotizaAny_pension==3
replace SeguridadSocial=3 if CotizaAny_pension==2 & CotizaAny_salud==1 | CotizaAny_salud==2 | CotizaAny_salud==3
replace SeguridadSocial=3 if CotizaAny_pension==3 & CotizaAny_salud==1 | CotizaAny_salud==2 | CotizaAny_salud==3
replace SeguridadSocial=4 if CotizaAny_salud==4 & CotizaAny_pension==1
replace SeguridadSocial=4 if CotizaAny_salud==4 & CotizaAny_pension==4
label var SeguridadSocial "¿La persona cotiza a seguridad social?"
label define cotizacion 1 "EPS" 2 "Pension" 3 "Ambos" 4 "Ninguno"
label values SeguridadSocial cotizacion
graph bar (percent), over(SeguridadSocial, label(labsize(small))) scheme(plotplainblind) blabel(bar, format(%3.1f))
graph export "$Graficas/Gráfica 05 Seguridad social.jpg", replace

**II. Situación laboral de emprendimiento
graph hbar (mean) Motivac_Neg__1 Motivac_Neg__2 Motivac_Neg__4 Motivac_Neg__5 Motivac_Neg__6 Motivac_Neg__7 Motivac_Neg__8 Motivac_Neg__12, blabel(bar, format(%4.2f)) legend(order(1 "Tradición familiar / herencia" 2 "No logró encontrar trabajo como asalariado" 3 "Para obtener mayores ingresos" 4 "Encontró una oportunidad en el mercado" 5 "Tiene mayor flexibilidad" 6 "Tomar sus propias decisiones / ser su propio jefe" 7 "Deseaba organizar su propia empresa" 8 "Otra")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 06 Razones o motivaciones para iniciar negocio.jpg", replace

graph hbar (mean) Financ_Negoc__1 Financ_Negoc__2 Financ_Negoc__5 Financ_Negoc__7 Financ_Negoc__8 Financ_Negoc__10, blabel(bar, format(%4.2f)) legend(order(1 "Ahorros o recursos propios" 2 "Préstamo o crédito bancario" 3 "Programa de Gobierno" 4 "Préstamo de amigos o parientes" 5 "Con prestamista particular o gota a gota" 6 "Otro")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 07 Cómo se financió para el inicio del negocio.jpg", replace

tab Inicio_Negoc_Mes
tab Inicio_Negoc_Ano
tab Asalariado_Obrero
tab exper_previa
tab Dueno_Antes

**III. Activos y lugar de trabajo
graph bar (mean) Renovacion__1 Renovacion__2 Renovacion__3, blabel(bar, format(%4.2f)) legend(order(1 "Pintar el local" 2 "Cambio de muebles u otros interiores" 3 "Otro")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 08 Ha realizado renovación en el negocio.jpg", replace

tab activo_pos
tab activo_pos_cual
tab activos_valor

*IV. TICS
graph bar (mean) activo_internet__1 activo_internet__2 activo_internet__3 activo_internet__4 activo_internet__0, blabel(bar, format(%4.2f)) legend(order (1 "Sí, celular o tableta Android" 2 "Sí, Iphone, Ipad" 3 "Sí, Computador" 4 "No, hay equipos informáticos, pero no se usan para el negocio" 5 "No, no hay equipos")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 09 Equipos para uso del negocio.jpg", replace

tab uso_internet
graph bar (mean) no_uso_internet__1 no_uso_internet__2 no_uso_internet__3 no_uso_internet__4, blabel(bar, format(%4.2f)) legend(order (1 "No es necesario por el tamaño o tipo de su negocio" 2 "No sabe cómo utilizar internet" 3 "No tiene los recursos para contratar internet" 4 "No tiene computador/notebook/tablet/smartphone")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 10 Razones para no utilizar internet en su empresa.jpg", replace

tab porcent_ventas_internet
tab uso_internet_abierta
graph hbar (mean) usos_internet__1 usos_internet__2 usos_internet__3 usos_internet__4 usos_internet__6 usos_internet__7 usos_internet__11 usos_internet__12 usos_internet__13 usos_internet__14 usos_internet__15 usos_internet__10, blabel(bar, format(%4.2f)) legend(order (1 "Relacionarse con sus clientes" 2 "Obtener información relacionada al negocio" 3 "Promocionar su empresa en redes sociales" 4 "Relacionarse con sus proveedores" 5 "Recibir pagos" 6 "Realizar trámites en bancos o con el Gobierno" 7 "Seguridad y vigilancia" 8 "Poner y programar música y videos" 9 "Vida social" 10 "Para el uso personal de los clientes" 11 "Hacer recargas" 12 "Otro")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 11 Usos que le da al internet.jpg", replace

graph bar (mean) presencia_internet__1 presencia_internet__2 presencia_internet__3 presencia_internet__4 presencia_internet__5 presencia_internet__6, blabel(bar, format(%4.2f)) legend(order (1 "Página web propia" 2 "Página web con opción de carrito de compras" 3 "Línea Whatsapp" 4 "Página Facebook" 5 "Página Instragram" 6 "Registro en Google Maps")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 12 Qué características tiene su negocio.jpg", replace

tab internet_covid
tab uso_internet_comparado

*V. Relación con el sistema financiero
graph hbar (mean) Finan_Gastos__1 Finan_Gastos__2 Finan_Gastos__4 Finan_Gastos__7 Finan_Gastos__9 Finan_Gastos__10 Finan_Gastos__11 Finan_Gastos__12, blabel(bar, format(%4.2f)) legend(order (1 "Ahorros o recursos propios" 2 "Ganancias del negocio" 3 "Préstamos o créditos bancario con el sistema" 4 "Programas del Gobierno" 5 "Préstamo de amigos o parientes" 6 "Con prestamista particular, casa de empeño o gota a gota" 7 "No requiere capital para operar su negocio" 8 "Otro")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 13 Cómo se financian actualmente los gastos regulares del negocio.jpg", replace

tab Solic_Credito
tab Solic_Credito Rol
graph hbar (count), over(Solic_Credito) by(Rol, total) scheme(plotplainblind)

preserve
gen credito=Solic_Credito
collapse (count) Solic_Credito, by(Rol credito)
egen N=total(Solic_Credito)
replace Solic_Credito=Solic_Credito*100/N
format %3.1f Solic_Credito
replace credito=0 if credito==.
reshape wide Solic_Credito, i(Rol) j(credito)
graph hbar (mean) Solic_Credito1 Solic_Credito2 Solic_Credito3, over(Rol) blabel(bar, format(%4.2f)) legend(order (1 "Sí" 2 "No" 3 "No sabe")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 14 Ha solicitado préstamo en los últimos 12 meses.jpg", replace
restore

graph hbar (mean) Razon_No_Cred__1 Razon_No_Cred__2 Razon_No_Cred__3 Razon_No_Cred__4 Razon_No_Cred__5 Razon_No_Cred__6 Razon_No_Cred__7 Razon_No_Cred__8 Razon_No_Cred__9 Razon_No_Cred__10, blabel(bar, format(%4.2f)) legend(order (1 "No lo necesita" 2 "No sabe dónde acudir" 3 "Desconoce el procedimiento para solicitarlo" 4 "No le gusta pedir préstamos /créditos" 5 "Los intereses y comisiones son muy altos" 6 "No se lo otorgarían" 7 "No confía en las instituciones financieras" 8 "No entiende las condiciones asociadas a un crédito" 9 "Está reportado en Centrales de Riesgo" 10 "Otra")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 15 Por qué razón o razones no se ha solicitado un crédito.jpg", replace

tab Pres_Bancario
tab Amigos_Prestamo
tab Pres_Partic_Cred
tab Cuent_Separad
tab Porcent_Ahorr

graph bar (mean) Calamidad__1 Calamidad__2 Calamidad__3 Calamidad__4 Calamidad__5 Calamidad__7 Calamidad__6, blabel(bar, format(%4.2f)) legend(order (1 "Vendería activos/propiedades" 2 "Buscaría un préstamo informal" 3 "Buscaría un préstamo con un banco / cooperativa" 4 "Recurriría a la ayuda de mis amigos o familia" 5 "Usaría un producto de seguro/protección" 6 "Ahorros" 7 "Otro")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 16 En caso de tener una emergencia o calamidad doméstica - usted y su familia qué harían.jpg", replace

tab Seguro_Familia
tab Elec_Wallet_Knowledge
tab Elec_Wallet_Uso

*graph bar (count), over(Elec_Wallet_Knowledge) scheme(plotplainblind)
*graph export "$Graficas/Gráfica 19 ¿Conoce las billeteras virtuales?.jpg", replace

graph hbar (mean) Elec_Wallet_Cual__1 Elec_Wallet_Cual__2 Elec_Wallet_Cual__3 Elec_Wallet_Cual__4 Elec_Wallet_Cual__5 Elec_Wallet_Cual__6 Elec_Wallet_Cual__7 Elec_Wallet_Cual__8 Elec_Wallet_Cual__9, blabel(bar, format(%4.2f)) legend(order (1 "Daviplata" 2 "Nequi" 3 "Tpaga" 4 "MOVII" 5 "Powwi" 6 "Rappipay" 7 "Tuya (Éxito y Carulla)" 8 "BBVA Wallet" 9 "Otra")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 17 Cuáles de las siguientes billeteras electrónicas ha utilizado.jpg", replace

tab Opinion_Pago_Digital

recode s12p10 (1=1) (2=2) (3=3) (4 5 6=4)
label define estrato 1 "1" 2 "2" 3 "3" 4 "4, 5 y 6", replace
label values s12p10 estrato

preserve
recode hipoteticaFunding__1 hipoteticaFunding__2 hipoteticaFunding__3 hipoteticaFunding__4 hipoteticaFunding__5 hipoteticaFunding__6 (1=1) (2 3 4 5 6=0)
graph bar (mean) hipoteticaFunding__1 hipoteticaFunding__2 hipoteticaFunding__3 hipoteticaFunding__4 hipoteticaFunding__5 hipoteticaFunding__6, blabel(bar, format(%4.2f)) legend(order (1 "Iría a buscar a otro banco o cooperativa de ahorro" 2 "Realizar una inversión más pequeña" 3 "Ofrecería a los trabajadores ser parte del negocio si ponen recursos" 4 "Pospone la inversión" 5 "Le pide dinero a un prestamista, gota-a-gota, casa de empeño" 6 "Le pide dinero a la familia")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 18 Si el banco o cooperativa le cambia las reglas de juego.jpg", replace
restore

*VI. Grado de formalidad de la actividad económica
tab Regist_Cuentas
graph bar (percent), over(Regist_Cuentas, label(labsize(small))) scheme(plotplainblind) blabel(bar, format(%3.1f))
graph export "$Graficas\Gráfica 19 Registro de cuentas.jpg", replace
tab Separar_Gastos
tab contador
tab Regist_Mercantil
tab Regist_Mercantil_Inic
tab Ano_Regis_Mercantil

graph bar (percent), over(Regist_Mercantil) scheme(plotplainblind) blabel(bar, format(%3.1f))
graph export "$Graficas\Gráfica 20 Registro Mercantil.jpg", replace

tab Permiso_Funcion
tab Perm_Munic
tab Permis_Renov
tab Razon_No_Obt_Perm

tab RUT
graph hbar (percent), over(RUT) scheme(plotplainblind) blabel(bar, format(%3.1f))
graph export "$Graficas/Gráfica 21 RUT.jpg", replace
tab RUT IVA, row
tab IVA

preserve
replace IVA=3 if RUT==4 | RUT==5 | RUT==6
gen regimen=IVA
collapse (count) IVA, by(regimen RUT)
egen N=total(IVA)
replace IVA=IVA*100/N
format %3.1f IVA
reshape wide IVA, i(RUT) j(regimen)
graph hbar (mean) IVA1 IVA2 IVA3, over(RUT) blabel(bar, format(%4.2f)) legend(order (1 "Régimen simplificado" 2 "Régimen común" 3 "Sin RUT")) title(Tipo de régimen) scheme(plotplainblind)
graph export "$Graficas/Gráfica 22 Tipo de régimen.jpg", replace
restore

tab conocimientoRenovacionRUT
tab Regis_DIAN
tab Regis_DIAN conocimientoRenovacionRUT
tab Inicio_DIAN

graph bar (mean) Tramites__1 Tramites__2 Tramites__3 Tramites__4 Tramites__5, blabel(bar, format(%4.2f)) legend(order (1 "Declaración de IVA" 2 "Declaración de impuesto a la renta" 3 "Declaración impuestos municipales/distritales" 4 "Permisos sanitarios que den a lugar" 5 "Otros")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 23 Ha realizado o está realizando algún trámites en los últimos dos años.jpg", replace

tab Razon_No_Regis
tab Factura
tab Factura IVA
tab Fact_Elec
tab Factura Fact_Elec
tab Conoc_Formul
tab Usado_Formul

graph bar (mean) inspeccion__1 inspeccion__2 inspeccion__3 inspeccion__4 inspeccion__5 inspeccion__6 inspeccion__7, blabel(bar, format(%4.2f)) legend(order (1 "De la Secretaría de Salud" 2 "De la DIAN u otra autoridad de impuestos" 3 "Inspectores de Trabajo y Seguridad Social" 4 "Superintendencia de Comercio, Sayco Acinpro" 5 "Alcaldía local para verificar balanzas, medidores" 6 "Otro" 7 "Ninguno")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 24 Ha recibido visita inspector de gobierno.jpg", replace

tab Otro_inspeccion
tab self_reported_formal

*VII. Capacitación y expertienda
tab Capac
graph hbar (mean) Capac_Import__1 Capac_Import__2 Capac_Import__3 Capac_Import__4 Capac_Import__5 Capac_Import__6 Capac_Import__7 Capac_Import__8 Capac_Import__9, blabel(bar, format(%4.2f)) legend(order (1 "Gestión y Administración" 2 "Finanzas / Contabilidad" 3 "Innovación" 4 "Actualizaciones o especializaciones en el área que trabaja" 5 "Idiomas" 6 "Ventas / Marketing / Comercialización / Atención a público" 7 "Tecnologías / Computación / Informática" 8 "Seguridad / Prevención de Riesgo / Higiene Industrial" 9 "Otra")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 25 En qué área realizó su última capacitación.jpg", replace

graph hbar (mean) Capac_Ning__1 Capac_Ning__2 Capac_Ning__3 Capac_Ning__4 Capac_Ning__5 Capac_Ning__6 Capac_Ning__7, blabel(bar, format(%4.2f)) legend(order (1 "No me interesa" 2 "No hay un curso adecuado a mis necesidades" 3 "El programa era muy caro" 4 "Los cursos toman mucho tiempo" 5 "El horario no me acomodaba" 6 "No sé dónde acudir" 7 "Otro")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 26 Por qué no ha recibido ninguna capacitación.jpg", replace

tab Capac_Interes
tab expertienda

graph bar (mean) expertienda_quien__1 expertienda_quien__2 expertienda_quien__3, blabel(bar, format(%4.2f)) legend(order (1 "Alguien enviado por Fundación Capital, mediante visita o llamada" 2 "Alguien enviado por la UNIMINUTO o la Universidad del Rosario" 3 "Un vecino o amigo")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 27 Quién le dio a conocer esta aplicación.jpg", replace

tab expertienda2

*VIII. Características de la empresa, negocio o actividad por cuenta propia
tab horas
tab horas Rol
gen horas_semanales=horas
recode horas_semanales (1 2 3 4 5 6 7 8 = "1") (9 10 11 12 13 14 15 16 = "2") (17 18 19 20 21 22 23 24 = "3") (25 26 27 28 29 30 31 32 = "4") (33 34 35 36 37 38 39 40 = "5") (41 42 43 44 45 46 47 48 = "6") (49 50 51 52 53 54 55 56 = "7") (57 58 59 60 61 62 62 63 64 = "8") (65 66 67 68 69 70 71 72 = "9") (73 74 75 76 77 78 79 80 = "10") (81 82 83 84 85 86 87 88 = "11")
label define horas 1 "1 a 8 horas" 2 "9 a 16 horas" 3 "17 a 24 horas" 4 "25 a 32 horas" 5 "33 a 40 horas" 6 "41 a 48 horas" 7 "49 a 56 horas" 8 "57 a 64 horas" 9 "65 a 72 horas" 10 "73 a 80 horas" 11 "más de 81 horas"
label values horas_semanales horas
tab horas_semanales
tab horas_semanales Rol
tab horas_semanales Rol, col nof
tab eleccionhoras
tab Negoc_Funci

graph hbar (mean) medios_pago__3 medios_pago__2 medios_pago__1 medios_pago__10 medios_pago__8 medios_pago__5 medios_pago__4 medios_pago__9, blabel(bar, format(%4.2f)) legend(order (1 "Pago en efectivo" 2 "Tarjeta de débito con datáfono" 3 "Tarjetas de crédito con datáfono" 4 "Billeteras electrónicas o aplicaciones de un banco" 5 "Pagos con un link por internet" 6 "Giros no bancarios" 7 "Transferencia bancaria o consignaciones en físico")) scheme(plotplainblind)
graph export "$Graficas\Gráfica 28 Qué medios de pago se aceptan en su negocio.jpg", replace

tab Ubicac_Negoc
tab ajustesNecesarios

*IX. Empleo y Covid
tab Sueldo
tab Trabaj_Numero
label val Trabaj_Numero
graph bar (percent), over(Trabaj_Numero) scheme(plotplainblind) blabel(bar, format(%3.1f))
graph export "$Graficas\Gráfica 29 Número de trabajadores.jpg", replace
tab Trabaj_Numero Sueldo

graph bar (mean) tipoTrabajadores__1 tipoTrabajadores__2 tipoTrabajadores__3 tipoTrabajadores__4 tipoTrabajadores__5, blabel(bar, format(%4.2f)) legend(order(1 "Trabajadores remunerados" 2 "Socios trabajadores" 3 "Familiares no remunerados" 4 "Trabajador temporal u ocasional" 5 "Trabajadores aprendices o en formación")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 30 Tipos de trabajadores.jpg", replace

tab Trabaj_Sueldos
tab Trabaj_Minimo
tab Salud_Pens_Pago
tab cuantos_extranjeros
tab Mas_Trabaj
tab Pago_Creenc
tab covid

graph hbar (mean) covid2__1 covid2__2 covid2__3 covid2__4 covid2__5 covid2__6 covid2__7 covid2__8, blabel(bar, format(%4.2f)) legend(order(1 "Cierre total del negocio anterior" 2 "Muerte o incapacidad de familiares, empleados, clientes importantes" 3 "Cierre temporal del negocio" 4 "Traslado del negocio de un local a otro" 5 "Creación del negocio debido a pérdida de empleo" 6 "Creación del negocio debido a una oportunidad de negocio" 7 "Despido de empleados que llevaban mucho tiempo laborand" 8 "Otra"))  scheme(plotplainblind)
graph export "$Graficas/Gráfica 31 Afectación debido a COVID-19.jpg", replace

tab covid_cambios
tab Covid_AfectacionSubjetiva
tab Covid_Creen_Cierre

*X. Finalización de la encuesta
tab cuantos2_conoc


*limitaciones de crecimiento
graph hbar (mean) falta_clientes falta_insumos falta_financiamiento falta_trabajadores alto_costo_contratacion alto_costo_regulacion altos_impuestos criminalidad incertidumbre_economia competencia_desleal, blabel(bar, format(%4.2f)) legend(order(1 "Falta de clientes" 2 "Falta de insumos" 3 "Falta de financiamiento" 4 "Falta de trabajadores capacitados" 5 "Altos costos de contratar nuevos empleados" 6 "Altos costos de las regulaciones  normas legales" 7 "Altas tasas de impuestos" 8 "Criminalidad" 9 "Incertidumbre sobre el estado de la economía" 10 "Competencia por parte de negocios que no pagan impuestos")) title(Limitaciones de crecimiento) scheme(plotplainblind)

/**************************************************************************************************
Ola 1 y 2
**************************************************************************************************/
gen tiempo=2
append using "$Directorio\derivedBL\Tenderos00_Censo.dta", force

replace tiempo=1 if tiempo==.
label var tiempo "Tiempo al que pertenece la encuesta"
label define time 1 "Ola 1 (2019)" 2 "Ola 2 (2022)"
label values tiempo time

gen tipo_negocio = 1 if Trabaj_Numero == 0 //cuenta propia
replace tipo_negocio = 2 if Trabaj_Numero>0 & Trabaj_Numero<10 //microempresa
replace tipo_negocio = 3 if Trabaj_Numero>=10 //otras (mediana)
label define tipo_negocio 1 "Cuenta propia" 2 "Microempresa" 3 "Otro"
label values tipo_negocio tipo_negocio

*ytitle(Porcentaje)

**uso de tics y medios electrónicos de pago.
preserve
gen año=tiempo
collapse (count) año, by(RUT tiempo)
drop if RUT==.
egen N=total(año), by(tiempo)
replace año=año*100/N
format %3.1f año
drop N
reshape wide año, i(RUT) j(tiempo)
graph hbar (mean) año1 año2, over(RUT) blabel(bar, format(%3.1f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind) xsize(7)
graph export "$Graficas/Gráfica 32 el negocio está registrado con la DIAN por ola.jpg", replace
restore
tab RUT tiempo, col

preserve
gen año=tiempo
gen internet=usos_internet__1
collapse (count) año (sum) usos_internet__1 usos_internet__2 usos_internet__3 usos_internet__4 usos_internet__6 usos_internet__7 usos_internet__11 usos_internet__12 usos_internet__13 usos_internet__14 usos_internet__15 usos_internet__10, by(tiempo internet)
drop if internet==.
egen N=total(año), by(tiempo)
foreach var of varlist usos_internet__1 usos_internet__2 usos_internet__3 usos_internet__4 usos_internet__6 usos_internet__7 usos_internet__11 usos_internet__12 usos_internet__13 usos_internet__14 usos_internet__15 usos_internet__10 {
	replace `var' = `var'*100/N
	format %3.1f `var'
}
collapse (mean) N (sum) usos_internet__1 usos_internet__2 usos_internet__3 usos_internet__4 usos_internet__6 usos_internet__7 usos_internet__11 usos_internet__12 usos_internet__13 usos_internet__14 usos_internet__15 usos_internet__10, by(tiempo)
gen año=tiempo
reshape long usos_internet__, i(año) j(internet)
drop año N
reshape wide usos_internet__, i(internet) j(tiempo)

graph hbar (mean) usos_internet__1 usos_internet__2, over(internet) blabel(bar, format(%3.1f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 33 Usos que le dan al internet por ola.jpg", replace
restore


preserve
gen año=tiempo
collapse (count) año, by(Elec_Wallet_Knowledge tiempo)
drop if Elec_Wallet_Knowledge==.
egen N=total(año), by(tiempo)
replace año=año*100/N
format %3.1f año
drop N
reshape wide año, i(Elec_Wallet_Knowledge) j(tiempo)
graph hbar (mean) año1 año2, over(Elec_Wallet_Knowledge) blabel(bar, format(%3.1f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 34 Conoce las  billeteras electrónicas por ola.jpg", replace
restore
tab Elec_Wallet_Knowledge tiempo, col

preserve
gen año=tiempo
collapse (count) año, by(Elec_Wallet_Uso tiempo)
drop if Elec_Wallet_Uso==.
egen N=total(año), by(tiempo)
replace año=año*100/N
format %3.1f año
drop N
reshape wide año, i(Elec_Wallet_Uso) j(tiempo)
graph hbar (mean) año1 año2, over(Elec_Wallet_Uso) blabel(bar, format(%3.1f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 35 Ha usado las billeteras electrónicas por ola.jpg", replace
restore
tab Elec_Wallet_Uso tiempo, col

preserve
gen copia=medios_pago__10
replace medios_pago__10=1 if medios_pago__8==1
replace medios_pago__10=0 if medios_pago__8==0 & tiempo==1 & copia==.
graph hbar (mean) medios_pago__3 medios_pago__2 medios_pago__1 medios_pago__10 medios_pago__5 medios_pago__4 medios_pago__9, blabel(bar, format(%4.2f)) legend(order (1 "Pago en efectivo" 2 "Tarjeta de débito con datáfono" 3 "Tarjetas de crédito con datáfono" 4 "Billeteras electrónicas o pagos por internet" 5 "Giros no bancarios" 6 "Transferencia bancaria o consignaciones en físico") cols(2)) scheme(plotplainblind) by(tiempo) //medios de pago que aceptan
graph export "$Graficas/Gráfica 36 Medios de pago que se aceptan en los negocios por ola.jpg", replace
restore


porcent_ventas_internet //ventas por internet
tw (kdensity porcent_ventas_internet if tiempo==1) (kdensity porcent_ventas_internet if tiempo==2) // densidad porcentaje de ventas

preserve
gen ventasint=porcent_ventas_internet
collapse (count) ventasint, by(porcent_ventas_internet tiempo)
drop if porcent_ventas_internet==.
egen N=total(ventasint), by(tiempo)
replace ventasint=ventasint*100/N
format %3.1f ventasint
drop N
reshape wide ventasint, i(porcent_ventas_internet) j(tiempo)
graph bar ventasint1 ventasint2, over(porcent_ventas_internet) blabel(bar, format(%3.1f) size(vsmall)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
graph export "$Graficas/Gráfica 37 porcentaje de ventas por internet por ola.jpg", replace
restore

/**************************************************************************************************
Conocimiento de negocio - índice de prácticas de negocios
**************************************************************************************************/
*(1) Índice de diez prácticas de Finanzas y Contabilidad
gen registro_cuentas = 1 if Regist_Cuentas == 1
replace registro_cuentas = 0.5 if  Regist_Cuentas == 2
replace registro_cuentas = 0 if  Regist_Cuentas == 3
label var registro_cuentas "¿Lleva algún tipo de registro de las cuentas de su negocio, empresa o actividad por cuenta propia"
gen contabilizar_POS = 1 if activo_pos == 2
replace contabilizar_POS = 0.5 if activo_pos == 1
replace contabilizar_POS = 0 if activo_pos == 3
label var contabilizar_POS "¿Este negocio tiene algún sistema informático para contabilizar las ventas diarias (POS)?"
egen Indice_Finanzas_Contabilidad = rowmean (registro_cuentas plan_financiero3 plan_financiero4 plan_financiero2 contabilizar_POS ventas_compras6 plan_financiero1)
label var Indice_Finanzas_Contabilidad "Índice de diez prácticas de Finanzas y Contabilidad"
*(2) Índice de nueve prácticas de Marketing y Ventas
egen Indice_Marketing_Ventas = rowmean (comercializacion3 comercializacion1 comercializacion4 comercializacion6 inventario2 comercializacion5 comercializacion2 Comp_Knowl)
label var Indice_Marketing_Ventas "Índice de nueve prácticas de Marketing y Ventas"
*(3) Índice de once prácticas de Operaciones y RRHH
egen Indice_Operaciones_RHHH = rowmean (Elec_Wallet_Uso inventario2 inventario4 Capac)
label var Indice_Operaciones_RHHH "Índice de once prácticas de Operaciones y RRHH"
*(4) Índice del subconjunto de prácticas comerciales a menudo "verificables"
*No habían variables que se ajustaran a los indicadores del índice
*(5) Índice de once Prácticas verificadas de Marketing Digital
egen Indice_Marketing_Digital = rowmean (presencia_internet__1 presencia_internet__2 presencia_internet__4 presencia_internet__5 presencia_internet__3)
label var Indice_Marketing_Digital "Índice de once Prácticas verificadas de Marketing Digital"
*Índice de prácticas de negocios
egen Indice_Practicas_Negocios = rowmean (Indice_Finanzas_Contabilidad Indice_Marketing_Ventas Indice_Operaciones_RHHH Indice_Marketing_Digital)
label var Indice_Practicas_Negocios "Índice general de Prácticas de Negocios"

sum Indice_Finanzas_Contabilidad registro_cuentas plan_financiero3 plan_financiero4 plan_financiero2 contabilizar_POS ventas_compras6 plan_financiero1
sum Indice_Marketing_Ventas comercializacion3 comercializacion1 comercializacion4 comercializacion6 inventario2 comercializacion5 comercializacion2 Comp_Knowl
sum Indice_Operaciones_RHHH Elec_Wallet_Uso inventario2 inventario4 Capac
sum Indice_Marketing_Digital presencia_internet__1 presencia_internet__2 presencia_internet__4 presencia_internet__5 presencia_internet__3

*Ola 1
preserve
drop if tipo_negocio == 3
drop if tiempo == 2
sum Indice_Practicas_Negocios Indice_Finanzas_Contabilidad Indice_Marketing_Ventas Indice_Operaciones_RHHH Indice_Marketing_Digital
ttest Indice_Practicas_Negocios, by(tipo_negocio)
ttest Indice_Finanzas_Contabilidad, by(tipo_negocio)
ttest Indice_Marketing_Ventas, by(tipo_negocio)
ttest Indice_Operaciones_RHHH, by(tipo_negocio)
ttest Indice_Marketing_Digital, by(tipo_negocio)
restore

*Ola 2
preserve
drop if tipo_negocio == 3
drop if tiempo == 1
sum Indice_Practicas_Negocios Indice_Finanzas_Contabilidad Indice_Marketing_Ventas Indice_Operaciones_RHHH Indice_Marketing_Digital
ttest Indice_Practicas_Negocios, by(tipo_negocio)
ttest Indice_Finanzas_Contabilidad, by(tipo_negocio)
ttest Indice_Marketing_Ventas, by(tipo_negocio)
ttest Indice_Operaciones_RHHH, by(tipo_negocio)
ttest Indice_Marketing_Digital, by(tipo_negocio)
restore

/**************************************************************************************************
Prácticas gerenciales
**************************************************************************************************/
sum comercializacion1 comercializacion2 comercializacion3 comercializacion4 comercializacion5 comercializacion6 comercializacion7 comercializacion8 comercializacion9 inventario1 inventario2 inventario3 inventario4 ventas_compras1 ventas_compras2 ventas_compras3 ventas_compras4 ventas_compras5 ventas_compras6 ventas_compras7 ventas_compras8 ventas_compras9 plan_financiero1 plan_financiero2 plan_financiero3 plan_financiero4 plan_financiero5 comunicacion1 comunicacion2 comunicacion3 comunicacion4

egen Prácticas_Gerenciales = rowmean (comercializacion1 comercializacion2 comercializacion3 comercializacion4 comercializacion5 comercializacion6 comercializacion7 comercializacion8 comercializacion9 inventario1 inventario2 inventario3 inventario4 ventas_compras1 ventas_compras2 ventas_compras3 ventas_compras4 ventas_compras5 ventas_compras6 ventas_compras7 ventas_compras8 ventas_compras9 plan_financiero1 plan_financiero2 plan_financiero3 plan_financiero4 plan_financiero5 comunicacion1 comunicacion2 comunicacion3 comunicacion4) //por las 31 variables
label var Prácticas_Gerenciales "rowmean Prácticas Gerenciales"

egen Comercialización = rowmean (comercializacion1 comercializacion2 comercializacion3 comercializacion4 comercializacion5 comercializacion6 comercializacion7 comercializacion8 comercializacion9)
label var Comercialización "rowmean Comercialización"

egen Inventario = rowmean (inventario1 inventario2 inventario3 inventario4)
label var Inventario "rowmean Inventario"

egen Ventas_Compras = rowmean (ventas_compras1 ventas_compras2 ventas_compras3 ventas_compras4 ventas_compras5 ventas_compras6 ventas_compras7 ventas_compras8 ventas_compras9)
label var Ventas_Compras "rowmean ventas compras"

egen Plan_Financiero = rowmean (plan_financiero1 plan_financiero2 plan_financiero3 plan_financiero4 plan_financiero5)
label var Plan_Financiero "rowmean Plan Financiero"

egen Comunicación = rowmean (comunicacion1 comunicacion2 comunicacion3 comunicacion4)
label var Comunicación "rowmean Comunicación"

sum Comercialización comercializacion1 comercializacion2 comercializacion3 comercializacion4 comercializacion5 comercializacion6 comercializacion7 comercializacion8 comercializacion9
sum Inventario inventario1 inventario2 inventario3 inventario4
sum Ventas_Compras ventas_compras1 ventas_compras2 ventas_compras3 ventas_compras4 ventas_compras5 ventas_compras6 ventas_compras7 ventas_compras8 ventas_compras9
sum Plan_Financiero plan_financiero1 plan_financiero2 plan_financiero3 plan_financiero4 plan_financiero5
sum Comunicación comunicacion1 comunicacion2 comunicacion3 comunicacion4

graph hbar (mean) Comercialización Inventario Ventas_Compras Plan_Financiero Comunicación, blabel(bar, format(%4.2f)) legend(order(1 "Comercialización" 2 "Inventario" 3 "Ventas y compras" 4 "Plan financiero" 5 "Comunicación" )) scheme(plotplainblind)

*Ola 1
preserve
drop if tipo_negocio == 3
drop if tiempo == 2
sum Prácticas_Gerenciales Comercialización Inventario Ventas_Compras Plan_Financiero Comunicación
ttest Prácticas_Gerenciales, by(tipo_negocio)
ttest Comercialización, by(tipo_negocio)
ttest Inventario, by(tipo_negocio)
ttest Ventas_Compras, by(tipo_negocio)
ttest Plan_Financiero, by(tipo_negocio)
ttest Comunicación, by(tipo_negocio)
restore

*Ola 2
preserve
drop if tipo_negocio == 3
drop if tiempo == 1
sum Prácticas_Gerenciales Comercialización Inventario Ventas_Compras Plan_Financiero Comunicación
ttest Prácticas_Gerenciales, by(tipo_negocio)
ttest Comercialización, by(tipo_negocio)
ttest Inventario, by(tipo_negocio)
ttest Ventas_Compras, by(tipo_negocio)
ttest Plan_Financiero, by(tipo_negocio)
ttest Comunicación, by(tipo_negocio)
restore

*hist Prácticas_Gerenciales, bin(30)  //Gráfica general
sum  Prácticas_Gerenciales
hist Prácticas_Gerenciales, w(.1) xline(0.556) percent
hist Prácticas_Gerenciales, w(.1) xline(0.556) percent by (tipo_negocio)
hist Comercialización, w(.1) percent
hist Inventario, w(.1) percent
hist Ventas_Compras, w(.1) percent
hist Plan_Financiero, w(.1) percent
hist Comunicación, w(.1) percent

/**************************************************************************************************
Percepción de actitudes hacia el emprendimiento
**************************************************************************************************/
sum acuerdo_ciudad_emprendimiento acuerdo_gobierno_emprendimiento acuerdo_nacional_emprendimiento acuerdo_reclamolegal acuerdo_denuncia acuerdo_empezar acuerdo_confianza

preserve
drop if tipo_negocio == 3
ttest acuerdo_ciudad_emprendimiento, by(tipo_negocio)
ttest acuerdo_gobierno_emprendimiento, by(tipo_negocio)
ttest acuerdo_nacional_emprendimiento, by(tipo_negocio)
ttest acuerdo_reclamolegal, by(tipo_negocio)
ttest acuerdo_denuncia, by(tipo_negocio)
ttest acuerdo_empezar, by(tipo_negocio)
ttest acuerdo_confianza, by(tipo_negocio)
restore

*Ola 1
preserve
drop if tipo_negocio == 3
drop if tiempo == 2
sum acuerdo_ciudad_emprendimiento acuerdo_gobierno_emprendimiento acuerdo_nacional_emprendimiento acuerdo_reclamolegal acuerdo_denuncia acuerdo_empezar acuerdo_confianza
ttest acuerdo_ciudad_emprendimiento, by(tipo_negocio)
ttest acuerdo_gobierno_emprendimiento, by(tipo_negocio)
ttest acuerdo_nacional_emprendimiento, by(tipo_negocio)
ttest acuerdo_reclamolegal, by(tipo_negocio)
ttest acuerdo_denuncia, by(tipo_negocio)
ttest acuerdo_empezar, by(tipo_negocio)
ttest acuerdo_confianza, by(tipo_negocio)
restore

*Ola 2
preserve
drop if tipo_negocio == 3
drop if tiempo == 1
sum acuerdo_ciudad_emprendimiento acuerdo_gobierno_emprendimiento acuerdo_nacional_emprendimiento acuerdo_reclamolegal acuerdo_denuncia acuerdo_empezar acuerdo_confianza
ttest acuerdo_ciudad_emprendimiento, by(tipo_negocio)
ttest acuerdo_gobierno_emprendimiento, by(tipo_negocio)
ttest acuerdo_nacional_emprendimiento, by(tipo_negocio)
ttest acuerdo_reclamolegal, by(tipo_negocio)
ttest acuerdo_denuncia, by(tipo_negocio)
ttest acuerdo_empezar, by(tipo_negocio)
ttest acuerdo_confianza, by(tipo_negocio)
restore

/**************************************************************************************************
Limitaciones de crecimiento del negocio
**************************************************************************************************/
label define falta_clientes 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define falta_insumos 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define falta_financiamiento 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define falta_trabajadores 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define alto_costo_contratacion 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define alto_costo_regulacion 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define altos_impuestos 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define criminalidad 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define incertidumbre_economia 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace
label define competencia_desleal 1 "Muy importante" 2 "Importante" 3 "Algo importante" 4 "No es importante" 5 "Nada importante", replace

*Falta de clientes 
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo falta_clientes)
drop if falta_clientes==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(falta_clientes) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(falta_clientes) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 38 limitaciones de crecimiento - falta de clientes.jpg", replace
restore

*Falta de insumos
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo falta_insumos)
drop if falta_insumos==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(falta_insumos) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(falta_insumos) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 39 limitaciones de crecimiento - falta de insumos.jpg", replace
restore

*Falta de financiamiento
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo falta_financiamiento)
drop if falta_financiamiento==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(falta_financiamiento) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(falta_financiamiento) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 40 limitaciones de crecimiento - falta de financiamiento.jpg", replace
restore

*Falta de trabajadores capacitados
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo falta_trabajadores)
drop if falta_trabajadores==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(falta_trabajadores) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(falta_trabajadores) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 41 limitaciones de crecimiento - falta de trabajadores capacitados.jpg", replace
restore

*Altos costos de contratar nuevos empleados
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo alto_costo_contratacion)
drop if alto_costo_contratacion==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(alto_costo_contratacion) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(alto_costo_contratacion) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 42 limitaciones de crecimiento - altos costos de contratar nuevos empleados.jpg", replace
restore

*Altos costos de las regulaciones o normas legales (permisos de operación)
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo alto_costo_regulacion)
drop if alto_costo_regulacion==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(alto_costo_regulacion) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(alto_costo_regulacion) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 43 limitaciones de crecimiento - altos costos de normas legales.jpg", replace
restore

*Altas tasas de impuestos
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo altos_impuestos)
drop if altos_impuestos==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(altos_impuestos) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(altos_impuestos) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 44 limitaciones de crecimiento - altas tasas de impuestos.jpg", replace
restore

*Criminalidad (robos, extorsiones, secuestros)
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo criminalidad)
drop if criminalidad==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(criminalidad) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(criminalidad) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 45 limitaciones de crecimiento - criminalidad.jpg", replace
restore

*Incertidumbre en el estado de la economía
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo incertidumbre_economia)
drop if incertidumbre_economia==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(incertidumbre_economia) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(incertidumbre_economia) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 46 limitaciones de crecimiento - incertidumbre en la economía.jpg", replace
restore

*Competencia por parte de negocios que no pagan impuestos o no están registrados  competencia_desleal
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo competencia_desleal)
drop if competencia_desleal==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(competencia_desleal) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(competencia_desleal) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 47 limitaciones de crecimiento - competencia por parte de negocios que no pagan impuestos.jpg", replace
restore


preserve
gen Tiempo=tiempo
collapse (mean) falta_clientes falta_insumos falta_financiamiento falta_trabajadores alto_costo_contratacion alto_costo_regulacion altos_impuestos criminalidad incertidumbre_economia competencia_desleal, by(tiempo)
graph hbar (mean) falta_clientes falta_insumos falta_financiamiento falta_trabajadores alto_costo_contratacion alto_costo_regulacion altos_impuestos criminalidad incertidumbre_economia competencia_desleal, by(tiempo) blabel(bar, format(%4.2f)) legend(order (1 "falta de clientes" 2 "falta de insumos" 3 "falta de financiamiento" 4 "falta de trabajadores capacitados" 5 "alto costo de contratación" 6 "alto costo de regulación" 7 "altos impuestos" 8 "criminalidad" 9 "incertidumbre en la economía" 10 "competencia desleal") cols(3)) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 48 limitaciones de crecimiento por ola.jpg", replace
restore

preserve
ttest falta_clientes, by(tiempo)
ttest falta_insumos, by(tiempo)
ttest falta_financiamiento, by(tiempo)
ttest falta_trabajadores, by(tiempo)
ttest alto_costo_contratacion, by(tiempo)
ttest alto_costo_regulacion, by(tiempo)
ttest altos_impuestos, by(tiempo)
ttest criminalidad, by(tiempo)
ttest incertidumbre_economia, by(tiempo)
ttest competencia_desleal, by(tiempo)
restore

/**************************************************************************************************
Descripción personal
**************************************************************************************************/










/**************************************************************************************************
Satisfacción
**************************************************************************************************/
salud sit_economica empleo familia amistades tiempo_libre seguridad

*Su salud
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo salud)
drop if salud==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(salud) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(salud) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)"))  scheme(plotplainblind)
*graph export "$Graficas\Gráfica 49 satisfacción su salud.jpg", replace
restore

*Su situación económica
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo sit_economica)
drop if sit_economica==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(sit_economica) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(sit_economica) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 50 satisfacción su situación económica.jpg", replace
restore

*Su empleo u ocupación
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo empleo)
drop if empleo==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(empleo) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(empleo) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 51 satisfacción su empleo u ocupación.jpg", replace
restore

*Sus relaciones familiares
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo familia)
drop if familia==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(familia) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(familia) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 52 satisfacción su familia.jpg", replace
restore

*Sus amistades
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo amistades)
drop if amistades==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(amistades) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(amistades) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 53 satisfacción amistades.jpg", replace
restore

*Su tiempo libre
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo tiempo_libre)
drop if tiempo_libre==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(tiempo_libre) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(tiempo_libre) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 54 satisfacción su tiempo libre.jpg", replace
restore

*La seguridad de su barrio
preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo seguridad)
drop if seguridad==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(seguridad) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(seguridad) blabel(bar, format(%4.2f)) legend(position(6) rows(1) order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 55 satisfacción la seguridad del barrio.jpg", replace
restore

/**************************************************************************************************
comparison of risk attitudes
**************************************************************************************************/
gen overall_life_risk=Riesgo1/5 //primero se normaliza de 0 a 1
gen financial_risk=Riesgo2/5 //se normaliza de 0 a 1
*gen risk_aversion
*gen loss_aversion
gen preferencias_temporales = 1 if preferencias_hoy == 2
replace preferencias_temporales = 2 if preferencias_hoy2 == 2
replace preferencias_temporales = 3 if preferencias_hoy3 == 2
replace preferencias_temporales = 4 if preferencias_hoy4 == 2
replace preferencias_temporales = 5 if preferencias_hoy5 == 2
replace preferencias_temporales = 6 if preferencias_hoy6 == 2
replace preferencias_temporales = 7 if preferencias_hoy7 == 2
replace preferencias_temporales = 8 if preferencias_hoy8 == 2
replace preferencias_temporales = 0 if preferencias_hoy == 1 & preferencias_hoy2 == 1 & preferencias_hoy3 == 1 & preferencias_hoy4 == 1 & preferencias_hoy5 == 1 & preferencias_hoy6 == 1 & preferencias_hoy7 == 1 & preferencias_hoy8 == 1
label var preferencias_temporales "Preferencias temporales"
label define preferencias_temporales 0 "1 millón hoy" 1 "1'100.000 en un mes" 2 "1'200.000 en un mes" 3 "1'300.000 en un mes" 4 "1'400.000 en un mes" 5 "1'500.000 en un mes" 6 "1'600.000 en un mes" 7 "1'700.000 en un mes" 8 "1'800.000 en un mes"
*label define preferencias_temporales 0 "1 millón hoy" 1 "10% más en un mes" 2 "20% más en un mes" 3 "30% más en un mes" 4 "40% más en un mes" 5 "50% más en un mes" 6 "60% más en un mes" 7 "70% más en un mes" 8 "80% más en un mes"
label values preferencias_temporales preferencias_temporales

gen preferencias_temporalesm = 1 if preferencias_hoym == 2
replace preferencias_temporalesm = 2 if preferencias_hoym2 == 2
replace preferencias_temporalesm = 3 if preferencias_hoym3 == 2
replace preferencias_temporalesm = 4 if preferencias_hoym4 == 2
replace preferencias_temporalesm = 5 if preferencias_hoym5 == 2
replace preferencias_temporalesm = 6 if preferencias_hoym6 == 2
replace preferencias_temporalesm = 7 if preferencias_hoym7 == 2
replace preferencias_temporalesm = 8 if preferencias_hoym8 == 2
replace preferencias_temporalesm = 0 if preferencias_hoym == 1 & preferencias_hoym2 == 1 & preferencias_hoym3 == 1 & preferencias_hoym4 == 1 & preferencias_hoym5 == 1 & preferencias_hoym6 == 1 & preferencias_hoym7 == 1 & preferencias_hoym8 == 1
label var preferencias_temporales "Preferencias temporales m"
label values preferencias_temporalesm preferencias_temporales

*diferencia de medias - cuenta propia vs microempresa
preserve
drop if tipo_negocio==3
replace preferencias_temporales = preferencias_temporales /8
replace preferencias_temporalesm = preferencias_temporalesm /8
replace negocio = negocio / 5
replace negocio2 = negocio2 / 5
ttest overall_life_risk, by(tipo_negocio)
ttest financial_risk, by(tipo_negocio)
ttest preferencias_temporales, by(tipo_negocio)
ttest preferencias_temporalesm, by(tipo_negocio)
ttest negocio, by(tipo_negocio)
ttest negocio2, by(tipo_negocio)
restore

preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo Riesgo1)
drop if Riesgo1==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(Riesgo1) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(Riesgo1) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 56 Nunca intento algo de lo que no estoy seguro.jpg", replace
restore

preserve
collapse (count) tiempo, by(Riesgo1)
drop if Riesgo1==.
egen N=total(tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
graph hbar (mean) tiempo, over(Riesgo1) blabel(bar, format(%4.2f)) scheme(plotplainblind)
restore

preserve
gen Tiempo=tiempo
collapse (count) tiempo, by(Tiempo Riesgo2)
drop if Riesgo2==.
egen N=total(tiempo), by(Tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
drop N
reshape wide tiempo, i(Riesgo2) j(Tiempo)
graph hbar (mean) tiempo1 tiempo2, over(Riesgo2) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*graph export "$Graficas\Gráfica 57 Una persona puede enriquecerse tomando riesgos.jpg", replace
restore

preserve
collapse (count) tiempo, by(Riesgo2)
drop if Riesgo2==.
egen N=total(tiempo)
replace tiempo=tiempo*100/N
format %3.1f tiempo
graph hbar (mean) tiempo, over(Riesgo2) blabel(bar, format(%4.2f)) scheme(plotplainblind)
restore


//ver cambios con el covid en preguntas de percepción en aquellas tiendas que están en ambas olas
foreach var of varlist Expand_Knowl Prec_Knowl Regis_Knowl Produ_Knowl Comp_Knowl Prec_Mayor_Knowl Public_Knowl Boca_Knowl Condic_Knowl Dinero_Knowl acuerdo_ciudad_emprendimiento acuerdo_gobierno_emprendimiento acuerdo_nacional_emprendimiento acuerdo_reclamolegal acuerdo_denuncia acuerdo_empezar acuerdo_confianza falta_clientes falta_insumos falta_financiamiento falta_trabajadores alto_costo_contratacion alto_costo_regulacion altos_impuestos criminalidad incertidumbre_economia competencia_desleal salud sit_economica empleo familia amistades tiempo_libre seguridad {
	reg `var' tiempo
	display "`var'" abs(_b[tiempo]/_se[tiempo])>1.69
}


*Aumenta con la ola del 2022 Prec_Knowl Regis_Knowl Condic_Knowl altos_impuestos competencia_desleal tiempo_libre
*Disminuye con la ola del 2022 Public_Knowl Dinero_Knowl acuerdo_ciudad_emprendimiento acuerdo_reclamolegal acuerdo_confianza falta_trabajadores alto_costo_regulacion incertidumbre_economia salud sit_economica empleo familia seguridad

*reshape wide tiempo, i(falta_clientes) j(Tiempo)
*graph hbar (mean) tiempo1 tiempo2, over(falta_clientes) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*reshape wide tiempo, i(falta_clientes tipo_negocio) j(Tiempo)
*graph hbar (mean) tiempo1 tiempo2, over(falta_clientes) over(tipo_negocio) blabel(bar, format(%4.2f)) legend(order (1 "Ola 1 (2019)" 2 "Ola 2 (2022)")) scheme(plotplainblind)
*reshape wide tiempo, i(falta_insumos Tiempo) j(tipo_negocio)
*label define time 1 "Ola 1 (2019)" 2 "Ola 2 (2022)"
*label values Tiempo time
*graph hbar (mean) tiempo1 tiempo2 tiempo3, over(falta_insumos) blabel(bar, format(%4.2f)) legend(order (1 "Cuenta propia" 2 "Microempresa" 3 "Otro")) scheme(plotplainblind)