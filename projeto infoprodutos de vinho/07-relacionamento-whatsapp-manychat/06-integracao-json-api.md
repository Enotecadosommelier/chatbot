# Integração JSON — Referência para Shopify e RD Station
## Preparação para os blocos "External Request" (inativos) de cada fluxo

---

## ⚠️ AVISO IMPORTANTE

Os JSONs abaixo são **modelos de referência** (estrutura esperada), não confirmados contra a documentação oficial ao vivo do ManyChat, Shopify e RD Station no momento da escrita — esta sessão não tem acesso à internet para validar contra as versões mais recentes dessas APIs. **Antes de ativar qualquer bloco External Request de verdade:**

1. Confira o endpoint exato e os nomes de campo na documentação atual de cada plataforma
2. Teste primeiro em ambiente de sandbox/homologação, nunca direto em produção
3. No ManyChat, use o link do Swagger disponível em Settings → API para validar o formato de request/response

---

## 1. OBJETO "SUBSCRIBER" DO MANYCHAT (referência de campos usados neste projeto)

```json
{
  "id": 123456789,
  "page_id": 987654321,
  "user_refs": [],
  "first_name": "Jorge",
  "last_name": "Berto",
  "phone": "+5511999999999",
  "whatsapp_phone": "+5511999999999",
  "subscribed": "subscribed",
  "tags": [
    { "id": 1001, "name": "Cliente Novo" },
    { "id": 1002, "name": "Interesse Espumantes" }
  ],
  "custom_fields": [
    { "id": 2001, "name": "nome", "type": "text", "value": "Jorge" },
    { "id": 2002, "name": "ultimo_vinho_comprado", "type": "text", "value": "Catena Zapata Malbec" },
    { "id": 2003, "name": "data_ultima_compra", "type": "date", "value": "2026-06-15" },
    { "id": 2004, "name": "cidade", "type": "text", "value": "São Paulo" },
    { "id": 2005, "name": "estado", "type": "text", "value": "SP" },
    { "id": 2006, "name": "tipo_favorito", "type": "text", "value": "Tinto" },
    { "id": 2007, "name": "faixa_de_preco", "type": "text", "value": "R$100-200" },
    { "id": 2008, "name": "data_aniversario", "type": "date", "value": "1985-03-20" },
    { "id": 2009, "name": "sommelier_responsavel", "type": "text", "value": "Ana" },
    { "id": 2010, "name": "ticket_medio", "type": "number", "value": 245.90 },
    { "id": 2011, "name": "ultimo_fluxo_sexta", "type": "text", "value": "escola" },
    { "id": 2012, "name": "contador_semanas_sem_clique", "type": "number", "value": 0 }
  ]
}
```

---

## 2. PAYLOAD DE SAÍDA — MANYCHAT → SHOPIFY (consulta de estoque/preço em tempo real)

Usado no bloco External Request do Fluxo 1 (botão "Ver ofertas") e Fluxo 2 (botão "Comprar").

**Request (ManyChat → Shopify, via app/middleware intermediário):**
```json
{
  "event": "consulta_produto",
  "subscriber_id": "{{subscriber_id}}",
  "produto_sku": "MALBEC-CATENA-750",
  "canal": "whatsapp"
}
```

**Response esperado (Shopify → ManyChat):**
```json
{
  "sku": "MALBEC-CATENA-750",
  "nome": "Catena Zapata Malbec",
  "disponivel": true,
  "estoque": 14,
  "preco": 109.90,
  "preco_promocional": 94.90,
  "link_checkout": "https://vinobianco.com.br/checkout/MALBEC-CATENA-750"
}
```

---

## 3. PAYLOAD DE SAÍDA — MANYCHAT → RD STATION (sincronização de lead/CRM)

Usado para registrar engajamento e qualificar o lead conforme interação com os fluxos.

```json
{
  "event_type": "CONVERSION",
  "event_family": "CDP",
  "payload": {
    "conversion_identifier": "engajamento_whatsapp_semanal",
    "email": "",
    "personal_phone": "+5511999999999",
    "name": "Jorge Berto",
    "cf_tipo_favorito": "Tinto",
    "cf_ultimo_vinho_comprado": "Catena Zapata Malbec",
    "cf_ticket_medio": "245.90",
    "tags": ["cliente-vip", "interesse-espumantes"],
    "traffic_source": "whatsapp-manychat"
  }
}
```

---

## 4. WEBHOOK DE ENTRADA — LOJA → MANYCHAT (evento de compra confirmada)

Usado para aplicar automaticamente as tags `Comprou Tinto` / `Comprou Branco` / `Comprou Rosé` / `Comprou Espumante` e atualizar `ultimo_vinho_comprado`, `data_ultima_compra` e `ticket_medio`.

```json
{
  "evento": "pedido_pago",
  "pedido_numero": "491",
  "telefone_cliente": "+5511999999999",
  "itens": [
    { "produto": "Catena Zapata Malbec", "categoria": "Tinto", "valor": 109.90 }
  ],
  "valor_total": 109.90,
  "data_pagamento": "2026-07-24T14:32:00Z"
}
```

Este webhook chama, via Make/Pabbly Connect, os endpoints do ManyChat:
- `POST /fb/subscriber/addTagByName` → `{"subscriber_id": "...", "tag_name": "Comprou Tinto"}`
- `POST /fb/subscriber/setCustomField` → `{"subscriber_id": "...", "field_name": "ultimo_vinho_comprado", "field_value": "Catena Zapata Malbec"}`
- `POST /fb/subscriber/setCustomField` → `{"subscriber_id": "...", "field_name": "data_ultima_compra", "field_value": "2026-07-24"}`

---

## STATUS DE ATIVAÇÃO

| Integração | Status neste momento |
|---|---|
| Shopify — consulta de estoque/preço | 🔲 Preparado, **inativo** (sem loja Shopify confirmada ainda) |
| RD Station — sync de CRM | 🔲 Preparado, **inativo** (conta RD Station não conectada ainda) |
| Webhook loja → ManyChat (tags de compra) | 🔲 Preparado, **inativo** — depende de qual plataforma de e-commerce está em uso ter webhook de pedido pago disponível |

Nenhum destes blocos deve ser ativado sem antes confirmar o endpoint real da plataforma em uso e testar em ambiente controlado.
