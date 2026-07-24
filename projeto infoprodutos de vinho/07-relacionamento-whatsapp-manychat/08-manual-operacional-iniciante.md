# Manual Operacional — Passo a Passo para Quem Nunca Usou ManyChat
## Sem necessidade de programação

Este manual assume que você não sabe nada de tecnologia. Siga na ordem, sem pular etapas.

---

## PARTE 1 — Antes de tudo

1. Confirme que você tem uma conta no **ManyChat** (app.manychat.com) já conectada ao **WhatsApp Business** da loja
2. Confirme que o plano da conta é **Pro** (fica em Settings → Billing). Sem isso, algumas automações e a API não funcionam
3. Tenha em mãos este documento e os arquivos da pasta `07-relacionamento-whatsapp-manychat/`

---

## PARTE 2 — Criando as Tags (etiquetas de cliente)

1. No menu esquerdo do ManyChat, clique em **"Contatos" (Audience)**
2. Procure a aba ou botão **"Tags"**
3. Clique em **"+ Nova Tag"** (ou "+ New Tag")
4. Digite o nome exatamente como está na lista abaixo (maiúsculas e acentos importam) e clique em salvar
5. Repita para cada uma das 14 tags:

```
Cliente Novo
Cliente VIP
Comprou Espumante
Comprou Branco
Comprou Rosé
Comprou Tinto
Cliente Frequente
Interesse Bordeaux
Interesse Itália
Interesse Portugal
Interesse Espumantes
Interesse Promoções
Não responde há 30 dias
Reengajado
```

---

## PARTE 3 — Criando os Custom Fields (campos do cliente)

1. Ainda em "Contatos", procure a aba **"Custom Fields"** (ou "Campos Personalizados")
2. Clique em **"+ Novo Campo"**
3. Para cada linha abaixo, digite o **Nome do campo** e escolha o **Tipo** correspondente:

| Nome do campo (digite exatamente assim) | Tipo a escolher |
|---|---|
| nome | Texto |
| ultimo_vinho_comprado | Texto |
| data_ultima_compra | Data |
| cidade | Texto |
| estado | Texto |
| tipo_favorito | Texto |
| faixa_de_preco | Texto |
| data_aniversario | Data |
| sommelier_responsavel | Texto |
| ticket_medio | Número |
| ultimo_fluxo_sexta | Texto |
| contador_semanas_sem_clique | Número |

**Atalho:** se você tiver alguém da equipe com conhecimento técnico, essa parte (Tags + Custom Fields) pode ser feita automaticamente com o arquivo `manychat_setup.py` — mas não é obrigatório, dá para fazer tudo manualmente como acima.

---

## PARTE 4 — Criando o primeiro Flow (Fluxo 1 — Vinho da Semana)

1. No menu esquerdo, clique em **"Automation"**
2. Clique em **"+ New Flow"** (ou "+ Novo Flow")
3. Dê o nome exato: `FLUXO_VINHO_DA_SEMANA`
4. Você vai ver uma tela em branco com um quadrado de início. Clique no **"+"** para adicionar o primeiro bloco
5. Escolha o tipo de bloco **"Send Content"** (ou "Enviar Conteúdo")
6. Cole a mensagem completa da Semana 1 (está em `01-fluxo1-vinho-da-semana.md`, seção "Exemplos Completos")
7. Ainda dentro desse mesmo bloco, adicione os 3 botões no final:
   - `Quero saber mais`
   - `Ver ofertas`
   - `Falar com Sommelier`
8. Clique em cada botão criado e conecte uma seta para um novo bloco (explicado na Parte 5)
9. Clique em **"Save"** e depois em **"Publish"** para salvar o flow (ele ainda não vai disparar sozinho — isso é configurado na Parte 7)

---

## PARTE 5 — Conectando as ações de cada botão

Para o botão **"Quero saber mais"**:
1. Clique no ponto de saída do botão e arraste até um novo bloco
2. Escolha **"Send Content"** → cole o texto de curiosidade extra
3. Adicione um bloco de ação **"Add Tag"** → escolha a tag `Interesse Semana Atual` (se essa tag ainda não existir, crie-a rapidamente clicando em "criar nova")
4. Adicione um bloco **"Set Field Value"** → escolha `contador_semanas_sem_clique` → valor `0`

Para o botão **"Ver ofertas"**:
1. Conecte a um bloco **"Send Content"** com o link do produto
2. Adicione **"Add Tag"** → `Interesse Promoções`

