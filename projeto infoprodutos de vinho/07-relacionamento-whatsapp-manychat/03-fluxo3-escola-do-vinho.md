# Fluxo 3 — ESCOLA DO VINHO
## Nome no ManyChat: `FLUXO_ESCOLA_DO_VINHO`

---

## DISPARO

- **Quando:** Sexta-feira, 09:00, em semanas alternadas (ver regra de alternância em `00-arquitetura-geral.md`)
- **Controle de alternância:** antes de disparar, o flow verifica o Custom Field `ultimo_fluxo_sexta`. Se for `mundo` ou vazio, dispara este Fluxo 3 e atualiza o campo para `escola`. Se for `escola`, pula a vez (quem dispara nessa sexta é o Fluxo 4).

---

## ESTRUTURA DA MENSAGEM (template)

```
🎓 Escola do Vinho — {TEMA DA AULA}

{Explicação em linguagem simples, sem jargão não traduzido — menos de 2 minutos de leitura}

💡 Curiosidade: {fato curioso relacionado ao tema}

{CTA leve}
```

**CTA (Randomizer — alterna entre as duas variações abaixo a cada semana, para não ficar repetitivo):**
- Variação A: "Quer aprofundar nesse tema? Responda AULA que te mando mais."
- Variação B: "Ficou com alguma dúvida sobre isso? Me conta aqui 😊"

---

## LÓGICA DO FLOW

```
[Trigger: Broadcast semanal, condicionado a ultimo_fluxo_sexta ≠ escola]
    ↓
[Content Block] → Aula do tema da semana (ver calendário)
    ↓
[Smart Delay: 2s]
    ↓
[Content Block] → Curiosidade final
    ↓
[Smart Delay: 1s]
    ↓
[Randomizer 50/50] → CTA Variação A ou B
    ↓
[Condition: respondeu "AULA" ou enviou mensagem livre?]
    ├── Respondeu "AULA" →
    │     [Content Block] envia conteúdo complementar (link para material mais completo, se existir)
    │     [Action] Goal Met: "Engajamento Semanal"
    │
    └── Enviou dúvida em texto livre →
          [Action] Live Chat Handoff (a dúvida vai para o sommelier responder pessoalmente)
    ↓
[Action] Set Custom Field: ultimo_fluxo_sexta = "escola"
```

---

## EXEMPLOS COMPLETOS — PRONTOS PARA COPIAR E COLAR

### Aula 1 — Como Ler um Rótulo de Vinho

> 🎓 **Escola do Vinho — Como Ler um Rótulo**
>
> Todo rótulo tem 4 informações essenciais: **produtor**, **safra** (ano da colheita), **região/denominação** e **teor alcoólico**. Se o rótulo trouxer o nome da uva, ótimo — mas muitos vinhos europeus (França, Itália) não mostram a uva, só a região, porque lá a região já "avisa" qual uva é usada por lei.
>
> 💡 Curiosidade: na França, dizer "Borgonha" no rótulo já informa que é Pinot Noir (tinto) ou Chardonnay (branco) — são as únicas uvas permitidas na região por lei.
>
> Quer aprofundar nesse tema? Responda AULA que te mando mais.

---

### Aula 2 — Diferença entre Reserva e Gran Reserva

> 🎓 **Escola do Vinho — Reserva x Gran Reserva**
>
> Esses termos indicam tempo de envelhecimento antes de ir para o mercado — mas o tempo exigido muda por país. Na Espanha (Rioja, por exemplo): "Reserva" exige mínimo 3 anos (1 em barrica), "Gran Reserva" exige mínimo 5 anos (2 em barrica). Em outros países, o termo pode ser só uma escolha do produtor, sem regra legal.
>
> 💡 Curiosidade: por isso, um "Reserva" espanhol garante um padrão mínimo por lei — mas um "Reserva" de outro país pode significar critérios bem diferentes.
>
> Ficou com alguma dúvida sobre isso? Me conta aqui 😊

---

### Aula 3 — O que é Terroir

> 🎓 **Escola do Vinho — O que é Terroir**
>
> Terroir é a combinação única de solo, clima, altitude e tradição de uma região que dá "personalidade" ao vinho. A mesma uva Malbec, plantada na Argentina e na França, produz vinhos completamente diferentes — não é a uva sozinha que define o vinho, é o lugar onde ela cresce.
>
> 💡 Curiosidade: existem vinhas no mesmo vinhedo, a poucos metros de distância, que produzem uvas com sabores perceptivelmente diferentes por causa de pequenas variações no solo.
>
> Quer aprofundar nesse tema? Responda AULA que te mando mais.

---

### Aula 4 — Taninos: o que são e por que importam

> 🎓 **Escola do Vinho — O que são Taninos**
>
> Taninos são compostos que vêm da casca, semente e caule da uva (e também do carvalho da barrica). Eles dão aquela sensação de "secar a boca" — por isso vinhos tintos encorpados combinam tão bem com carnes gordurosas: a proteína e a gordura suavizam essa sensação.
>
> 💡 Curiosidade: é por isso que vinho tinto muito tânico tomado sozinho, sem comida, pode parecer "áspero" — ele foi feito para ser bebido à mesa, não sozinho.
>
> Ficou com alguma dúvida sobre isso? Me conta aqui 😊

---

### Aula 5 — Como Servir Vinho na Temperatura Certa

> 🎓 **Escola do Vinho — Temperatura de Serviço**
>
> Regra prática: espumantes e brancos leves, 6–8°C (geladeira comum já resolve). Brancos encorpados e rosés, 10–12°C. Tintos leves, 14–16°C. Tintos encorpados, 16–18°C — nunca "temperatura ambiente" de verão brasileiro, que costuma passar dos 25°C.
>
> 💡 Curiosidade: tinto servido muito quente destaca o álcool e deixa o vinho "pesado"; por isso muita gente errada acha que não gosta de tinto, quando na verdade só bebeu ele quente demais.
>
> Quer aprofundar nesse tema? Responda AULA que te mando mais.

---

### Aula 6 — Como Abrir um Espumante Corretamente

> 🎓 **Escola do Vinho — Como Abrir Espumante sem Acidentes**
>
> Nunca "estoure" a rolha. Seguindo esse passo a passo: retire o papel alumínio, segure a rolha firme com uma mão, gire a garrafa (não a rolha) devagar, segurando a pressão até sentir a rolha soltando com um "suspiro", não um estouro.
>
> 💡 Curiosidade: a pressão dentro de uma garrafa de espumante é parecida com a de um pneu de ônibus — por isso a rolha pode virar um projétil perigoso se aberta errado.
>
> Ficou com alguma dúvida sobre isso? Me conta aqui 😊

---

**As demais 46 aulas** (de um total de ~26 slots de sexta destinados à Escola do Vinho, já que sexta alterna com o Fluxo 4) seguem este template, cobrindo os temas do calendário (`05-calendario-anual.md`): tipos de uva, DOC/DOCG/AOC/IGP, safra, envelhecimento, barricas, como armazenar, taças por tipo de vinho, como escolher vinho em restaurante, como comprar vinho, como decantar, entre outros — sempre com curiosidade final e CTA alternado.
