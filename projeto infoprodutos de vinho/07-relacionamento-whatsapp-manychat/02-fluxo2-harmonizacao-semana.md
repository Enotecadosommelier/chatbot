# Fluxo 2 — HARMONIZAÇÃO DA SEMANA
## Nome no ManyChat: `FLUXO_HARMONIZACAO_DA_SEMANA`

---

## DISPARO

- **Quando:** Toda quinta-feira, 09:00
- **Como:** Broadcast agendado (mesmo mecanismo do Fluxo 1)
- **Segmento:** mesma regra do Fluxo 1 (todos os contatos ativos, exceto `Não responde há 30 dias`)

---

## ESTRUTURA DA MENSAGEM (template)

```
🍽️ Harmonização da Semana: {PRATO/CATEGORIA}

Por que funciona:
🍇 Acidez: {explicação}
🍷 Taninos: {explicação}
💪 Corpo: {explicação}
🔥 Intensidade: {explicação}
🌡️ Temperatura: {explicação}

Nossa seleção para essa combinação:
1. {Vinho 1} — {1 linha do porquê}
2. {Vinho 2} — {1 linha do porquê}
3. {Vinho 3} — {1 linha do porquê}

Quer receber nossa seleção desta harmonização?
```

**Botões:**
1. `Ver Vinhos`
2. `Comprar`
3. `Falar com Sommelier`

---

## LÓGICA DO FLOW

```
[Trigger: Broadcast semanal]
    ↓
[Content Block] → Explicação da harmonização (acidez/taninos/corpo/intensidade/temperatura)
    ↓
[Smart Delay: 3s]
    ↓
[Content Block] → 3 vinhos sugeridos
    ↓
[Smart Delay: 2s]
    ↓
[Buttons Block] → "Ver Vinhos" | "Comprar" | "Falar com Sommelier"
    ↓
[Condition: botão clicado?]
    ├── Ver Vinhos →
    │     [Content Block] catálogo filtrado por categoria da semana
    │     [Action] Add Tag conforme categoria (ex: "Interesse Espumantes" se aplicável)
    │     [Action] Goal Met: "Engajamento Semanal"
    │
    ├── Comprar →
    │     [Content Block] link de checkout direto
    │     [Action] Goal Met: "Conversão Harmonização"
    │     [Condition] Se 2ª compra em 90 dias → Add Tag: "Cliente Frequente"
    │     [External Request] (preparado, inativo) → cria pedido / atualiza CRM (RD Station)
    │
    └── Falar com Sommelier →
          [Action] Live Chat Handoff
          [Action] Goal Met: "Engajamento Semanal"
    ↓
[Smart Delay: 48h] (se nenhum clique)
    ↓
[Content Block] Lembrete: "{nome}, a seleção para {prato} ainda está disponível. Quer que eu separe pra você?"
[Action] Increment contador_semanas_sem_clique
```

---

## EXEMPLOS COMPLETOS — PRONTOS PARA COPIAR E COLAR

### Semana 1 — Carnes Vermelhas Grelhadas

> 🍽️ **Harmonização da Semana: Carnes Vermelhas Grelhadas**
>
> Por que funciona:
> 🍇 Acidez: média a alta — limpa a gordura da carne a cada gole
> 🍷 Taninos: presentes — "abraçam" a proteína e amaciam a sensação na boca
> 💪 Corpo: encorpado — não desaparece diante do sabor forte da carne
> 🔥 Intensidade: alta, para não ser ofuscado pelo tempero e pela brasa
> 🌡️ Temperatura: 16–18°C — mais frio que isso endurece os taninos
>
> Nossa seleção para essa combinação:
> 1. **Catena Zapata Malbec** — taninos macios que combinam com carnes suculentas
> 2. **Château Pichon Baron** — para ocasiões especiais com cortes nobres
> 3. **Miolo Lote 43** — opção nacional de ótimo custo-benefício para o dia a dia
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

### Semana 2 — Massas ao Molho Vermelho

> 🍽️ **Harmonização da Semana: Massas ao Molho Vermelho (Tomate)**
>
> Por que funciona:
> 🍇 Acidez: alta — precisa "conversar" com a acidez natural do tomate, não competir
> 🍷 Taninos: baixos a médios — para não deixar o molho ácido com gosto metálico
> 💪 Corpo: médio
> 🔥 Intensidade: média
> 🌡️ Temperatura: 14–16°C
>
> Nossa seleção para essa combinação:
> 1. **Chianti Classico (Sangiovese)** — a clássica combinação italiana, acidez que dialoga com o tomate
> 2. **Barbera d'Alba** — acidez ainda mais viva, ótima para molhos mais encorpados
> 3. **Tannat jovem uruguaio** — opção mais robusta para quem gosta de molho com carne moída
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

