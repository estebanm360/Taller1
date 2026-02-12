// Impacto del RCT de Expertienda -----------------------------------
// @Author: Paul Rodríguez-Lesmes, con inputs de Mauricio Romero y Juan Urueña
// @desc: 	Pegue de los datos para construir la base de evaluación,
//          construccion de los indicadores
// -----------------------------------------------------------------------------

version 14 	// Necesario para replicar el ejecicio (la semilla cambia de versión 
			// en versión)

if "`c(username)'"=="paul.rodriguez" {
	glo drive   "D:\Paul.Rodriguez\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
	glo drive "C:\Users\paul.rodriguez\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
	glo dropbox "D:\Paul.Rodriguez\Dropbox\Colombia Científica\Proyecto\AnalisisEncuestas\"
}
else if "`c(username)'"=="andro" {
	glo drive "C:\Users\andro\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
}
else if "`c(username)'"== "juanca.uruena"{
	glo drive "C:\Users\juanca.uruena\Universidad del rosario\Col Cientifica Emprendimiento - Documentos\Analisis Encuesta Tenderos"
}

do "$drive\aleatorizacion\00_Programs.do"


////////////////////////////////////////////////////////////////////////////////
cd "$tablas" // En esta carpeta quedará todo lo que produzca "latab"
use "$drive\derivedFU\TenderosFU00_CensoWithRejected.dta" , clear
rename interview__key interview__keyFU
rename codigoLineaBase interview__key

rename consentimiento consentimientoFU
replace consentimientoFU=0 if consentimientoFU==.

rename wtp_randomoption wtp_randomoptionFU
rename wtp_whichoption wtp_whichoptionFU

merge m:1 interview__key using "$drive\derivedBL\Tenderos00_Censo.dta" , force gen(mergeAleat)
rename interview__key codigoLineaBase

tab consentimiento Resultado


tab existenteBaseOriginal // Menciones a los mismos lugares
tab existenteBaseOriginal if Result=="ENCUESTA COMPLETA"
tab existenteBaseOriginal if Result=="ENCUESTA COMPLETA" & consentimiento==1



// Anonimizar
drop Entrevistado expertienda_quien2 Nom_DecisionesAsk Tel1 Tel2 Correo_1 Correo
drop Establecimiento redsocial1__0 redsocial1__1 redsocial1__2 PROYECTO redsocial2__0 redsocial?__*
drop gps__Latitude gps__Longitude gps__Accuracy gps__Altitude gps__Timestamp


save "$drive\derivedFU\TenderosFU00_BLandFUmerged.dta" , clear