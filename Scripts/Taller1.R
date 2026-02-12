# Taller 1 Haciendo economia
# Autores : Esteban Mora - Simon Triviño - Miguel Diaz 


library(haven)
df <- read_dta("Datos/Originales/TenderosFU03_Publica.dta")
View(df)

suma_caracteristicas_finanzas <- colSums(df[, c( "Finan_Gastos__1", "Finan_Gastos__2", "Finan_Gastos__4", "Finan_Gastos__7", "Finan_Gastos__9", "Finan_Gastos__10", "Finan_Gastos__11", "Finan_Gastos__12" )], na.rm = TRUE)

names(suma_caracteristicas_finanzas) <- c(
  "Ahorros o recursos propios",
  "Ganancias del negocio",
  "Préstamos o créditos bancario con el sistema
financiero (ej. bancos, almacenes, microcrédito, etc.)",
  "Programas del Gobierno (Fondo emprender, etc.)",
  "Préstamo de amigos o parientes (sin intereses)",
  "Deudas o créditos",
  "Con prestamista particular, casa de empeño o gota a
gota (con intereses)",
  "No requiere capital para operar su negocio"
)

# Ordenar los datos de mayor a menor
suma_ordenada <- sort(suma_caracteristicas_finanzas, decreasing = TRUE)

# Paleta azul (sobria y profesional)
colores_azul <- c(
  "#0B3C5D",  # azul oscuro
  "#1F5A8A",
  "#2E86C1",
  "#5DADE2",
  "#85C1E9",
  "#AED6F1",
  "#D6EAF8",
  "#EBF5FB"
)

bp <- barplot(
  suma_ordenada,
  main = "Principales rubros de gasto de los micronegocios",
  ylab = "Número de establecimientos",
  col = colores_azul,
  border = NA,
  names.arg = rep("", length(suma_ordenada)) # ocultar etiquetas
)

text(
  x = bp,
  y = par("usr")[3] - max(suma_ordenada)*0.05, # baja el texto
  labels = names(suma_ordenada),
  srt = 45,
  adj = 1,
  xpd = TRUE,
  cex = 0.85
)

grid(
  nx = NA,
  ny = NULL,
  col = "gray90",
  lty = "dotted"
)

par(mar = c(9, 5, 4, 2))

dev.off()
getwd()

# Conteo de respuestas
conteo_wallet <- c(
  "Sí conoce" = sum(df$Elec_Wallet_Knowledge == 1, na.rm = TRUE),
  "No conoce" = sum(df$Elec_Wallet_Knowledge == 0, na.rm = TRUE)
)

# Porcentajes
porcentaje_wallet <- round(conteo_wallet / sum(conteo_wallet) * 100, 1)

# Colores azules consistentes
colores_azul_binaria <- c("#0B3C5D", "#AED6F1")

bp <- barplot(
  porcentaje_wallet,
  main = "Conocimiento sobre billeteras electrónicas",
  ylab = "Porcentaje de establecimientos",
  col = colores_azul_binaria,
  border = NA,
  ylim = c(0, max(porcentaje_wallet) + 10)
)

# Etiquetas en porcentaje
text(
  x = bp,
  y = porcentaje_wallet,
  labels = paste0(porcentaje_wallet, "%"),
  pos = 3,
  cex = 0.9,
  col = "#0B3C5D"
)

# Grid sutil
grid(
  nx = NA,
  ny = NULL,
  col = "gray90",
  lty = "dotted"
)


#-----------------------------------------------------------------------------

# Conteo de respuestas
conteo_wallet <- c(
  "Sí conoce" = sum(df$Elec_Wallet_Knowledge == 1, na.rm = TRUE),
  "No conoce" = sum(df$Elec_Wallet_Knowledge == 0, na.rm = TRUE)
)

# Porcentajes
porcentaje_wallet <- round(conteo_wallet / sum(conteo_wallet) * 100, 1)

# Colores azules consistentes
colores_azul_binaria <- c("#0B3C5D", "#AED6F1")

bp <- barplot(
  porcentaje_wallet,
  main = "Conocimiento sobre billeteras electrónicas",
  ylab = "Porcentaje de establecimientos",
  col = colores_azul_binaria,
  border = NA,
  ylim = c(0, max(porcentaje_wallet) + 10)
)

# Etiquetas en porcentaje
text(
  x = bp,
  y = porcentaje_wallet,
  labels = paste0(porcentaje_wallet, "%"),
  pos = 3,
  cex = 0.9,
  col = "#0B3C5D"
)

# Grid sutil
grid(
  nx = NA,
  ny = NULL,
  col = "gray90",
  lty = "dotted"
)


