# DASHBOARD DE MÉTRICAS + SPIN SELLING + PLANO R$5.000/MÊS
## Vino Bianco Store — Módulos 8, 9 e 10

---

# MÓDULO 8 — DASHBOARD DE MÉTRICAS

## Estrutura do Dashboard (Google Sheets + Looker Studio)

### ABA 1 — VISÃO GERAL (KPIs Executivos)

```
╔═══════════════════════════════════════════════════════════════╗
║                VINO BIANCO — DASHBOARD MENSAL                 ║
╠═══════════════╦═══════════════╦═══════════════╦══════════════╣
║ RECEITA TOTAL ║  LEADS NOVOS  ║  VENDAS MÊS   ║  TICKET MÉDIO║
║               ║               ║               ║              ║
║  R$ ______    ║  ___ leads    ║  ___ vendas   ║  R$ ______   ║
╠═══════════════╩═══════════════╩═══════════════╩══════════════╣
║ META MÊS: R$ ______  │  ATINGIDO: ___% │  FALTAM: R$ ______ ║
╚═══════════════════════════════════════════════════════════════╝
```

---

### ABA 2 — FUNIL DE CONVERSÃO

| Etapa                     | Volume  | Taxa Conv. | Meta     | Status    |
|---------------------------|---------|------------|----------|-----------|
| Visitantes únicos/mês     | ___     | —          | 2.000    | 🔴/🟡/🟢  |
| Leads capturados          | ___     | ___% visits| 500      |           |
| Leads qualificados (score ≥7) | ___  | ___% leads | 150      |           |
| Cliques na pág. de vendas | ___     | ___% leads | 200      |           |
| Compradores               | ___     | ___% cliques| 15–20   |           |
| Order Bump anexados       | ___     | ___% compr.| 25–35%   |           |
| Upsell aceitos            | ___     | ___% compr.| 15–20%   |           |

---

### ABA 3 — CANAIS DE AQUISIÇÃO

| Canal                | Leads   | Custo/Lead | Vendas | Receita   | ROI    |
|----------------------|---------|------------|--------|-----------|--------|
| Instagram Organic    | ___     | R$0        | ___    | R$___     | ∞%     |
| Instagram Reels      | ___     | R$0        | ___    | R$___     | ∞%     |
| Meta Ads             | ___     | R$___      | ___    | R$___     | ___%   |
| Google Ads           | ___     | R$___      | ___    | R$___     | ___%   |
| SEO / Blog           | ___     | R$0        | ___    | R$___     | ∞%     |
| WhatsApp             | ___     | R$0        | ___    | R$___     | ∞%     |
| YouTube              | ___     | R$0        | ___    | R$___     | ∞%     |
| **TOTAL**            | **___** | **R$___**  |**___** |**R$___**  |**___%**|

---

### ABA 4 — MÉTRICAS POR PRODUTO

| Produto                   | Vendas | Receita   | % do Total | Chargeback |
|---------------------------|--------|-----------|------------|------------|
| Ebook Vol.1 (R$57)        | ___    | R$___     | ___%       | ___        |
| Order Bump Bar (R$17)     | ___    | R$___     | ___%       | ___        |
| Upsell Curso (R$67)       | ___    | R$___     | ___%       | ___        |
| Curso Premium (R$297)     | ___    | R$___     | ___%       | ___        |
| Clube Mensal (R$47/mês)   | ___ assinantes | R$___ | ___% | ___   |
| Consultoria (R$997)       | ___    | R$___     | ___%       | ___        |
| **TOTAL**                 |        | **R$___** | 100%       |            |

---

### ABA 5 — INSTAGRAM / CONTEÚDO

| Métrica                    | Semana 1 | Semana 2 | Semana 3 | Semana 4 | Meta/Mês |
|----------------------------|----------|----------|----------|----------|----------|
| Reels publicados           | ___      | ___      | ___      | ___      | 20–28    |
| Views totais               | ___      | ___      | ___      | ___      | 10.000   |
| Comentários com KW         | ___      | ___      | ___      | ___      | 200      |
| Leads via ManyChat         | ___      | ___      | ___      | ___      | 100      |
| Seguidores novos           | ___      | ___      | ___      | ___      | 300      |
| Taxa de engajamento média  | ___%     | ___%     | ___%     | ___%     | >3%      |

