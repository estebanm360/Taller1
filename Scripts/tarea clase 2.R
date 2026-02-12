# Tarea en clase 2
# Autores: Esteban Mora - Miguel Diaz - Simon Triviño

library(dplyr)
library(haven)
TenderosFU03_Publica <- read_dta("..Datos/Originales/TenderosFU03_Publica.dta")

act_bysector <- bind_rows(
  TenderosFU03_Publica %>%
    filter(actG1 == 1) %>%
    summarise(actG = 1, Actividad = "Tienda", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG2 == 1) %>%
    summarise(actG = 2, Actividad = "Comida preparada", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG3 == 1) %>%
    summarise(actG = 3, Actividad = "Peluqueria y belleza", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG4 == 1) %>%
    summarise(actG = 4, Actividad = "Ropa", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG5 == 1) %>%
    summarise(actG = 5, Actividad = "Otras variedades", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG6 == 1) %>%
    summarise(actG = 6, Actividad = "Papeleria y comunicaciones", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG7 == 1) %>%
    summarise(actG = 7, Actividad = "Vida nocturna", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG8 == 1) %>%
    summarise(actG = 8, Actividad = "Productos bajo inventario", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG9 == 1) %>%
    summarise(actG = 9, Actividad = "Salud", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG10 == 1) %>%
    summarise(actG = 10, Actividad = "Servicios", internet = mean(uso_internet, na.rm = TRUE)),
  
  TenderosFU03_Publica %>%
    filter(actG11 == 1) %>%
    summarise(actG = 11, Actividad = "Ferreteria y afines", internet = mean(uso_internet, na.rm = TRUE))
) %>%
  arrange(desc(internet))

print(act_bysector)
