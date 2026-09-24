# Uso de Inteligência Artificial

Trabalho final de Macroeconometria Aplicada (EESP/FGV) — Política monetária e produto no
Canadá: uma identificação agnóstica à la Uhlig (2005).
Lucas Heluy, Mateus Belline e Theodoro Mota.

## Ferramentas utilizadas

| Ferramenta         | Onde foi usada                                                                  |
| ------------------ | ------------------------------------------------------------------------------- |
| Claude (claude.ai) | Pesquisa inicial, busca de literatura, código, textos do relatório e dos slides |
| Claude Code        | Escrita e depuração do código em R                                              |
| Claude Design      | Apoio na construção dos slides                                                  |

Para organizar o trabalho, criamos um projeto no Claude, o que facilitou reunir os
materiais da disciplina e manter o contexto entre as sessões.

## Como a ferramenta foi usada, por etapa

### 1. Definição do tema e pesquisa de literatura

Usamos a IA para validar a ideia de replicar o exercício de Uhlig (2005), visto em aula,
para o Canadá, e para buscar artigos publicados que dessem base e robustez ao trabalho.
Dessa busca vieram Kim e Lim (2018) e Bhuiyan (2012), que passaram a ser, junto com
Uhlig, as três referências centrais.

### 2. Código

O Claude e o Claude Code foram usados para escrever os scripts em R, corrigir erros, formatar a saída dos resultados e
acrescentar funcionalidades que julgamos necessárias. O exemplo principal é a seção de
seleção de defasagens por critérios de informação, com diagnóstico de resíduos e detecção
de outliers, ausente no paper original de Uhlig e incorporada por sugestão nossa, a partir
do procedimento visto em aula.

Em todos os passos, o código gerado foi revisado e testado por nós antes de ser
incorporado.

### 3. Relatório

Com os resultados em mãos, usamos a IA para auxiliar na redação do relatório, revisar o
que foi escrito, montar tabelas e figuras e formatar o documento em LaTeX. Os números
citados no texto vêm dos arquivos em `output/`, gerados pelo script, e foram conferidos
contra eles.

### 4. Apresentação

Os slides foram construídos em LaTeX, com apoio do Claude e do Claude Design,
seguindo o formato dos slides usados em aula. As figuras em formato de slide, geradas a
partir dos mesmos CSVs de `output/`, também tiveram apoio da ferramenta a partir de um script gerado para melhorar a visualização das imagens na apresentação.