---

### ABA 6 — EMAIL MARKETING

| Métrica                    | Valor    | Meta     |
|----------------------------|----------|----------|
| Total de contatos          | ___      | 1.000    |
| Taxa de abertura média     | ___%     | >25%     |
| Taxa de clique (CTR)       | ___%     | >3%      |
| Descadastros/mês           | ___      | <2%      |
| Receita atribuída ao email | R$___    | R$1.500  |

---

### ABA 7 — WHATSAPP

| Métrica                    | Valor    | Meta     |
|----------------------------|----------|----------|
| Contatos ativos            | ___      | 500      |
| Taxa de abertura           | ___%     | >85%     |
| Taxa de resposta           | ___%     | >15%     |
| Carrinhos recuperados      | ___      | 20–30%   |
| Receita atribuída ao WA    | R$___    | R$800    |

---

### LOOKER STUDIO — CONFIGURAÇÃO

**Fontes de dados a conectar:**
1. Google Analytics 4 (tráfego, conversões, receita)
2. Google Ads (custo, clicks, conversões pagas)
3. Google Sheets (dados consolidados de leads e vendas)
4. Meta Ads (via conector nativo do Looker Studio)
5. Hotmart (via exportação CSV semanal → importar no Sheets)

**Visualizações recomendadas:**
- Gráfico de linha: receita × meta (diário/semanal)
- Funil: visitantes → leads → compradores
- Mapa de calor: origem dos leads por canal
- Tabela: produtos × vendas × receita × ROI

---

# MÓDULO 9 — ESTRATÉGIA SPIN SELLING

## SPIN Selling Aplicado ao Vinho para Iniciantes

O SPIN Selling (Neil Rackham) é a metodologia de vendas mais validada cientificamente.
Funciona especialmente bem em vendas consultivas — e vender conhecimento (ebook) é
essencialmente uma venda consultiva.

**S — Situação** (entender o contexto)
**P — Problema** (revelar a dor latente)
**I — Implicação** (ampliar as consequências do problema)
**N — Necessidade-Payoff** (mostrar o valor da solução)

---

## SPIN para o Contexto VinoBianco

### S — PERGUNTAS DE SITUAÇÃO
*(usadas para qualificar e entender o lead — via DM, WhatsApp ou email)*

- "Há quanto tempo você bebe vinho?"
- "Em que situações costuma tomar vinho? Jantares sociais, em casa, restaurantes?"
- "Você costuma escolher o vinho ou deixa alguém escolher?"
- "Tem alguma faixa de preço que costuma gastar por garrafa?"
- "Você já tentou aprender mais sobre vinho antes? Como foi?"

---

### P — PERGUNTAS DE PROBLEMA
*(revelar a dor que o lead talvez não tenha articulado)*

- "Quando está num restaurante com carta de vinhos, o que normalmente acontece?"
- "Já se sentiu constrangido ou inseguro na hora de escolher um vinho?"
- "Já comprou uma garrafa que não gostou e se arrependeu?"
- "Tem alguma situação específica onde sente que seu conhecimento de vinho faz falta?"
- "Quando alguém começa a falar sobre vinho, você consegue participar da conversa?"

---

### I — PERGUNTAS DE IMPLICAÇÃO
*(ampliar as consequências — essa é a parte mais poderosa do SPIN)*

- "Quando você deixa alguém escolher o vinho, como isso te faz sentir? Isso acontece frequentemente?"
- "Você acha que essa insegurança com vinho impacta como você se apresenta em jantares de negócios?"
- "Se você comprar um vinho errado para um jantar especial, qual seria o impacto na noite?"
- "Quanto você acha que já desperdiçou comprando vinhos que não eram o que esperava?"
- "Essa sensação de estar 'por fora' quando o assunto é vinho — ela aparece em outras situações sociais também?"

*A implicação transforma um problema pequeno em uma questão importante que merece solução.*

---

