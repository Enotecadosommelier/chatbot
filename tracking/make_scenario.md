# VinoBianco — Cenário Make.com: Orquestração de Dados de Lead Premium

**Objetivo:** Capturar o lead do formulário "Solicitar Acesso ao Concierge", qualificar via Claude AI,
distribuir para Meta CAPI + Google Ads e salvar na biblioteca mestre de leads.

---

## Visão Geral do Fluxo

```
[GATILHO]            [PROCESSAMENTO]          [DISTRIBUIÇÃO]            [ARMAZENAMENTO]
Webhook ──────────► Normalizar Dados ───────► Meta CAPI (Lead)  ──────► Google Sheets /
(Formulário)        + Enriquecer IP           Google Ads gtag           Notion / Airtable
                        │                     GA4 (Measurement)         (Biblioteca Mestre)
                        ▼
                  Claude AI (API)
                  Qualificação Triple A
                  Score + Segmentação
```

---

## Módulos Detalhados

### MÓDULO 1 — Gatilho: Webhooks > Custom Webhook

| Campo          | Valor                                                           |
|----------------|-----------------------------------------------------------------|
| Tipo           | `Webhooks > Custom Webhook`                                     |
| URL Gerada     | `https://hook.eu2.make.com/XXXXXXXXXX` (copie e cole no form)  |
| Método HTTP    | POST                                                            |
| Content-Type   | `application/json`                                              |

**Payload esperado do formulário (JSON):**
```json
{
  "email":           "cliente@exemplo.com",
  "telefone":        "+55 11 99999-8888",
  "nome":            "João Silva",
  "cidade":          "São Paulo",
  "estado":          "SP",
  "cep":             "01310100",
  "tamanho_adega":   "50-200 garrafas",
  "perfil_consumo":  "Colecionador",
  "ip_address":      "{{ip do visitante — capturado no backend}}",
  "user_agent":      "Mozilla/5.0 ...",
  "fbp":             "_fbp cookie value",
  "fbc":             "_fbc cookie value",
  "origem_anuncio":  "instagram_stories",
  "timestamp":       "2024-01-15T14:30:00Z"
}
```

---

### MÓDULO 2 — Tools > Set Variable (Normalização)

Crie variáveis reutilizáveis para evitar repetição nos módulos seguintes.

| Variável            | Expressão Make                                          |
|---------------------|---------------------------------------------------------|
| `nome_completo`     | `{{1.nome}}`                                            |
| `primeiro_nome`     | `{{split(1.nome; " ")[0]}}`                             |
| `sobrenome`         | `{{last(split(1.nome; " "))}}`                          |
| `telefone_limpo`    | `{{replace(1.telefone; /\D/g; "")}}`                    |
| `timestamp_unix`    | `{{floor(now / 1000)}}`                                 |
| `event_id_unico`    | `{{concat("vb_"; 1.email; "_"; timestamp_unix)}}`       |

---

### MÓDULO 3 — HTTP > Make a Request (Meta CAPI)

| Campo        | Valor                                                                    |
|--------------|--------------------------------------------------------------------------|
| URL          | `https://graph.facebook.com/v19.0/{{SEU_PIXEL_ID}}/events`              |
| Método       | POST                                                                     |
| Headers      | `Content-Type: application/json`                                         |
| Query string | `access_token` = `{{META_ACCESS_TOKEN}}` (variável de ambiente no Make)  |

