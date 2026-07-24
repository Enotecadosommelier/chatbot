# Fluxo 1 — VINHO DA SEMANA
## Nome no ManyChat: `FLUXO_VINHO_DA_SEMANA`

---

## DISPARO

- **Quando:** Toda terça-feira, 09:00
- **Como:** Broadcast agendado do ManyChat (WhatsApp → Broadcasting → Schedule → Repeat weekly) **ou**, se o plano do ManyChat não tiver recorrência nativa de broadcast para WhatsApp, um agendador externo (Make.com / Pabbly Connect, gatilho semanal terça 09:00) chama o endpoint `POST /fb/sending/sendFlow` da API do ManyChat apontando para este Flow, para o segmento "todos os inscritos ativos, exceto tag `Não responde há 30 dias`"
- **Segmento de envio:** todos os contatos com tag `Cliente Novo` OU `Cliente Frequente` OU `Cliente VIP` (ou seja, todo mundo que já é contato ativo), excluindo quem tem tag `Não responde há 30 dias` (esses entram no fluxo de reengajamento, não na régua normal)

---

## ESTRUTURA DA MENSAGEM (template a seguir em toda semana)

```
🍷 {NOME DO VINHO}

📍 País: {país}
🗺️ Região: {região}
🍇 Uva(s): {uva(s)}
🏛️ Produtor: {produtor}

👃 Notas aromáticas: {notas}
👅 Paladar: {paladar}
🌡️ Temperatura de serviço: {temperatura}
⏳ Potencial de guarda: {guarda}
💰 Faixa de preço: {faixa de preço}

{2-3 linhas explicando por que vale a pena conhecer — história, curiosidade ou diferencial}

Gostaria de receber mais informações ou reservar uma garrafa?
```

**Botões (Quick Replies / Buttons):**
1. `Quero saber mais`
2. `Ver ofertas`
3. `Falar com Sommelier`

---

## LÓGICA DO FLOW NO MANYCHAT (passo a passo dos blocos)

```
[Trigger: Broadcast semanal / External Request]
    ↓
[Content Block] → Envia mensagem estruturada do vinho da semana (variáveis do calendário, ver 05-calendario-anual.md)
    ↓
[Smart Delay: 3 segundos] (dá tempo do WhatsApp renderizar antes dos botões — evita bug de UI)
    ↓
[Buttons Block] → "Quero saber mais" | "Ver ofertas" | "Falar com Sommelier"
    ↓
[Condition: qual botão foi clicado?]
    ├── Quero saber mais →
    │     [Content Block] envia curiosidade extra + sugestão de harmonização rápida
    │     [Action] Add Tag: "Interesse Semana Atual"
    │     [Action] Set Custom Field: contador_semanas_sem_clique = 0
    │     [Action] Goal Met: "Engajamento Semanal"
    │
    ├── Ver ofertas →
    │     [Content Block] envia link do produto / catálogo
    │     [Action] Add Tag: "Interesse Promoções"
    │     [Action] Set Custom Field: contador_semanas_sem_clique = 0
    │     [Action] Goal Met: "Engajamento Semanal"
    │     [External Request] (preparado, inativo) → consulta estoque/preço em tempo real na Shopify
    │
    └── Falar com Sommelier →
          [Action] Live Chat Handoff (notifica equipe humana)
          [Action] Set Custom Field: sommelier_responsavel = {atendente disponível}
          [Action] Goal Met: "Engajamento Semanal"
    ↓
[Smart Delay: 48 horas] (só segue se NENHUM botão foi clicado)
    ↓
[Condition: Goal "Engajamento Semanal" atingida?]
    ├── Sim → Fim do flow (silencioso)
    └── Não →
          [Content Block] Mensagem de lembrete suave (ver abaixo)
          [Action] Increment Custom Field: contador_semanas_sem_clique +1
          [Condition] Se contador_semanas_sem_clique >= 4 → Add Tag: "Não responde há 30 dias"
```

**Mensagem de lembrete (48h sem clique):**
> {nome}, ainda dá tempo de conhecer o {NOME DO VINHO} desta semana 🍷 Ele é ideal para quem gosta de {característica principal}. Se quiser, é só me chamar.

---

## EXEMPLOS COMPLETOS — PRONTOS PARA COPIAR E COLAR

### Semana 1

> 🍷 **Catena Zapata Malbec Argentino**
>
> 📍 País: Argentina
> 🗺️ Região: Mendoza (Vale de Uco)
> 🍇 Uva: Malbec
> 🏛️ Produtor: Bodega Catena Zapata
>
> 👃 Notas aromáticas: ameixa madura, violeta, um toque de baunilha do carvalho
> 👅 Paladar: encorpado, taninos macios, final longo e levemente especiado
> 🌡️ Temperatura de serviço: 16–18°C
> ⏳ Potencial de guarda: 5 a 8 anos
> 💰 Faixa de preço: R$ 89–120
>
> Esse é o rótulo que colocou a Argentina no mapa dos grandes vinhos do mundo. A altitude do Vale de Uco (mais de 1.000m) dá à uva uma acidez que equilibra o corpo — por isso ele não cansa o paladar mesmo sendo encorpado.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

