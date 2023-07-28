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

files <- list.files(path = "data_raw/", pattern = ".CSV$")

# de qualquer forma, é preciso baixar o .csv primeiro e verificar se todos começam na terceira linha!

csv_coop_completo_1993a2022 <- data.frame()

for(i in primeiroano:anomaisrecente){
   
   eval(parse(text=paste0("
                        csv_",i," <- read.csv('data_raw/",i,"12COOPERATIVAS.CSV',
                                              sep=';', skip = 3)
                                              
                        csv_",i," <- csv_",i," |>  dplyr::filter(DOCUMENTO==4010) %>% 
                                                dplyr::select(CNPJ, X.DATA_BASE, NOME_INSTITUICAO, CONTA, SALDO) 
                                                
                        names(csv_",i,")[1:3] <- c('cnpj','ano','razao_social')

                        csv_",i," <- reshape(csv_",i,", timevar = 'CONTA',
                                                idvar = c('cnpj', 'ano', 'razao_social'), direction = 'wide', v.names = NULL)
 
                        csv_coop_completo_1993a2022 <- merge(csv_coop_completo_1993a2022, csv_",i,", all = TRUE)
                        
                        rm(csv_",i,")
                        
                        ")))
}


write.csv(csv_coop_completo_1993a2022, file = "data/balanco_coop_cred_1993a2022_4010.csv")
