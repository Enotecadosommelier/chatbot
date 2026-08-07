# Etapa 4 — Planilha Financeira

Há duas planilhas nesta pasta. Use a **planilha-cmv-bar-style.xlsx** como
referência principal — é a versão completa, no padrão profissional de
controle de CMV/Markup de bar/restaurante. A `planilha-financeira.xlsx`
original foi mantida como versão mais simples e enxuta.

## `planilha-cmv-bar-style.xlsx` (recomendada — "planilha de tudo")

Reproduz o estilo de uma planilha auditada de CMV de bar/restaurante
(parâmetros globais, fichas técnicas ingrediente a ingrediente com fator de
correção, markup por categoria, alerta automático 🟢/🟡/🔴), adaptada para a
Casa Recheada. 5 abas, 488 fórmulas, recalculadas sem erros:

1. **Custos & Ponto Equilíbrio** — parâmetros do negócio (CMV meta/atenção,
   markup pães/sobremesas, fator de desperdício), custos fixos e variáveis
   mês a mês, ponto de equilíbrio (mensal/diário/pedidos por dia), cenário
   de sazonalidade (pico em datas comemorativas x vale em janeiro) e
   orçamento de abertura (CAPEX) com faixa mínima/máxima.
2. **Fichas Técnicas - Pães** — os 4 pães recheados, ingrediente por
   ingrediente (unidade, quantidade, preço de compra, fator de correção de
   perda, custo líquido, % no produto), com custo total do lote, custo real
   com desperdício operacional, custo unitário, preço de venda sugerido
   (= custo × markup) e CMV % real.
3. **Fichas Técnicas - Sobremesas** — as 5 sobremesas, mesmo formato.
4. **Cardápio & Preços** — lista mestra dos 9 produtos, ligada por fórmula
   às fichas técnicas, com CMV %, markup e status 🟢/🟡/🔴 automático.
5. **Painel Saúde do Negócio** — KPIs do mês (faturamento, CMV, custo fixo,
   lucro líquido, margem), faturamento por canal (WhatsApp, Instagram,
   indicação, eventos), CMV real por categoria, DRE do mês com alerta de
   CMV dinâmico em texto, e o total de capital necessário antes de abrir
   (capital de giro + CAPEX).

**Como usar:** preencha as células azuis (parâmetros, custos reais,
faturamento por canal) — tudo em preto/dourado é fórmula e recalcula
sozinho. O preço de venda de cada produto é sugerido automaticamente pelo
markup da categoria; ajuste o markup na aba Custos & Ponto Equilíbrio para
recalcular o cardápio inteiro de uma vez.

## `planilha-financeira.xlsx` (versão simples)

5 abas: INVESTIMENTO INICIAL, CUSTO DOS PRODUTOS, PRECIFICAÇÃO, CONTROLE
DIÁRIO e DRE SIMPLIFICADA. Boa para quem quer algo mais direto, sem o nível
de detalhe de fator de correção/CMV por categoria da versão acima.

Em ambas: células **azuis** são estimativas/valores de entrada editáveis;
células **pretas** (ou douradas nos totais) são cálculos automáticos.