### Semana 2

> 🍷 **Château Pichon Baron**
>
> 📍 País: França
> 🗺️ Região: Bordeaux (Pauillac)
> 🍇 Uva: Cabernet Sauvignon (predominante), Merlot
> 🏛️ Produtor: Château Pichon Longueville Baron
>
> 👃 Notas aromáticas: cassis, grafite, tabaco, cedro
> 👅 Paladar: taninos firmes e elegantes, estrutura clássica de Pauillac
> 🌡️ Temperatura de serviço: 17–18°C
> ⏳ Potencial de guarda: 15 a 25 anos
> 💰 Faixa de preço: R$ 650–900
>
> Vizinho do lendário Château Latour, este é um dos "segundos classificados" de 1855 que mais surpreende: tem a estrutura dos grandes Pauillac por um preço ainda acessível dentro da categoria de ícones bordalezes.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

### Semana 3

> 🍷 **Ferrari Perlé Trento DOC**
>
> 📍 País: Itália
> 🗺️ Região: Trentino (Trento DOC)
> 🍇 Uva: Chardonnay
> 🏛️ Produtor: Ferrari (Lunelli Family)
>
> 👃 Notas aromáticas: maçã verde, brioche, flor branca
> 👅 Paladar: bolhas finas e persistentes, acidez viva, final cremoso
> 🌡️ Temperatura de serviço: 6–8°C
> ⏳ Potencial de guarda: consumir em até 3 anos (ideal já)
> 💰 Faixa de preço: R$ 180–230
>
> Feito pelo método clássico (mesma técnica do Champagne), com no mínimo 24 meses sobre leveduras. É a prova de que a Itália também faz espumantes de altíssimo nível fora da Champagne francesa.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

### Semana 4

> 🍷 **Casa Silva Cool Coast Sauvignon Blanc**
>
> 📍 País: Chile
> 🗺️ Região: Vale de Paredones (Costa)
> 🍇 Uva: Sauvignon Blanc
> 🏛️ Produtor: Viña Casa Silva
>
> 👃 Notas aromáticas: maracujá, capim-limão, toque salino
> 👅 Paladar: fresco, acidez vibrante, corpo leve
> 🌡️ Temperatura de serviço: 8–10°C
> ⏳ Potencial de guarda: consumir jovem, até 2 anos
> 💰 Faixa de preço: R$ 65–90
>
> Vinhas plantadas a poucos km do Oceano Pacífico — a brisa marinha e a neblina matinal seguram a maturação e preservam uma acidez rara para o clima chileno. Resultado: frescor que lembra Nova Zelândia por um terço do preço.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

### Semana 5

> 🍷 **Herdade do Esporão Reserva Tinto**
>
> 📍 País: Portugal
> 🗺️ Região: Alentejo
> 🍇 Uva: Aragonez, Trincadeira, Cabernet Sauvignon, Alicante Bouschet
> 🏛️ Produtor: Herdade do Esporão
>
> 👃 Notas aromáticas: frutas negras, especiarias, erva-doce
> 👅 Paladar: encorpado, macio, com final quente e envolvente
> 🌡️ Temperatura de serviço: 16–18°C
> ⏳ Potencial de guarda: 6 a 10 anos
> 💰 Faixa de preço: R$ 95–130
>
> O Alentejo tem verões quentes e secos que concentram fruta e maturam os taninos por completo — por isso os tintos de lá são macios mesmo sendo encorpados. Esse é o "cartão de visitas" da região para quem nunca provou vinho português.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

### Semana 6

> 🍷 **Miolo Lote 43**
>
> 📍 País: Brasil
> 🗺️ Região: Vale dos Vinhedos (Serra Gaúcha, RS)
> 🍇 Uva: Merlot, Cabernet Sauvignon, Tannat
> 🏛️ Produtor: Vinícola Miolo
>
> 👃 Notas aromáticas: amora, ameixa, notas de carvalho tostado
> 👅 Paladar: encorpado, taninos presentes e macios, final persistente
> 🌡️ Temperatura de serviço: 16–17°C
> ⏳ Potencial de guarda: 8 a 12 anos
> 💰 Faixa de preço: R$ 140–180
>
> Um dos tintos brasileiros mais premiados internacionalmente. Prova de que a Serra Gaúcha, com sua altitude e clima mais frio que o resto do Brasil, consegue produzir vinhos de guarda com padrão mundial.
>
> Gostaria de receber mais informações ou reservar uma garrafa?
>
> [Quero saber mais] [Ver ofertas] [Falar com Sommelier]

---

**As demais 46 semanas seguem exatamente este template**, com os vinhos, países e dados listados em `05-calendario-anual.md` (coluna "Fluxo 1 — Vinho"). Basta preencher os campos entre chaves com os dados daquela linha do calendário.
