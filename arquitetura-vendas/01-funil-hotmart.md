# FUNIL HOTMART — VINO BIANCO STORE
## Arquitetura Completa de Conversão

---

## VISÃO GERAL DO FUNIL

```
TOPO (Tráfego Frio)
│
├── Instagram Reels → Comentário "VINHO" → ManyChat DM
├── YouTube → Descrição → Link Bio
├── Google SEO → Blog → Pop-up opt-in
└── Tráfego Pago → Meta Ads / Google Ads
         │
         ▼
MEIO (Captura e Nutrição)
│
├── Lead Magnet: "5 Vinhos para Impressionar" (PDF gratuito)
├── Sequência 7 Emails (Mailchimp)
├── DM Sequence ManyChat (3 mensagens / 3 dias)
└── Stories diários com CTA sutil
         │
         ▼
FUNDO (Conversão)
│
├── Página de Vendas Hotmart (R$57)
├── Order Bump: Manual do Bar em Casa (+R$17)
├── Upsell Pós-Compra: Curso Fundamentos (R$97 → R$67)
└── Área de Membros (percepção de valor)
         │
         ▼
PÓS-VENDA (Retenção e Ascensão)
│
├── Email de boas-vindas + instrução de uso
├── Sequência de onboarding (3 emails)
├── Oferta do Curso Premium (R$297) — 30 dias após compra
└── Convite ao Clube Vino Bianco (R$47/mês) — 60 dias após compra
```

---

## CONFIGURAÇÃO TÉCNICA HOTMART

### Produto Principal
| Campo              | Valor                                                  |
|--------------------|--------------------------------------------------------|
| Nome               | Do Leigo ao Apreciador — Guia Definitivo de Vinhos     |
| Preço              | R$57,00                                                |
| Parcelamento       | 6x de R$9,99 (sem juros)                               |
| Formato            | E-book (PDF) — entrega automática via Hotmart          |
| Garantia           | 7 dias incondicional                                   |
| Comissão afiliados | 30%                                                    |
| Área de membros    | Ativar (aumenta percepção de valor e reduz chargeback) |

### Order Bump
| Campo  | Valor                                           |
|--------|-------------------------------------------------|
| Nome   | Manual do Bar em Casa                           |
| Preço  | R$17,00                                         |
| Copy   | "Adicione ao pedido: aprenda a montar seu bar, quais doses servir e como receber com classe. Complemento perfeito para o guia principal." |
| Meta   | Conversão de 25–35% dos compradores             |

### Upsell (Página de Obrigado)
| Campo  | Valor                                                          |
|--------|----------------------------------------------------------------|
| Nome   | Curso Fundamentos do Vinho Brasileiro (videoaulas)             |
| Preço  | ~~R$97~~ → R$67 (oferta exclusiva por 24h)                    |
| Gatilho| Redirecionamento automático após confirmação de compra        |
| Timer  | Countdown de 23:59 (urgência real — expira após 24h)          |

### Checkout Personalizado
- Favicon e logo Vino Bianco (bordô #6B1A2B + dourado #C9A84C)
- Selos de segurança visíveis: SSL, Hotmart, garantia 7 dias
- Depoimentos curtos abaixo do botão de compra
- Campos mínimos (nome + email + pagamento) — cada campo adicional reduz conversão

---

## PÁGINA DE OBRIGADO — ESTRUTURA

```
[Logo] [Headline: "Seu guia chegou! Confira o email."]
[Vídeo boas-vindas 60s — Jorge Berto]
[Instrução: onde acessar o material]
[UPSELL: Oferta única de 24h — Curso Fundamentos]
  └── Timer countdown
  └── Botão CTA verde: "SIM, QUERO ADICIONAR POR R$67"
  └── Link: "Não, obrigado. Continuar com o guia apenas."
[Seção: O que você acabou de adquirir]
[Redes sociais + convite para grupo VIP]
```

---

## SEQUÊNCIA PÓS-COMPRA (Email Automático)

| Email | Timing              | Objetivo                                        |
|-------|---------------------|-------------------------------------------------|
| E1    | Imediato            | Entrega + boas-vindas + como acessar            |
| E2    | Dia 2               | "Como aproveitar ao máximo o guia" (engajamento)|
| E3    | Dia 7               | "Você já leu? Aqui está o que a maioria pula…" |
| E4    | Dia 14              | Convite para deixar depoimento (prova social)   |
| E5    | Dia 21              | Oferta: Curso Premium R$297 (upsell tardio)     |
| E6    | Dia 45              | Convite: Clube Vino Bianco R$47/mês             |

---

## METAS DE CONVERSÃO POR ETAPA

| Etapa                           | Meta       | Observação                          |
|---------------------------------|------------|-------------------------------------|
| Visitante → Lead (opt-in)       | 35–45%     | Landing page do lead magnet         |
| Lead → Comprador (email seq.)   | 3–5%       | Sequência de 7 emails               |
| Lead → Comprador (ManyChat)     | 5–8%       | DM sequence mais íntima             |
| Comprador → Order Bump          | 25–35%     | Mostrado no checkout                |
| Comprador → Upsell (24h)        | 15–25%     | Página de obrigado + timer          |
| Comprador → Clube (recorrência) | 10–20%     | Email dia 45 + histórico de valor   |

---

## TESTES A/B RECOMENDADOS

### Preço do Ebook Principal
- Variante A: R$47 (mais acessível, maior volume)
- Variante B: R$57 (preço atual, margem melhor)
- Variante C: R$67 com bônus reforçado
- Decisão: rodar 200 visitantes em cada antes de definir

### Headline da Página de Vendas
- A: "Você já fingiu que estava lendo a carta de vinhos?"
- B: "Em uma tarde, aprenda a escolher vinho sem passar vergonha"
- C: "Por que 87% das pessoas erram na hora de comprar vinho — e como evitar"

### CTA do Order Bump
- A: "Sim, quero o Manual do Bar por R$17" (simples)
- B: "Adicionar Manual do Bar — Economizo R$30 na compra de vinhos errados" (benefício)
