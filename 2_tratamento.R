#--------------------------------------------------------------------------#
#
# Nome do Script: 2_tratamento
#
# Objetivo: tratar os arquivos baixados
#
# Autor: Ricardo Theodoro
# Email: rtheodoro@usp.br
# Data da criação: 2023-07-28
# 
#--------------------------------------------------------------------------#
#
# Notas: rodar primeiro o script 1_webscraping
#   
#--------------------------------------------------------------------------#
options(scipen = 6, digits = 4)
#--------------------------------------------------------------------------#

primeiroano <- 1993
anomaisrecente <- as.numeric(format(Sys.time(), "%Y")) - 1

csv_coop_completo_1993a2022 <- data.frame()

for(i in primeiroano:anomaisrecente) {
   
   print(glue::glue("Carregando Balanço do ano {i}"))
   if (i == 1993) {
      csv_i <-
         data.table::fread(
            glue::glue('data_raw/{i}12COOPERATIVAS.CSV'),
            sep = ";",
            skip = 4
         )
      
      print(glue::glue("Tratando Balanço do ano {i}"))
      
      csv_i <- csv_i |>  dplyr::filter(DOCUMENTO == 4010) |>
         dplyr::select(CNPJ, `#DATA_BASE`, NOME_INSTITUICAO, CONTA, SALDO)
      
   } else if (i > 1993 & i < 2010) {
      csv_i <-
         data.table::fread(
            glue::glue('data_raw/{i}12COOPERATIVAS.CSV'),
            sep = ";",
            skip = 3
         )
      print(glue::glue("Tratando Balanço do ano {i}"))
      csv_i <- csv_i |>  dplyr::filter(DOCUMENTO == 4010) |>
         dplyr::select(CNPJ, DATA, `NOME INSTITUICAO`, CONTA, SALDO)
   }  else{
      csv_i <-
         data.table::fread(
            glue::glue('data_raw/{i}12COOPERATIVAS.CSV'),
            sep = ";",
            skip = 3
         )
      print(glue::glue("Tratando Balanço do ano {i}"))
      csv_i <- csv_i |>  dplyr::filter(DOCUMENTO == 4010) |>
         dplyr::select(CNPJ, `#DATA_BASE`, NOME_INSTITUICAO, CONTA, SALDO)
   }

   
   names(csv_i)[1:3] <- c('cnpj', 'ano', 'razao_social')
   
   csv_i <- csv_i |> 
      tidyr::pivot_wider(
         id_cols = c(cnpj, ano, razao_social),
         names_from = CONTA,
         values_from = SALDO
      )
   
   print(glue::glue("Unificando Balanço do ano {i}"))
   csv_coop_completo_1993a2022 <-
      merge(csv_coop_completo_1993a2022, csv_i, all = TRUE)
   
   rm(csv_i)
   
}


# Substitua 'csv_coop_completo_1993a2022' pelo nome real do seu data frame
csv_coop_completo_1993a2022 <- csv_coop_completo_1993a2022  |> 
   dplyr::mutate_at(dplyr::vars(dplyr::matches("[0-9]")), ~ as.numeric(gsub(",", ".", .))) 


write.csv(csv_coop_completo_1993a2022, file = "data/balanco_coop_cred_1993a2022_4010.csv", row.names = FALSE)
