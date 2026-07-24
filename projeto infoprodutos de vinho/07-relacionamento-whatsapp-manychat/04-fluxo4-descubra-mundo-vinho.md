# Fluxo 4 — DESCUBRA O MUNDO DO VINHO
## Nome no ManyChat: `FLUXO_DESCUBRA_MUNDO_VINHO`

---

## DISPARO

- **Quando:** Sexta-feira, 09:00, em semanas alternadas (a outra metade das sextas, complementar ao Fluxo 3)
- **Controle de alternância:** verifica `ultimo_fluxo_sexta`. Se for `escola`, dispara este Fluxo 4 e atualiza o campo para `mundo`. Se for `mundo`, pula a vez.

---

## ESTRUTURA DA MENSAGEM (template)

```
🌍 Descubra o Mundo do Vinho: {PAÍS}

📜 História: {2-3 linhas}
🗺️ Principais regiões: {lista}
🍇 Principais uvas: {lista}
🎨 Estilo dos vinhos: {descrição}
✨ Características: {o que torna único}
🏛️ Produtores famosos: {2-3 nomes}
💡 Curiosidade: {fato interessante}

Nossa seleção de {país}:
1. {Rótulo 1}
2. {Rótulo 2}
3. {Rótulo 3}
```

**CTA:** "Quer conhecer nossa seleção completa de {país}?" com botões `Ver Seleção` | `Falar com Sommelier`

---

## LÓGICA DO FLOW

```
[Trigger: Broadcast semanal, condicionado a ultimo_fluxo_sexta ≠ mundo]
    ↓
[Content Block] → História + regiões + uvas do país
    ↓
[Smart Delay: 3s]
    ↓
[Content Block] → Estilo + características + produtores + curiosidade
    ↓
[Smart Delay: 2s]
    ↓
[Content Block] → 3 rótulos sugeridos
    ↓
[Buttons Block] → "Ver Seleção" | "Falar com Sommelier"
    ↓
[Condition: botão clicado?]
    ├── Ver Seleção →
    │     [Content Block] catálogo filtrado pelo país
    │     [Action] Add Tag conforme país (ex: "Interesse Itália", "Interesse Bordeaux" se França)
    │     [Action] Goal Met: "Engajamento Semanal"
    │
    └── Falar com Sommelier →
          [Action] Live Chat Handoff
          [Action] Goal Met: "Engajamento Semanal"
    ↓
[Action] Set Custom Field: ultimo_fluxo_sexta = "mundo"
```

---

## EXEMPLOS COMPLETOS — PRONTOS PARA COPIAR E COLAR

### País 1 — França

> 🌍 **Descubra o Mundo do Vinho: França**
>
> 📜 História: berço da viticultura moderna e origem do sistema de classificação por região (terroir) que o mundo todo copiou depois.
> 🗺️ Principais regiões: Bordeaux, Borgonha (Bourgogne), Champagne, Vale do Rhône, Loire, Alsácia
> 🍇 Principais uvas: Cabernet Sauvignon, Merlot (Bordeaux) / Pinot Noir, Chardonnay (Borgonha) / Syrah, Grenache (Rhône)
> 🎨 Estilo dos vinhos: elegância e equilíbrio acima de potência — os franceses buscam harmonia entre acidez, taninos e fruta
> ✨ Características: o rótulo indica a região, não a uva — decorar "quem é de onde" é a chave para entender vinho francês
> 🏛️ Produtores famosos: Château Margaux, Domaine de la Romanée-Conti, Moët & Chandon
> 💡 Curiosidade: a classificação oficial de Bordeaux de 1855 continua praticamente igual até hoje — mudou só 1 vez, em 1973.
>
> Nossa seleção de França:
> 1. Château Pichon Baron (Bordeaux, tinto de guarda)
> 2. Louis Jadot Bourgogne (Borgonha, Pinot Noir)
> 3. Moët & Chandon Brut Impérial (Champagne)
>
> Quer conhecer nossa seleção completa de França?
>
> [Ver Seleção] [Falar com Sommelier]

---

### País 2 — Itália