**Body JSON:**
```json
{
  "data": [
    {
      "event_name": "Lead",
      "event_time": "{{3.timestamp_unix}}",
      "event_id":   "{{3.event_id_unico}}",
      "action_source": "website",
      "event_source_url": "https://vinobianco.com.br/concierge",
      "user_data": {
        "em":                "{{sha256(lower(trim(1.email)))}}",
        "ph":                "{{sha256(3.telefone_limpo)}}",
        "fn":                "{{sha256(lower(3.primeiro_nome))}}",
        "ln":                "{{sha256(lower(3.sobrenome))}}",
        "ct":                "{{sha256(lower(trim(1.cidade)))}}",
        "st":                "{{sha256(lower(1.estado))}}",
        "zp":                "{{sha256(replace(1.cep; \"-\"; \"\"))}}",
        "country":           "{{sha256(\"br\")}}",
        "client_ip_address": "{{1.ip_address}}",
        "client_user_agent": "{{1.user_agent}}",
        "fbp": "{{1.fbp}}",
        "fbc": "{{1.fbc}}"
      },
      "custom_data": {
        "currency":          "BRL",
        "value":             "{{4.lead_value}}",
        "content_name":      "Concierge VinoBianco",
        "tamanho_adega":     "{{1.tamanho_adega}}",
        "perfil_consumo":    "{{1.perfil_consumo}}",
        "lead_score":        "{{4.lead_score}}"
      }
    }
  ]
}
```

> **Nota:** O Make.com não possui função `sha256` nativa. Use o módulo
> **Tools > Crypto** (disponível em Make) ou pré-processe os hashes
> no seu backend antes de enviar ao webhook.

---

### MÓDULO 4 — Anthropic (Claude) > Create a Message (Qualificação AI)

| Campo       | Valor                                             |
|-------------|---------------------------------------------------|
| Model       | `claude-sonnet-4-6`                               |
| Max Tokens  | `1024`                                            |

**System Prompt:**
```
Você é um especialista em qualificação de leads premium para a VinoBianco,
uma importadora de vinhos de luxo focada no público Triple A (Alta Renda,
Alto Padrão de Consumo, Alta Frequência de Compra).

Analise os dados do lead e retorne EXCLUSIVAMENTE um JSON válido com:
{
  "lead_score": <número 1-10>,
  "segmento": "<Colecionador|Investidor|Apreciador|Inelegível>",
  "valor_estimado_brl": <número>,
  "prioridade": "<Alta|Média|Baixa>",
  "proximo_passo": "<ação recomendada em 1 frase>",
  "justificativa": "<razão da classificação em 1 frase>"
}

Critérios:
- Score 9-10: Colecionador com adega >200 garrafas ou Investidor → Alta prioridade
- Score 7-8:  Apreciador frequente ou adega 50-200 garrafas → Média prioridade
- Score 4-6:  Interesse inicial, sem qualificação clara → Baixa prioridade
- Score 1-3:  Dados incompletos ou perfil incompatível → Inelegível
```

**User Message:**
```
Qualifique este lead:
- Nome: {{1.nome}}
- Tamanho da adega: {{1.tamanho_adega}}
- Perfil de consumo declarado: {{1.perfil_consumo}}
- Origem do anúncio: {{1.origem_anuncio}}
- Cidade: {{1.cidade}} / {{1.estado}}
- Timestamp: {{1.timestamp}}
```

**Output esperado do Claude (parse como JSON no próximo módulo):**
```json
{
  "lead_score": 9,
  "segmento": "Colecionador",
  "valor_estimado_brl": 1500,
  "prioridade": "Alta",
  "proximo_passo": "Contactar em até 2h com proposta do Clube Concierge",
  "justificativa": "Adega grande e perfil colecionador indicam alto potencial de compra recorrente"
}
```

---

### MÓDULO 5 — JSON > Parse JSON

Conecte a saída do módulo Claude (`4.content[0].text`) para extrair os campos:

| Mapeamento Make        | Origem                          |
|------------------------|---------------------------------|
| `lead_score`           | `{{parseJSON(4.content[0].text).lead_score}}` |
| `segmento`             | `{{parseJSON(4.content[0].text).segmento}}`   |
| `valor_estimado_brl`   | `{{parseJSON(4.content[0].text).valor_estimado_brl}}` |
| `prioridade`           | `{{parseJSON(4.content[0].text).prioridade}}` |
| `proximo_passo`        | `{{parseJSON(4.content[0].text).proximo_passo}}` |