### Semana 3 — Risotos Cremosos

> 🍽️ **Harmonização da Semana: Risotos Cremosos (Funghi, Parmesão)**
>
> Por que funciona:
> 🍇 Acidez: alta — corta a gordura da manteiga e do queijo
> 🍷 Taninos: baixos — taninos altos deixam o creme com gosto amargo
> 💪 Corpo: médio a encorpado, para acompanhar a cremosidade
> 🔥 Intensidade: média
> 🌡️ Temperatura: 10–12°C (branco encorpado) ou 14°C (tinto leve)
>
> Nossa seleção para essa combinação:
> 1. **Chardonnay com passagem por carvalho** — cremosidade encontra cremosidade
> 2. **Pinot Grigio italiano** — opção mais leve e refrescante
> 3. **Pinot Noir** — se o risoto tiver funghi/cogumelos, o tinto leve realça o umami
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

### Semana 4 — Peixes Grelhados

> 🍽️ **Harmonização da Semana: Peixes Grelhados (Robalo, Salmão)**
>
> Por que funciona:
> 🍇 Acidez: alta — realça o frescor do peixe
> 🍷 Taninos: praticamente ausentes — taninos deixam peixe com gosto metálico
> 💪 Corpo: leve a médio
> 🔥 Intensidade: baixa a média
> 🌡️ Temperatura: 8–10°C
>
> Nossa seleção para essa combinação:
> 1. **Sauvignon Blanc chileno (Costa)** — frescor e nota salina que combinam com peixe grelhado
> 2. **Albariño** (Rías Baixas, Espanha) — clássico para peixes e frutos do mar
> 3. **Rosé provençal seco** — se o salmão for grelhado com manteiga, o rosé equilibra bem
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

### Semana 5 — Queijos

> 🍽️ **Harmonização da Semana: Tábua de Queijos**
>
> Por que funciona:
> 🍇 Acidez: varia por tipo de queijo — queijos gordurosos pedem mais acidez
> 🍷 Taninos: cuidado — queijos muito curados podem deixar taninos amargos; queijos frescos combinam com tintos leves ou brancos
> 💪 Corpo: depende do queijo — regra geral: queijo leve → vinho leve; queijo forte → vinho mais estruturado
> 🔥 Intensidade: equilibrar com a intensidade do queijo, nunca deixar o queijo "vencer"
> 🌡️ Temperatura: 12–16°C conforme o vinho
>
> Nossa seleção para essa combinação:
> 1. **Espumante Brut** — combina com quase qualquer queijo, das bolhas à acidez
> 2. **Porto Tawny** — para queijos azuis (tipo Gorgonzola), a doçura contrasta com o sal
> 3. **Chardonnay leve** — para queijos frescos tipo Brie e Camembert
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

### Semana 6 — Comida Japonesa

> 🍽️ **Harmonização da Semana: Comida Japonesa (Sushi, Sashimi)**
>
> Por que funciona:
> 🍇 Acidez: alta — equilibra o vinagre do arroz e a gordura do peixe cru
> 🍷 Taninos: ausentes — taninos reagem mal com peixe cru, criando gosto metálico
> 💪 Corpo: leve
> 🔥 Intensidade: baixa, para não sobrepor o sabor delicado do peixe
> 🌡️ Temperatura: 6–8°C
>
> Nossa seleção para essa combinação:
> 1. **Espumante Brut Nature** — bolhas limpam o paladar entre um sushi e outro
> 2. **Riesling seco alemão** — acidez alta com leve doçura que contrasta com o shoyu
> 3. **Sauvignon Blanc neozelandês** — frescor cítrico clássico para peixe cru
>
> Quer receber nossa seleção desta harmonização?
>
> [Ver Vinhos] [Comprar] [Falar com Sommelier]

---

**As demais 46 semanas** seguem este template, alternando entre as categorias do calendário (`05-calendario-anual.md`, coluna "Fluxo 2 — Harmonização"): churrasco, frutos do mar, comida italiana (outras variações), comida brasileira (feijoada, moqueca, picanha), queijos (variações), massas (variações), carnes (variações: cordeiro, porco, aves), sobremesas, entre outras — sempre sem repetir o prato exato já usado no ano.