### N — PERGUNTAS DE NECESSIDADE-PAYOFF
*(fazer o lead articular o valor da solução — ele vende para si mesmo)*

- "Se você soubesse escolher um vinho sem depender de ninguém, o que mudaria nos seus jantares?"
- "Imagina entrar num restaurante e pedir o vinho sem gaguejar. Como seria essa sensação?"
- "Se você pudesse harmonizar perfeitamente com os pratos que serve em casa, qual seria o impacto nas suas confraternizações?"
- "Quanto vale para você ter a confiança de saber o que está bebendo — e poder comentar sobre isso?"
- "Se em uma tarde de leitura você resolvesse de vez essa insegurança com vinho, valeria o investimento?"

---

## SPIN em Cada Canal

### DM do Instagram (sequência de 3 mensagens)

**Msg 1 — Situação:**
```
Oi, [nome]! Baixou o guia 🍷
Curiosidade: você costuma escolher o vinho
ou deixa alguém escolher?
```

**Msg 2 — Problema + Implicação (após resposta):**
```
Entendo! Essa situação de depender de alguém
aparece muito, né? Especialmente em restaurantes...

Me conta: já se sentiu constrangido na carta de vinhos?
```

**Msg 3 — Necessidade-Payoff + CTA:**
```
Imagina resolver isso de vez — entrar em qualquer
restaurante sabendo o que fazer, sem depender de ninguém.

É exatamente isso que o guia completo ensina.
Se quiser ir muito além do PDF gratuito:
👉 [LINK HOTMART]
```

---

### Email de Vendas (Email 5 da sequência — baseado em SPIN)

**Subject:** "Você já calculou quanto perde por não entender de vinho?"

*[Abre com situação: a cena do restaurante]*
*[Problema: o constrangimento, a dependência]*
*[Implicação: o custo acumulado de vinhos errados + oportunidades sociais perdidas]*
*[Necessidade-Payoff: o que muda quando você aprende]*
*[Oferta + garantia]*

---

### Script para Live (se fizer lives no Instagram)

**Abertura (Situação):**
> "Pessoal, antes de começar: me manda no chat — quantos de vocês já fingiram que estavam lendo a carta de vinhos?"

**Desenvolvimento (Problema):**
> "E quando acontece isso, como vocês se sentem? Me manda aqui nos comentários..."

**Ponto de virada (Implicação):**
> "Eu vejo isso como uma perda dupla: você perde a experiência de escolher algo que realmente gosta, e ainda se sente inseguro numa situação que deveria ser de prazer..."

**Fechamento (Necessidade-Payoff):**
> "Quem aqui quer resolver isso de uma vez por todas? [CTA para o ebook]"

---

# MÓDULO 10 — PLANO PARA ATINGIR R$5.000/MÊS

## Decomposição da Meta

**Meta:** R$5.000/mês de receita líquida
**Prazo realista:** 3–6 meses (com execução consistente)

---

## CÁLCULO DE QUANTAS VENDAS PRECISA

| Produto              | Preço  | Vendas Necessárias | Receita   |
|----------------------|--------|--------------------|-----------|
| Ebook Vol.1          | R$57   | 60 vendas/mês      | R$3.420   |
| Order Bump (30%)     | R$17   | 18 vendas/mês      | R$306     |
| Upsell Curso (20%)   | R$67   | 12 vendas/mês      | R$804     |
| Clube Mensal         | R$47   | 10 assinantes      | R$470     |
| **TOTAL MÊS**        |        |                    | **R$5.000**|

**Ou misturando:** 45 ebooks + Order Bump + 8 cursos + 5 Clube = R$5.000+

---

## PLANO MENSAL MESES 1–6

### MÊS 1 — FUNDAÇÃO (meta: R$500)
**Foco:** Estruturar antes de escalar

**Semana 1–2: Produto e Plataforma**
- [ ] Criar PDF do ebook (Canva — 92 páginas)
- [ ] Criar PDF do Lead Magnet (12 páginas)
- [ ] Configurar produto no Hotmart (preço, garantia, order bump)
- [ ] Criar sequência de 7 emails no Mailchimp
- [ ] Configurar ManyChat no Instagram (palavra-chave VINHO)