Para o botão **"Falar com Sommelier"**:
1. Conecte a um bloco de ação chamado **"Live Chat"** (ou "Handoff") — isso transfere a conversa para um atendente humano
2. Isso avisa a equipe que alguém quer falar direto

**Repita essa mesma lógica de conexão de botões para os outros 3 flows**, usando os detalhes específicos de cada um (estão descritos nos arquivos `02-`, `03-` e `04-`).

---

## PARTE 6 — Configurando o lembrete de 48 horas

1. No mesmo Flow, depois do bloco de botões, adicione um bloco **"Smart Delay"**
2. Configure para **48 horas**
3. Depois do Smart Delay, adicione uma **"Condition"** (condição): "O contato clicou em algum botão?"
   - Se **sim** → conecte a um bloco vazio (fim do fluxo, não faz nada)
   - Se **não** → conecte a um bloco **"Send Content"** com a mensagem de lembrete (está no arquivo do fluxo, seção "Mensagem de lembrete")

---

## PARTE 7 — Agendando o disparo semanal

**Opção mais simples (se disponível no seu plano):**
1. Vá em **"Broadcasting"** no menu esquerdo
2. Clique em **"+ New Broadcast"**
3. Escolha o Flow `FLUXO_VINHO_DA_SEMANA`
4. Escolha a opção de repetir semanalmente, toda terça-feira, às 09:00
5. Escolha o público: todos os contatos, exceto quem tem a tag `Não responde há 30 dias`
6. Salve e ative

**Se seu plano não tiver repetição automática de broadcast:**
Você vai precisar de uma ferramenta extra e gratuita/barata chamada **Make.com** ou **Pabbly Connect**, que "aperta o botão" pra você toda semana no horário certo. Se chegar nessa etapa e não souber configurar, isso já é uma parte mais técnica — vale pedir ajuda de alguém da equipe ou me chamar novamente para te guiar nesse passo específico.

---

## PARTE 8 — Repita para os outros 3 fluxos

Siga exatamente os mesmos passos das Partes 4 a 7 para:
- `FLUXO_HARMONIZACAO_DA_SEMANA` (disparo: quinta 09:00)
- `FLUXO_ESCOLA_DO_VINHO` e `FLUXO_DESCUBRA_MUNDO_VINHO` (disparo: sexta 09:00, alternando — este é o único que tem uma etapa a mais, explicada abaixo)

### Etapa extra só para os fluxos de sexta

1. No início de cada um dos dois flows de sexta, adicione um bloco **"Condition"** logo depois do bloco de início
2. Configure a condição: "Custom Field `ultimo_fluxo_sexta` é igual a `escola`?"
3. No Flow `FLUXO_ESCOLA_DO_VINHO`: se a resposta for "sim", conecte direto ao fim (não faz nada essa semana). Se "não", segue o flow normal.
4. No Flow `FLUXO_DESCUBRA_MUNDO_VINHO`: é o oposto — se `ultimo_fluxo_sexta` for igual a `mundo`, não faz nada essa semana; se não, segue normal.
5. No final de cada um dos dois flows, adicione um bloco **"Set Field Value"** que atualiza `ultimo_fluxo_sexta` para `escola` (no flow da Escola) ou `mundo` (no flow do Mundo)

---

## PARTE 9 — Teste antes de ativar de verdade

1. Antes de publicar para todos os clientes, teste em você mesmo: no ManyChat, é possível "simular" o flow ou mandar mensagem do seu próprio número de teste
2. Confira se as mensagens aparecem certinhas, se os botões funcionam e se as tags são aplicadas
3. Só depois disso, ative o Broadcast semanal para todos os contatos de verdade

---

## DÚVIDAS FREQUENTES

**"Não encontro o bloco X no ManyChat"** — a interface muda de tempos em tempos. Procure por um bloco com nome parecido (ex: "Smart Delay" pode aparecer como "Delay"). Se não encontrar, descreva o que está vendo na tela que dá para te ajudar a localizar.

**"Os botões não aparecem no WhatsApp do cliente"** — confirme que o número de WhatsApp está usando a API oficial (Cloud API), não o WhatsApp Business comum baixado na loja de apps. Só a versão oficial suporta botões interativos.

**"Preciso mesmo aprovar templates na Meta?"** — sim, para a PRIMEIRA mensagem de cada fluxo (a que "abre" a conversa). As mensagens seguintes, dentro da mesma janela de 24 horas, podem ser texto livre sem aprovação.
