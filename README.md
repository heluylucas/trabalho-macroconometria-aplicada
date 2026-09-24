# Política monetária e produto no Canadá: uma identificação agnóstica à la Uhlig (2005)

Trabalho final de Macroeconometria Aplicada (EESP/FGV).
Lucas Heluy, Mateus Belline e Theodoro Mota.

Replicamos o exercício de identificação por restrições de sinal de Uhlig (2005) e o
aplicamos ao Canadá, em VAR mensal de seis variáveis entre 1997 e 2019. A pergunta é se um
choque monetário contracionista reduz o produto quando nada é imposto sobre a resposta do
produto na identificação.

**Resultado.** Sob restrições de sinal, a resposta do PIB real canadense é ambígua: a
banda de 68% contém zero em todo o horizonte de cinco anos e a probabilidade posterior de
queda fica entre 0,25 e 0,38. Sob Cholesky, a mesma amostra produz queda do produto com
probabilidade acima de 0,75 a partir do segundo ano.

## Como reproduzir

Requer R 4.4 ou superior. Os pacotes são instalados pelos próprios scripts:
`bsvarSIGNs`, `vars`, `tsoutliers`, `forecast`, `dplyr`, `tidyr`, `readr`, `ggplot2`,
`knitr`.

```r
# 1) baixa as séries das fontes oficiais e salva dados/dados_canada.csv (roda uma vez)
rmarkdown::render("00_download_dados.Rmd")

# 2) estima tudo e grava figuras e tabelas em output/
rmarkdown::render("01_analise_principal.Rmd")
```

O script de estimação **não** baixa dados: ele lê o CSV salvo pelo primeiro. Isso garante
que os resultados sejam reproduzíveis mesmo que as APIs mudem. O tempo total de execução
fica em torno de 30 a 60 minutos, dominado pela seção de robustez; para uma rodada rápida,
use `params$robustez = FALSE` e reduza `params$S`.

## Estrutura do repositório

| Arquivo | O que é |
| --- | --- |
| `00_download_dados.Rmd` | Baixa as séries do Statistics Canada, do Banco do Canadá e do FRED; salva `dados/dados_canada.csv`, as séries brutas em `dados/brutos/` e `dados/metadados_series.csv` |
| `01_analise_principal.Rmd` | Replicação dos EUA, seleção de defasagens e diagnóstico, estimação do Canadá, FEVD e robustez |
| `01_analise_principal.html` | Saída compilada do script acima, com todas as tabelas e figuras |
| `dados/` | Base montada, séries brutas e metadados |
| `output/` | Figuras (`.png`) e tabelas (`.csv`) geradas pelo script |
| `Uso_IA.md` | Descrição do uso de ferramentas de IA |

## Dados

Amostra mensal, Canadá, 1997:01 a 2019:12 (276 observações). O início é limitado pelo PIB
mensal; o fim evita a pandemia e o período com a taxa overnight em 0,25% (2020--2022).

| Variável | Descrição | Fonte | Código |
| --- | --- | --- | --- |
| `pib` | PIB real mensal, todas as indústrias, dessaz., encadeado 2017 | Statistics Canada, tab. 36-10-0434-01 | `v65201210` |
| `cpi` | CPI all-items, dessazonalizado | Statistics Canada, tab. 18-10-0006-01 | `v41690914` |
| `overnight` | Taxa overnight, média mensal (% a.a.) | Banco do Canadá (Valet) | `V122514` |
| `bcpi` | Índice de preços de commodities (BCPI), total | Banco do Canadá (Valet) | `M.BCPI` |
| `m1` | M1+ (gross), dessazonalizado | Banco do Canadá (Valet) | grupo `e1_monthly` |
| `cadusd` | CAD por USD, média mensal | FRED | `EXCAUS` |
| `fedfunds` | Federal funds rate efetiva (robustez) | FRED | `FEDFUNDS` |

Todas as variáveis entram em `100 × log`, exceto as taxas de juros, em nível.

## Identificação

Restrições de sinal sobre a coluna do choque, válidas de `k = 0` a `k = 5` meses:

| | PIB | CPI | BCPI | Overnight | M1+ | CAD/USD |
| --- | --- | --- | --- | --- | --- | --- |
| Baseline | livre | ≤ 0 | livre | ≥ 0 | ≤ 0 | livre |
| Câmbio restrito | livre | ≤ 0 | livre | ≥ 0 | ≤ 0 | ≤ 0 |

O BCPI fica livre porque o Canadá não influencia preços globais de commodities. O M1+
ocupa o lugar das reservas não emprestadas de Uhlig, já que o Canadá eliminou os
compulsórios em 1994. A estimação usa o `bsvarSIGNs`, que implementa o algoritmo de Arias,
Rubio-Ramírez e Waggoner (2018); com restrições apenas de sinal, ele equivale ao
procedimento de Uhlig.

## Principais saídas

| Arquivo em `output/` | Conteúdo |
| --- | --- |
| `fig_replicacao_uhlig.png` | Replicação das Figuras 5 e 6 de Uhlig (2005) |
| `fig_canada_baseline_vs_cholesky.png` | Resultado central: sinais contra Cholesky |
| `fig_canada_cambio.png` | Câmbio livre contra câmbio restrito |
| `fig_canada_lags.png` | Resposta do PIB com p = 12 e com p = 4 mais dummies |
| `fig_robustez_pib.png` | Resposta do PIB em oito especificações |
| `prob_pib_negativo.csv` | P(resposta do PIB < 0) por horizonte |
| `fevd_canada_baseline.csv` | Decomposição da variância |
| `irf_*.csv` | Quantis de 16%, 50% e 84% das respostas a impulso |

## Limitações conhecidas

- **Choque concorrente não excluído.** Num exportador de commodities, um choque de termos
  de troca eleva o BCPI, aprecia o câmbio, reduz o CPI por repasse, leva o banco central a
  subir juros e eleva o produto, satisfazendo as três restrições impostas. A extensão
  natural é impor resposta nula do BCPI no impacto ou incluir um bloco externo completo.
- **Tamanho do choque.** A overnight sobe 5 p.b. sob sinais e 14 p.b. sob Cholesky, de
  modo que as magnitudes só são comparáveis depois de normalizadas.
- **Prior.** O `bsvarSIGNs` usa prior Minnesota hierárquico e sempre inclui intercepto,
  ao contrário do Normal-Wishart difuso e sem constante de Uhlig.
- **Prior sobre rotações.** Vale a crítica de Baumeister e Hamilton (2015): o sorteio
  uniforme da rotação não é neutro sobre as respostas a impulso.

## Referências principais

- Uhlig, H. (2005). What are the effects of monetary policy on output? Results from an
  agnostic identification procedure. *Journal of Monetary Economics*, 52(2), 381--419.
- Kim, S. e Lim, K. (2018). Effects of monetary policy shocks on exchange rate in small
  open economies. *Journal of Macroeconomics*, 56, 324--339.
- Bhuiyan, R. (2012). Monetary transmission mechanisms in a small open economy: a Bayesian
  structural VAR approach. *Canadian Journal of Economics*, 45(3), 1037--1061.
