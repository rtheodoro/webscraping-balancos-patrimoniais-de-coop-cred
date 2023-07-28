#--------------------------------------------------------------------------#
#
# Nome do Script: 1_webscraping
#
# Objetivo: baixar e tratar os balanços das cooperativas de crédito
#
# Autor: Ricardo Theodoro
# Email: rtheodoro@usp.br
# Data da criação: 2023-07-28
# 
#--------------------------------------------------------------------------#
#
# Notas: Dados originais em https://www.bcb.gov.br/acessoinformacao/legado?url=https:%2F%2Fwww4.bcb.gov.br%2Ffis%2Fcosif%2Fbalancetes.asp
#        Os balancos baixados são de Dezembro de cada ano
#        Os balanços de Dezembro são disponibilizados apenas em Abril do próximo ano
#        O balanço mais antigo é de 1993
#--------------------------------------------------------------------------#
options(scipen = 6, digits = 4)
#--------------------------------------------------------------------------#

# Baixando ZIP de cada balanço das Coopcred que possuem informações ----

primeiroano <- 1993
anomaisrecente <- as.numeric(format(Sys.time(), "%Y")) - 1

# local para salvar os arquivos
datacoleta <- format(Sys.time(), "%Y%m")


for(i in primeiroano:anomaisrecente){
   dest_file <- glue::glue("data_raw/{i}12_coopcred.zip")
   
   cat("Baixando balanço de Dezembro de", i)
   
   u_bc_zip <- glue::glue("https://www4.bcb.gov.br/fis/cosif/cont/balan/cooperativas/{i}12COOPERATIVAS.ZIP")
   
   httr::GET(u_bc_zip, httr::write_disk(dest_file, overwrite = TRUE))
}


# Extraindo os ZIP para CSV

files <- list.files(path="data_raw/", pattern=".zip$")
outDir <- "data_raw/"
for (i in files) {
   unzip(paste0(outDir, i), exdir = outDir)
}

rm(aanomaisrecente, dest_file, files, i, outDir, primeiroano, u_bc_zip)