**Semana 3–4: Primeiras Vendas**
- [ ] Publicar 10 Reels (2/dia nas primeiras 2 semanas)
- [ ] Fazer Stories diários com CTA para lead magnet
- [ ] Enviar email para lista atual (se tiver) com oferta de lançamento
- [ ] Meta: 10–15 leads/semana → 2–3 vendas

**KPIs Mês 1:**
- Seguidores novos: +200
- Leads capturados: 50
- Vendas: 8–10 (R$456–570)

---

### MÊS 2 — TRAÇÃO (meta: R$1.500)
**Foco:** Aumentar volume de conteúdo + primeiros depoimentos

- [ ] Gravar 28+ Reels (batch semanal)
- [ ] Coletar 3–5 depoimentos reais dos primeiros compradores
- [ ] Adicionar depoimentos à página de vendas
- [ ] Configurar automação Make.com (funil completo)
- [ ] Criar conta YouTube e publicar primeiros 4 vídeos longos
- [ ] Iniciar blog com 4 artigos SEO (escolher 4 KWs de baixa dificuldade)

**KPIs Mês 2:**
- Seguidores novos: +400
- Leads capturados: 150
- Vendas: 20–25 (R$1.140–1.425)

---

### MÊS 3 — ESCALA ORGÂNICA (meta: R$2.500)
**Foco:** Um Reel viral muda tudo — estar pronto para receber o tráfego

- [ ] 28+ Reels publicados
- [ ] 8 vídeos YouTube
- [ ] Blog com 8–10 artigos (começar a ranquear no Google)
- [ ] Testar Meta Ads com R$300/mês (aprendizado)
- [ ] Lançar sequência WhatsApp para leads existentes
- [ ] Testar variantes de preço (A/B R$47 vs R$57)

**KPIs Mês 3:**
- Seguidores novos: +600
- Leads capturados: 300
- Vendas: 35–45 (R$2.000–2.565)

---

### MÊS 4 — CONSOLIDAÇÃO (meta: R$3.500)
**Foco:** Ativar tráfego pago + lançar Clube

- [ ] Meta Ads: R$600/mês de investimento
- [ ] Google Ads: R$300/mês (blog + YouTube)
- [ ] Lançar Clube Vino Bianco (R$47/mês)
- [ ] Email de lançamento do Clube para base de compradores
- [ ] Afiliados: recrutar 3–5 afiliados (30% de comissão)
- [ ] Vídeos YouTube chegando a 100 inscritos+ (busca orgânica começa)

**KPIs Mês 4:**
- Leads/mês: 500+
- Vendas ebook: 45
- Clube: 10–15 assinantes
- Receita total: R$3.500+

---

### MÊS 5 — OTIMIZAÇÃO (meta: R$4.200)
**Foco:** Cortar o que não funciona, dobrar o que funciona

- [ ] Analisar os 5 Reels com mais conversão — replicar o formato
- [ ] Analisar emails com maior abertura/clique — replicar o assunto
- [ ] Otimizar Meta Ads (pausar anúncios com CPA > R$20)
- [ ] Lançar Curso Fundamentos (R$97/67) para base de compradores
- [ ] Email + WhatsApp para compradores do ebook (upsell do curso)
- [ ] Artigos de blog começando a aparecer no Google (posições 5–20)

**KPIs Mês 5:**
- Receita ebook: R$2.500
- Receita curso: R$800
- Clube: R$700 (15 assinantes)
- Total: R$4.000+

---

### MÊS 6 — R$5.000 ATINGIDO (meta: R$5.000+)
**Foco:** Máquina rodando — resultado da consistência dos 5 meses anteriores

- [ ] Tráfego orgânico (Instagram + YouTube + SEO) gerando 50+ leads/semana
- [ ] Afiliados gerando 20–30% das vendas
- [ ] Clube com 20+ assinantes recorrentes
- [ ] Considerar lançamento do Curso Premium (R$297) — webinar ou e-mail launch

