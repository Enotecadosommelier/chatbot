# Automação ManyChat (WhatsApp) — Recuperação de Pedidos com Pagamento Pendente
## Vino Bianco Store | Recuperação de Vendas Perdidas

---

## CONTEXTO E DIAGNÓSTICO

O painel de pedidos mostra um padrão claro: dezenas de clientes chegaram até o checkout, escolheram forma de pagamento e **não finalizaram**. Isso não é "site parado" — é **carrinho abandonado no pagamento**, o ponto de recuperação mais barato que existe, porque o cliente já:

- Preencheu nome e telefone (temos o contato)
- Escolheu os produtos
- Escolheu a forma de pagamento
- Só não concluiu (esqueceu, boleto não gerou a tempo, cartão caiu, PIX expirou, indecisão de última hora)

### Segmentos identificados no painel

| Situação                | O que significa                          | Urgência de contato        |
|-------------------------|-------------------------------------------|-----------------------------|
| **PIX — Aguardando**    | QR Code expira em ~30 min a algumas horas | **Altíssima — agir em minutos** |
| **Boleto — Aguardando** | Cliente pode pagar em até 3 dias úteis    | Média — lembrete + reforço de urgência |
| **Cartão de Crédito — Aguardando** | Geralmente cai por falha de aprovação | Alta — pedir novo cartão |
| **Negado**              | Pagamento recusado pela operadora         | Alta — oferecer alternativa de pagamento |

---

## ⚠️ PONTO CRÍTICO DE COMPLIANCE — LEIA ANTES DE CONFIGURAR

ManyChat para **Instagram/Messenger** permite iniciar conversa livremente. ManyChat para **WhatsApp** (API oficial da Meta) **não permite** mandar mensagem de graça para quem nunca abriu conversa com você nas últimas 24h. Para estes leads (telefone capturado no checkout, sem conversa prévia no WhatsApp), você precisa de uma **Message Template (HSM)** aprovada pela Meta — ex: `"Olá {{1}}, vimos que seu pedido {{2}} está com o pagamento pendente. Quer ajuda para finalizar?"` com botão de resposta rápida.

Sem isso, a conta pode ser bloqueada por disparo não solicitado. Isso é configurado uma vez em **ManyChat → Settings → WhatsApp → Message Templates**, submetido para aprovação (leva de horas a 1–2 dias).

---

## VISÃO GERAL DO FLUXO

```
Pedido muda para "Aguardando pagamento" ou "Negado" na loja
    ↓
Webhook da plataforma → Integração (Make/Zapier/Pabbly) → ManyChat API
    ↓
ManyChat cria/atualiza contato pelo telefone + tags (forma_pagamento, valor, pedido_id)
    ↓
Dispara o fluxo correto por segmento (PIX / Boleto / Cartão / Negado)
    ↓
Sequência de mensagens com cadência própria por urgência
    ↓
Cliente paga → Webhook de "Pagamento aprovado" remove da automação (tag "recuperado")
```

---

## PASSO 1 — INTEGRAÇÃO (a única parte técnica)

A plataforma da loja (painel mostrado) provavelmente não conversa nativamente com o ManyChat. Solução:

1. Verificar se a plataforma tem **Webhook de eventos de pedido** (Configurações → Integrações/Webhooks). A maioria das plataformas brasileiras (Nuvemshop, Yampi, Tray, Cartpanda etc.) tem isso.
2. Conectar esse webhook a um automatizador (**Make.com** ou **Pabbly Connect** — mais barato que Zapier para volume de e-commerce):
   - Trigger: "Pedido atualizado" com status = `aguardando_pagamento` ou `negado`
   - Ação: chamar o **ManyChat API** endpoint `subscriber/createSubscriber` (ou `updateSubscriber` se já existir) usando o telefone
   - Setar **Custom Fields** no ManyChat: `nome`, `pedido_numero`, `valor_pedido`, `forma_pagamento`, `link_pagamento`
   - Setar **Tag** correspondente ao segmento: `pix_pendente`, `boleto_pendente`, `cartao_pendente`, `pagamento_negado`
3. No ManyChat, cada tag dispara automaticamente o fluxo correspondente (**Automation → Triggers → Tag Added**).
4. Configurar o **webhook inverso**: quando o pedido vira "Pagamento aprovado", remover a tag de pendência e adicionar `recuperado` (isso interrompe a régua automaticamente).

Se não houver webhook disponível na plataforma, alternativa manual viável agora: exportar CSV diário dos pedidos "Aguardando pagamento" e usar a ferramenta **ManyChat → Growth Tools → JSON API / Import** para subir os contatos em lote 1x por dia (menos ágil, mas funciona sem programação).

---

## PASSO 2 — FLUXOS POR SEGMENTO

### FLUXO A — `PIX_PENDENTE` (mais urgente)

**Mensagem 1 (imediata, template aprovado):**
> Oi {{nome}}! 🍷 Vimos que seu PIX do pedido #{{pedido}} (R$ {{valor}}) ainda não caiu. O QR Code expira em breve — quer que eu gere um novo?
> [Gerar novo PIX] [Falar com atendente]

**Mensagem 2 (+2h, se não pagou):**
> {{nome}}, ainda dá tempo! Seu pedido está reservado, mas não por muito mais tempo. Finalize aqui: {{link_pagamento}}

**Mensagem 3 (+6h, última chamada):**
> Última chance, {{nome}} — depois disso liberamos o estoque reservado. Precisa de ajuda para pagar? Responda aqui que te ajudo pessoalmente.

