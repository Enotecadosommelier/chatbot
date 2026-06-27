/**
 * VinoBianco — Meta Conversions API (CAPI)
 * Evento: Lead via formulário "Solicitar Acesso ao Concierge"
 *
 * IMPORTANTE: Este script roda no SERVIDOR (Node.js / Make.com HTTP module).
 * Nunca exponha o ACCESS_TOKEN no frontend.
 *
 * Dependências:
 *   npm install crypto node-fetch  (ou use o módulo nativo em Node 18+)
 */

const crypto = require("crypto");
// Em Node 18+ substitua por: import fetch from "node:fetch";
const fetch = require("node-fetch");

// ─── CONFIGURAÇÃO ───────────────────────────────────────────────────────────
const META_PIXEL_ID    = "SEU_PIXEL_ID_AQUI";          // Ex.: 1234567890123456
const META_ACCESS_TOKEN = process.env.META_ACCESS_TOKEN; // Variável de ambiente — nunca hardcode
const META_API_VERSION  = "v19.0";
const META_CAPI_URL     = `https://graph.facebook.com/${META_API_VERSION}/${META_PIXEL_ID}/events`;

// ─── UTILITÁRIO: SHA-256 ────────────────────────────────────────────────────
/**
 * Normaliza e criptografa um valor em SHA-256 conforme exigido pela Meta.
 * Regra: trim + lowercase antes de criptografar.
 * Retorna null se o valor estiver vazio, para não enviar campos vazios.
 */
function sha256(value) {
  if (!value) return null;
  const normalized = String(value).trim().toLowerCase();
  return crypto.createHash("sha256").update(normalized).digest("hex");
}

/**
 * Normaliza telefone para E.164 (apenas dígitos, sem espaços ou símbolos).
 * Exemplo: "+55 (11) 98765-4321" → "5511987654321"
 */
function normalizePhone(phone) {
  if (!phone) return null;
  return phone.replace(/\D/g, "");
}

// ─── CONSTRUTOR DO PAYLOAD ───────────────────────────────────────────────────
/**
 * Monta o payload CAPI para o evento Lead.
 *
 * @param {object} formData  - Dados brutos capturados no formulário
 * @param {object} requestMeta - Dados do request HTTP (IP, User-Agent, fbclid)
 * @returns {object} payload pronto para enviar à API
 */
function buildLeadPayload(formData, requestMeta) {
  const {
    email,
    phone,
    firstName,
    lastName,
    city,
    state,           // sigla do estado: "SP", "RJ"…
    country = "br",  // ISO 3166-1 alpha-2, lowercase
    zipCode,
    // Campos de qualificação do formulário VinoBianco
    tamanhoAdega,     // Ex.: "50-200 garrafas"
    perfilConsumo,    // Ex.: "Colecionador", "Apreciador", "Investidor"
    origemLead,       // Ex.: "instagram_stories", "google_search"
  } = formData;

  const {
    clientIp,
    clientUserAgent,
    fbp,   // cookie _fbp (Facebook Browser ID)
    fbc,   // cookie _fbc  OU fbclid da URL
    eventSourceUrl,
  } = requestMeta;

  // Valor estimado do lead por perfil de qualificação
  const leadValueMap = {
    Colecionador: 1500,
    Investidor:   2500,
    Apreciador:    800,
  };
  const estimatedLeadValue = leadValueMap[perfilConsumo] ?? 500;

  return {
    data: [
      {
        // ── Identificadores do Evento ──────────────────────────────────────
        event_name: "Lead",
        event_time: Math.floor(Date.now() / 1000), // Unix timestamp (segundos)
        event_id: `vinobianco_lead_${Date.now()}_${Math.random().toString(36).slice(2)}`, // Deduplicação
        action_source: "website",
        event_source_url: eventSourceUrl || "https://vinobianco.com.br/concierge",

        // ── Dados do Usuário (Client User Data) — todos em SHA-256 ─────────
        user_data: {
          // Identifiers PII — OBRIGATÓRIO criptografar
          em:  sha256(email),                          // e-mail
          ph:  sha256(normalizePhone(phone)),          // telefone normalizado
          fn:  sha256(firstName),                      // primeiro nome
          ln:  sha256(lastName),                       // sobrenome
          ct:  sha256(city),                           // cidade
          st:  sha256(state),                          // estado
          zp:  sha256(zipCode),                        // CEP
          country: sha256(country),                    // país

          // Identifiers técnicos — NÃO criptografados
          client_ip_address:  clientIp,                // IP real do visitante
          client_user_agent:  clientUserAgent,         // User-Agent do browser
          fbp:  fbp  || null,                          // _fbp cookie
          fbc:  fbc  || null,                          // _fbc cookie ou ?fbclid=
        },

        // ── Dados do Produto / Lead ───────────────────────────────────────
        custom_data: {
          currency: "BRL",
          value: estimatedLeadValue,
          content_name: "Concierge VinoBianco",
          content_category: "Vinho Premium",
          // Campos customizados do formulário de qualificação
          tamanho_adega:   tamanhoAdega,
          perfil_consumo:  perfilConsumo,
          origem_lead:     origemLead,
        },
      },
    ],

    // ── Configurações de Teste (remover em produção) ───────────────────────
    // test_event_code: "TEST12345",   // Ative só para validar no Events Manager
  };
}

// ─── ENVIO PARA A API ────────────────────────────────────────────────────────
/**
 * Envia o evento Lead para a Meta CAPI.
 * Retorna o JSON de resposta da Meta (com fbtrace_id para debug).
 */
async function sendLeadEventToCAPI(formData, requestMeta) {
  const payload = buildLeadPayload(formData, requestMeta);

  const response = await fetch(`${META_CAPI_URL}?access_token=${META_ACCESS_TOKEN}`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(payload),
  });

  const result = await response.json();

  if (!response.ok) {
    // Log estruturado para rastrear erros no Make.com ou no servidor
    console.error("[Meta CAPI] Erro no envio:", JSON.stringify(result, null, 2));
    throw new Error(`Meta CAPI retornou status ${response.status}`);
  }

  console.log("[Meta CAPI] Evento enviado com sucesso:", result);
  return result;
}

// ─── EXEMPLO DE USO ─────────────────────────────────────────────────────────
// Em produção, estes dados virão do seu webhook/formulário backend.
//
// const exampleFormData = {
//   email:          "cliente@exemplo.com",
//   phone:          "+55 11 99999-8888",
//   firstName:      "João",
//   lastName:       "Silva",
//   city:           "São Paulo",
//   state:          "SP",
//   country:        "br",
//   zipCode:        "01310100",
//   tamanhoAdega:   "50-200 garrafas",
//   perfilConsumo:  "Colecionador",
//   origemLead:     "instagram_stories",
// };
//
// const exampleRequestMeta = {
//   clientIp:       "177.0.0.1",
//   clientUserAgent:"Mozilla/5.0 ...",
//   fbp:            "fb.1.1234567890.1234567890",
//   fbc:            "fb.1.1234567890.AbCdEfGhIj",
//   eventSourceUrl: "https://vinobianco.com.br/concierge",
// };
//
// sendLeadEventToCAPI(exampleFormData, exampleRequestMeta);

module.exports = { sendLeadEventToCAPI, buildLeadPayload, sha256 };