> 🌍 **Descubra o Mundo do Vinho: Itália**
>
> 📜 História: a Itália produz vinho há mais de 3 mil anos e é, junto com a França, uma das duas maiores produtoras mundiais — com a maior diversidade de uvas nativas do planeta.
> 🗺️ Principais regiões: Toscana, Piemonte, Vêneto, Sicília
> 🍇 Principais uvas: Sangiovese (Toscana), Nebbiolo (Piemonte), Glera (Prosecco), Primitivo
> 🎨 Estilo dos vinhos: acidez marcante que combina naturalmente com comida — a Itália praticamente "não faz" vinho para beber sem comer
> ✨ Características: mais de 500 castas de uva registradas — nenhum outro país tem essa diversidade
> 🏛️ Produtores famosos: Antinori, Gaja, Ferrari
> 💡 Curiosidade: o Barolo (Piemonte, uva Nebbiolo) já foi chamado de "rei dos vinhos, vinho dos reis" — era o favorito da realeza italiana no século XIX.
>
> Nossa seleção de Itália:
> 1. Chianti Classico (Toscana, Sangiovese)
> 2. Ferrari Perlé Trento DOC (espumante método clássico)
> 3. Barolo (Piemonte, Nebbiolo, guarda longa)
>
> Quer conhecer nossa seleção completa de Itália?
>
> [Ver Seleção] [Falar com Sommelier]

---

### País 3 — Portugal

> 🌍 **Descubra o Mundo do Vinho: Portugal**
>
> 📜 História: um dos países com mais uvas nativas preservadas do mundo — enquanto o resto do mundo adotou Cabernet e Chardonnay, Portugal manteve suas próprias castas.
> 🗺️ Principais regiões: Douro, Alentejo, Vinho Verde
> 🍇 Principais uvas: Touriga Nacional, Aragonez (Tempranillo local), Trincadeira
> 🎨 Estilo dos vinhos: do encorpado e intenso (Douro) ao leve e refrescante (Vinho Verde) — grande variedade de estilos num país pequeno
> ✨ Características: é também o berço do Vinho do Porto, fortificado e adocicado
> 🏛️ Produtores famosos: Herdade do Esporão, Quinta do Crasto, Taylor's (Porto)
> 💡 Curiosidade: a região do Douro tem terraços de vinha esculpidos em encostas de xisto tão íngremes que a colheita ainda é feita à mão até hoje.
>
> Nossa seleção de Portugal:
> 1. Herdade do Esporão Reserva Tinto (Alentejo)
> 2. Quinta do Crasto Reserva (Douro)
> 3. Taylor's 10 Anos (Vinho do Porto)
>
> Quer conhecer nossa seleção completa de Portugal?
>
> [Ver Seleção] [Falar com Sommelier]

---

### País 4 — Argentina

> 🌍 **Descubra o Mundo do Vinho: Argentina**
>
> 📜 História: a Malbec chegou da França no século XIX e quase desapareceu por lá — foi na Argentina, com a altitude dos Andes, que ela encontrou seu ambiente perfeito e virou a uva mais famosa do país.
> 🗺️ Principais regiões: Mendoza (Vale de Uco, Luján de Cuyo), Salta
> 🍇 Principais uvas: Malbec, Torrontés (branco aromático típico argentino)
> 🎨 Estilo dos vinhos: frutados, encorpados, com acidez equilibrada pela altitude das vinhas
> ✨ Características: vinhedos de altíssima altitude — alguns passam de 1.500m, entre os mais altos do mundo
> 🏛️ Produtores famosos: Catena Zapata, Achaval Ferrer, Zuccardi
> 💡 Curiosidade: quanto mais alta a vinha, maior a diferença de temperatura entre dia e noite — isso preserva a acidez da uva mesmo em clima quente.
>
> Nossa seleção de Argentina:
> 1. Catena Zapata Malbec (Mendoza)
> 2. Zuccardi Serie A Malbec (bom custo-benefício)
> 3. Colomé Torrontés (Salta, branco aromático)
>
> Quer conhecer nossa seleção completa de Argentina?
>
> [Ver Seleção] [Falar com Sommelier]

---

**Os demais países** (Chile, Brasil, Espanha, Alemanha, África do Sul, Austrália, Nova Zelândia) seguem este mesmo template. Como as sextas alternam com o Fluxo 3, cada país pode aparecer mais de uma vez ao ano com **ângulos diferentes** (ex: 1ª aparição = visão geral do país; 2ª aparição = "uvas nativas menos conhecidas" ou "os produtores boutique") para completar os ~26 slots de sexta sem repetir conteúdo — ver detalhamento em `05-calendario-anual.md`.