---

### FLUXO B — `BOLETO_PENDENTE`

**Mensagem 1 (imediata):**
> Oi {{nome}}! Seu boleto do pedido #{{pedido}} (R$ {{valor}}) já está disponível. Ele vence em breve — aqui está o link para pagar ou copiar o código de barras: {{link_pagamento}}

**Mensagem 2 (+24h):**
> {{nome}}, passando para lembrar do seu boleto ainda em aberto. Prefere pagar por PIX ou cartão? Consigo trocar a forma de pagamento pra você agora, sem precisar refazer o pedido.

**Mensagem 3 (+48h, antes do vencimento):**
> Seu boleto vence amanhã. Se preferir, faço a troca para PIX agora e você recebe na hora. Quer?

---

### FLUXO C — `CARTAO_PENDENTE` / recusado

**Mensagem 1 (imediata):**
> Oi {{nome}}, seu pagamento do pedido #{{pedido}} não foi aprovado pela operadora. Pode ser limite, dados incorretos ou bloqueio de segurança do banco. Quer tentar com outro cartão ou trocar para PIX (aprovação na hora)?
> [Tentar novo cartão] [Pagar com PIX]

**Mensagem 2 (+3h):**
> {{nome}}, ainda estou com seu pedido reservado. Me chama aqui se quiser ajuda para resolver — às vezes é só um detalhe no CVV ou CEP de cobrança.

---

### FLUXO D — `PAGAMENTO_NEGADO`

**Mensagem 1 (imediata):**
> Oi {{nome}}, seu pagamento não foi aprovado. Antes de desistir: temos PIX (aprovação instantânea) e boleto como alternativas. Qual prefere?

**Mensagem 2 (+24h, com incentivo):**
> {{nome}}, para facilitar te dou 5% de desconto se fechar hoje via PIX: {{link_pagamento_desconto}}. Isso ainda vale para você.

---

## REGRAS DA RÉGUA (todas os fluxos)

- **Parar imediatamente** a régua assim que a tag `recuperado` for adicionada (pagamento aprovado) — configurar isso como primeira ação de qualquer fluxo (`Condition: se tag recuperado → Exit flow`).
- **Nunca** mais de 3 contatos por pedido — depois disso, é spam e queima a relação.
- Horário de disparo: 8h–21h apenas (WhatsApp fora desse horário tem taxa de bloqueio maior e o cliente reage mal).
- Pedidos com **valor alto** (ex: acima de R$1.000, como os pedidos 490 e 468 do painel) merecem contato humano além do automático — configurar uma notificação interna (ManyChat → Live Chat handoff) para o time comercial ligar/chamar pessoalmente nesses casos.

---

## PASSO 3 — CONFIGURAÇÃO NO MANYCHAT (passo a passo)

1. `ManyChat → Settings → WhatsApp` — conectar o número business (precisa de WhatsApp Business API/Cloud API, não o app comum)
2. `Settings → Message Templates` — criar e submeter os templates de 1ª mensagem de cada fluxo (só a primeira mensagem de cada sequência precisa ser template aprovado, pois é ela que "abre" a janela de 24h; as seguintes dentro da janela de 24h podem ser texto livre)
3. `Automation → New Automation` — criar 4 automações, uma por tag (`pix_pendente`, `boleto_pendente`, `cartao_pendente`, `pagamento_negado`), trigger = **Tag Added**
4. Dentro de cada automação, usar blocos de **Delay** (2h, 24h, etc.) entre as mensagens
5. Adicionar bloco de **Condition** no início: `se tag = recuperado → Go to Exit`
6. Criar os **Custom Fields**: `nome`, `pedido_numero`, `valor_pedido`, `link_pagamento`
7. Testar todo o fluxo com um número de teste antes de ativar para a base real

---

## MÉTRICAS PARA ACOMPANHAR

| Métrica                              | Meta Inicial | Onde ver          |
|---------------------------------------|--------------|--------------------|
| Taxa de recuperação (pago após msg)  | >15%         | Comparar tag `recuperado` vs total enviado |
| Tempo médio até recuperação          | <6h          | ManyChat + painel de pedidos |
| Taxa de opt-out / bloqueio           | <2%          | ManyChat Analytics |
| Receita recuperada (R$)              | Acompanhar semanalmente | Somar pedidos com tag `recuperado` |

---

## PRIORIDADE IMEDIATA (pedidos já parados no painel)

Enquanto a automação não está no ar, os pedidos abaixo (do painel atual) já são recuperáveis manualmente hoje, por ordem de prioridade (maior valor + mais recente + PIX/mais fácil de converter):

1. **#489** — LEDA CARVALHO — R$1.197,44 — Cartão (verificar se caiu por recusa, oferecer novo cartão ou PIX)
2. **#483** — Luiz santos — R$1.264,52 — PIX (provavelmente só expirou, gerar novo PIX)
3. **#477** — Jefferson Souza — R$1.350,33 — PIX
4. **#476** — Isalea Ressa — R$2.034,08 — PIX (maior valor entre os pendentes — priorizar contato humano)
5. **#490** — Hilton Junior — R$1.495,51 — Boleto (lembrar antes do vencimento)

Isso representa mais de **R$7.300** em vendas paradas apenas nesses 5 pedidos — vale contato manual via WhatsApp hoje mesmo, mesmo antes da automação estar pronta.
