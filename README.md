# Webscraping dos Balancos Patrimoniais de Cooperativas de Crédito


Este projeto serve para fazer o download do balanço consolidado de todas as Cooperativas de Crédito disponíveis no [Banco Central do Brasil (Bacen)](https://www.bcb.gov.br/acessoinformacao/legado?url=https:%2F%2Fwww4.bcb.gov.br%2Ffis%2Fcosif%2Fbalancetes.asp)

- Os balancos baixados são referentes a Dezembro de cada ano
- Os balanços de Dezembro são disponibilizados apenas em Abril do próximo ano
- O balanço mais antigo é de 1993
- Apenas documentos 4010 estaram no arquivo final `data/balanco_coop_cred_1993a2022_4010.csv`

#### Estrutura do projeto

- o script `main` irá rodar os scritps `1_webscraping` e `2_tratamento`

- a pasta `data_raw` contém os arquivos .zip e .csv baixados diretamente do Bacen

- a pasta `data` contém o arquivo final, com os balanços tratados e unificados em apenas uma planinha


#### NOTA

o arquivo de 2022 estava com problemas na importação (uma coluna estava ocupando espaço da outra), acredito ter resolvido.

Caso encontrem alguma inconsistência no arquivo final, me mandem um e-mail rtheodoro@usp.br