---

### MÓDULO 6 — Router (Filtro de Prioridade)

Separe os fluxos por prioridade:

```
Router
  ├── Rota A: prioridade = "Alta"   → Notificar equipe (WhatsApp/Slack) + salvar
  ├── Rota B: prioridade = "Média"  → Sequência de e-mail nurturing + salvar
  └── Rota C: prioridade = "Baixa"  → Salvar apenas (sem ação imediata)
```

---

### MÓDULO 7 — Google Sheets > Add a Row (Biblioteca Mestre de Leads)

| Coluna Make                | Valor                             |
|---------------------------|-----------------------------------|
| Data/Hora                  | `{{formatDate(now; "DD/MM/YYYY HH:mm")}}` |
| Nome                       | `{{1.nome}}`                      |
| E-mail                     | `{{1.email}}`                     |
| Telefone                   | `{{1.telefone}}`                  |
| Cidade / Estado            | `{{1.cidade}} / {{1.estado}}`     |
| Tamanho Adega              | `{{1.tamanho_adega}}`             |
| Perfil Declarado           | `{{1.perfil_consumo}}`            |
| Segmento Claude            | `{{5.segmento}}`                  |
| Lead Score                 | `{{5.lead_score}}`                |
| Valor Estimado             | `R$ {{5.valor_estimado_brl}}`     |
| Prioridade                 | `{{5.prioridade}}`                |
| Próximo Passo              | `{{5.proximo_passo}}`             |
| Origem Anúncio             | `{{1.origem_anuncio}}`            |
| Event ID (deduplicação)    | `{{3.event_id_unico}}`            |
| Status                     | `Novo`                            |

---

### MÓDULO 8 (Rota A) — Slack / WhatsApp > Send Message

**Mensagem de alerta para leads de Alta Prioridade:**
```
🍷 *Novo Lead Premium — VinoBianco*

👤 *Nome:* {{1.nome}}
📍 *Cidade:* {{1.cidade}}/{{1.estado}}
🏆 *Segmento:* {{5.segmento}} | Score: {{5.lead_score}}/10
💰 *Valor Estimado:* R$ {{5.valor_estimado_brl}}
🎯 *Origem:* {{1.origem_anuncio}}

📋 *Próximo Passo:* {{5.proximo_passo}}

⏰ Contato recomendado em até 2 horas.
```

---

## Variáveis de Ambiente (Secrets no Make.com)

Configure em **Make → Organização → Variáveis de Ambiente**:

| Variável            | Descrição                                      |
|---------------------|------------------------------------------------|
| `META_ACCESS_TOKEN` | Token do Sistema do Pixel Meta (nunca expor)   |
| `META_PIXEL_ID`     | ID numérico do Pixel da VinoBianco             |
| `GOOGLE_ADS_CID`    | `385-462-0310` (referência, não usado via API) |
| `GA4_PROPERTY_ID`   | `433813165`                                    |
| `SHEETS_ID`         | ID da planilha Google Sheets da biblioteca     |
| `SLACK_WEBHOOK_URL` | Webhook do canal #leads-premium                |

---

## Checklist de Validação

- [ ] Webhook recebendo dados do formulário (teste com payload manual)
- [ ] SHA-256 aplicado em: email, telefone, nome, cidade, estado, CEP, país
- [ ] Meta Events Manager mostrando Event Match Quality ≥ 7.0
- [ ] Conversão aparecendo no Google Ads em até 24h
- [ ] GA4 Realtime exibindo evento `lead_premium_solicitado`
- [ ] Claude retornando JSON válido (sem texto extra fora do JSON)
- [ ] Google Sheets registrando linha a cada novo lead
- [ ] Alerta Slack disparando apenas para prioridade "Alta"
- [ ] `event_id` único prevenindo duplicações no Meta
