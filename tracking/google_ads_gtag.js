/**
 * VinoBianco — Google Ads Conversion Tag + GA4 Event
 * Página de Obrigado / Disparo via Google Tag Manager (GTM)
 *
 * Google Ads CID : 385-462-0310
 * GA4 Property ID: 433813165
 * Merchant Center: 5318590289 (não usado neste script; referência para feed de produtos)
 *
 * INSTRUÇÕES DE USO:
 *   Opção A — Cole o bloco <script> diretamente na página de Obrigado, APÓS o GTM snippet.
 *   Opção B — No GTM: crie uma tag "HTML Personalizado" com este conteúdo e
 *             configure o acionador para o evento "lead_premium_solicitado"
 *             ou para Page View na URL "/obrigado".
 */

// ═══════════════════════════════════════════════════════════════════════════════
// BLOCO 1 — Snippet Base do gtag.js
// Adicione este snippet no <head> de TODAS as páginas (se ainda não existir).
// Se já usa GTM, o gtag é carregado automaticamente — pule para o Bloco 2.
// ═══════════════════════════════════════════════════════════════════════════════
/*
<script async src="https://www.googletagmanager.com/gtag/js?id=G-XXXXXXXXXX"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){ dataLayer.push(arguments); }
  gtag('js', new Date());

  // Configura GA4
  gtag('config', 'G-XXXXXXXXXX'); // Substitua pelo Measurement ID do GA4

  // Configura Google Ads (vincula ao CID 385-462-0310)
  gtag('config', 'AW-XXXXXXXXX'); // Substitua pelo ID de conversão do Google Ads
                                   // Formato: AW-{número sem traços}
                                   // CID 385-462-0310 → ID numérico no painel do Google Ads
</script>
*/

// ═══════════════════════════════════════════════════════════════════════════════
// BLOCO 2 — Data Layer Push (dispare ANTES do evento gtag)
// Este bloco enriquece o dataLayer com os dados do filtro de qualificação.
// No GTM: crie uma variável de Camada de Dados para cada chave abaixo.
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Popula o dataLayer com os dados do lead qualificado.
 * Chame esta função imediatamente após o formulário ser submetido com sucesso.
 *
 * @param {object} leadData - Dados do formulário de qualificação
 */
function pushLeadToDataLayer(leadData) {
  window.dataLayer = window.dataLayer || [];

  const {
    tamanhoAdega,      // Ex.: "50-200 garrafas"
    perfilConsumo,     // Ex.: "Colecionador" | "Apreciador" | "Investidor"
    origemAnuncio,     // Ex.: "google_search" | "instagram_stories"
    leadScore,         // Pontuação do filtro: 1–10
    emailHash,         // SHA-256 do e-mail (gerado no frontend para enhanced conversions)
    phoneHash,         // SHA-256 do telefone normalizado
  } = leadData;

  // Valor estimado mapeado por perfil de qualificação da adega
  const valorLeadMap = {
    Colecionador: 1500,
    Investidor:   2500,
    Apreciador:    800,
  };
  const valorEstimado = valorLeadMap[perfilConsumo] ?? 500;

  // Push principal — capturado pelo GTM para acionar as tags
  window.dataLayer.push({
    event: "lead_premium_solicitado",   // Nome do evento — gatilho no GTM

    // ── Dados de Valor para Smart Bidding ────────────────────────────────
    lead_value:    valorEstimado,
    lead_currency: "BRL",

    // ── Qualificação da Adega ─────────────────────────────────────────────
    lead_tamanho_adega:   tamanhoAdega,
    lead_perfil_consumo:  perfilConsumo,
    lead_score:           leadScore,
    lead_origem_anuncio:  origemAnuncio,

    // ── Enhanced Conversions (Google Ads) — dados hashed ─────────────────
    // Permite ao Google enriquecer a conversão com dados first-party.
    enhanced_conversion_data: {
      email: emailHash,   // SHA-256 do e-mail (gerado no cliente ou servidor)
      phone: phoneHash,   // SHA-256 do telefone em formato E.164
    },
  });

  console.log("[VinoBianco] dataLayer atualizado:", window.dataLayer.slice(-1));
}