**Receita Mês 6:**
```
Ebook (60 vendas × R$57)          = R$3.420
Order Bump (18 × R$17)            = R$306
Curso Fundamentos (12 × R$67)     = R$804
Clube (20 × R$47)                 = R$940
Menos: anúncios                   = -R$900
─────────────────────────────────────────
RECEITA LÍQUIDA                   = R$4.570+

Com afiliados ou consultoria       = R$5.000+ ✅
```

---

## REGRAS FUNDAMENTAIS DO PLANO

### Regra 1 — Consistência Vence Qualidade Perfeita
> 5 Reels medianos toda semana valem mais que 1 Reel perfeito por mês.
> O algoritmo recompensa frequência. Você recompensa qualidade. Faça os dois.

### Regra 2 — Um Canal por Vez até Funcionar
> Instagram primeiro. Quando gerar 20+ leads/semana de forma consistente, abrir YouTube.
> Quando YouTube tiver 200+ inscritos, abrir Google Ads. Não diluir esforço.

### Regra 3 — A Venda Começa no Conteúdo
> Cada Reel é um vendedor 24h/dia. Invista tempo na qualidade dos roteiros.
> 1 Reel viral pode gerar R$5.000 sozinho. Trate cada roteiro como um ativo.

### Regra 4 — Dados Guiam, Instinto Executa
> Revisar o dashboard toda segunda-feira. 30 minutos. Ajustar o que os números pedem.
> Mas não paralise por falta de dados — execute e ajuste.

### Regra 5 — O Dinheiro Está na Lista
> Construir a lista de emails e WhatsApp desde o dia 1.
> Um lead hoje vale R$0. Em 90 dias de nutrição, pode valer R$57, R$97 ou R$297.

---

## INVESTIMENTO INICIAL ESTIMADO

| Item                        | Custo        | Quando         |
|-----------------------------|--------------|----------------|
| Canva Pro (design ebook)    | R$55/mês     | Mês 1          |
| Hotmart (plataforma)        | R$0 (% venda)| Mês 1          |
| Mailchimp (até 500 contatos)| R$0          | Mês 1          |
| ManyChat (básico)           | R$0–R$65/mês | Mês 1          |
| Domínio + hospedagem        | R$30–80/mês  | Mês 1          |
| Z-API (WhatsApp)            | R$69/mês     | Mês 2          |
| Make.com (automações)       | R$29/mês     | Mês 2          |
| Meta Ads (aprendizado)      | R$300/mês    | Mês 3          |
| Google Ads                  | R$300/mês    | Mês 4          |
| **TOTAL MÊS 1**             | **R$85–135** |                |
| **TOTAL MÊS 3+**            | **R$550–700**|                |

**ROI projetado Mês 6:** R$5.000 receita / R$700 custo = **714% de ROI**

---

## CHECKLIST SEMANAL DE EXECUÇÃO

**Segunda:**
- [ ] Revisar dashboard da semana anterior (30 min)
- [ ] Planejar 5 Reels da semana (roteiros)
- [ ] Responder DMs e comentários acumulados

**Terça/Quarta:**
- [ ] Gravar batch de Reels (1–2h)
- [ ] Editar no CapCut com legendas

**Quinta:**
- [ ] Agendar Reels no Meta Business Suite
- [ ] Enviar email da semana para a lista
- [ ] Escrever 1 artigo de blog (se no mês 2+)

**Sexta:**
- [ ] Story com CTA para lead magnet ou ebook
- [ ] Revisão das métricas Instagram da semana

**Sábado/Domingo:**
- [ ] Responder comentários dos Reels
- [ ] Engajar em perfis do nicho (comentários estratégicos)
- [ ] Aprender: 1 artigo ou vídeo sobre marketing digital
```

---

## RESUMO EXECUTIVO

| Mês | Meta Receita | Ação Principal                    |
|-----|-------------|-----------------------------------|
| 1   | R$500       | Produto pronto + primeiros Reels  |
| 2   | R$1.500     | Volume de conteúdo + depoimentos  |
| 3   | R$2.500     | Escala orgânica + blog + Ads test |
| 4   | R$3.500     | Tráfego pago + Clube lançado      |
| 5   | R$4.200     | Otimização + Curso lançado        |
| 6   | R$5.000+    | Máquina rodando                   |