// ═══════════════════════════════════════════════════════════════════════════════
// BLOCO 3 — Conversão Google Ads (gtag event)
// Configure a LABEL no painel: Google Ads → Conversões → Nova Conversão → Obter Tag
// Formato da tag: AW-{CONVERSION_ID}/{CONVERSION_LABEL}
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Dispara a conversão no Google Ads e registra o evento no GA4.
 * Deve ser chamada APÓS pushLeadToDataLayer().
 *
 * Preencha CONVERSION_ID e CONVERSION_LABEL com os valores do painel do Google Ads.
 * CID 385-462-0310 → Acesse: Google Ads → Ferramentas → Conversões → Detalhes da tag
 */
function fireGoogleAdsConversion(leadData) {
  const CONVERSION_ID    = "AW-XXXXXXXXX";   // ID numérico da conta Google Ads
  const CONVERSION_LABEL = "XXXXXXXXXXX";    // Label gerada ao criar a ação de conversão

  const valorLeadMap = {
    Colecionador: 1500,
    Investidor:   2500,
    Apreciador:    800,
  };
  const transactionId  = `vb_lead_${Date.now()}`;
  const valorEstimado  = valorLeadMap[leadData.perfilConsumo] ?? 500;

  // ── 3a. Evento de Conversão no Google Ads ─────────────────────────────────
  gtag("event", "conversion", {
    send_to:        `${CONVERSION_ID}/${CONVERSION_LABEL}`,
    value:          valorEstimado,
    currency:       "BRL",
    transaction_id: transactionId,   // Evita contagem dupla se a página for recarregada
  });

  // ── 3b. Evento Personalizado no GA4 ───────────────────────────────────────
  // Property ID 433813165 → Measurement ID no formato G-XXXXXXXXXX (ver painel GA4)
  gtag("event", "lead_premium_solicitado", {
    // Parâmetros de evento GA4 (disponíveis em Exploração e BigQuery)
    event_category:  "Concierge",
    event_label:     leadData.perfilConsumo || "sem_perfil",
    value:           valorEstimado,
    currency:        "BRL",
    transaction_id:  transactionId,

    // Dimensões customizadas (configure em GA4 → Admin → Dimensões personalizadas)
    tamanho_adega:   leadData.tamanhoAdega,
    perfil_consumo:  leadData.perfilConsumo,
    lead_score:      leadData.leadScore,
    origem_anuncio:  leadData.origemAnuncio,
  });

  console.log(`[VinoBianco] Conversão disparada | Valor: R$${valorEstimado} | TX: ${transactionId}`);
}

// ═══════════════════════════════════════════════════════════════════════════════
// BLOCO 4 — Ponto de Entrada (chame na página de Obrigado ou no callback do form)
// ═══════════════════════════════════════════════════════════════════════════════

/**
 * Função principal — chame esta ao confirmar o envio do formulário.
 * Parâmetros vindos do backend após processar o form.
 *
 * @param {object} leadData - Objeto com os dados do lead qualificado
 */
function onLeadConvertido(leadData) {
  pushLeadToDataLayer(leadData);  // Passo 1: enriquece o dataLayer
  fireGoogleAdsConversion(leadData); // Passo 2: dispara as tags de conversão
}

// ─── EXEMPLO DE CHAMADA ──────────────────────────────────────────────────────
// Substitua pelos dados reais do formulário:
//
// onLeadConvertido({
//   tamanhoAdega:  "50-200 garrafas",
//   perfilConsumo: "Colecionador",
//   origemAnuncio: "instagram_stories",
//   leadScore:     8,
//   emailHash:     "e3b0c44298fc1c149afb...",  // SHA-256 do email (gerado no servidor)
//   phoneHash:     "2c624232cdd221771294...",  // SHA-256 do telefone normalizado
// });
