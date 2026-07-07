// ============================================================================
// CONFIGURAÇÃO: cole aqui a URL do seu Google Apps Script Web App.
// Veja o README.md ("Como conectar o formulário ao Google Sheet") para o
// passo a passo de como publicar o script e obter essa URL.
// ============================================================================
const WEBHOOK_URL = "https://script.google.com/macros/s/SEU_SCRIPT_ID_AQUI/exec";

// Número exibido enquanto a contagem real ainda não pôde ser carregada.
const FALLBACK_WAITLIST_COUNT = 0;

const form = document.getElementById("waitlist-form");
const emailInput = document.getElementById("email");
const submitButton = document.getElementById("waitlist-submit");
const messageEl = document.getElementById("waitlist-message");
const countEl = document.getElementById("waitlist-count");

function setMessage(text, state) {
  messageEl.textContent = text;
  if (state) {
    messageEl.setAttribute("data-state", state);
  } else {
    messageEl.removeAttribute("data-state");
  }
}

function isConfigured() {
  return !WEBHOOK_URL.includes("SEU_SCRIPT_ID_AQUI");
}

async function loadWaitlistCount() {
  if (!isConfigured()) {
    countEl.textContent = FALLBACK_WAITLIST_COUNT;
    return;
  }

  try {
    const response = await fetch(`${WEBHOOK_URL}?action=count`, { method: "GET" });
    if (!response.ok) throw new Error("Falha ao buscar contagem");
    const data = await response.json();
    countEl.textContent = typeof data.count === "number" ? data.count : FALLBACK_WAITLIST_COUNT;
  } catch (error) {
    console.warn("Não foi possível carregar a contagem da lista de espera:", error);
    countEl.textContent = FALLBACK_WAITLIST_COUNT;
  }
}

function trackWaitlistConversion() {
  // ==========================================================================
  // GOOGLE ADS / GA4 — evento de conversão (placeholder).
  // Depois de configurar as tags no <head> do index.html, descomente as linhas
  // abaixo e troque "AW-XXXXXXXXX/YYYYYYYYYYYYYYYYY" pelo rótulo de conversão
  // real (Google Ads > Conversões > sua ação > Configuração da tag > Evento).
  // ==========================================================================
  // if (typeof gtag === "function") {
  //   gtag("event", "conversion", { send_to: "AW-XXXXXXXXX/YYYYYYYYYYYYYYYYY" });
  //   gtag("event", "waitlist_signup");
  // }
}

form.addEventListener("submit", async (event) => {
  event.preventDefault();

  const email = emailInput.value.trim();
  if (!email || !emailInput.checkValidity()) {
    setMessage("Digite um e-mail válido.", "error");
    return;
  }

  if (!isConfigured()) {
    setMessage(
      "Formulário ainda não configurado: defina WEBHOOK_URL em script.js (veja o README).",
      "error",
    );
    return;
  }

  submitButton.disabled = true;
  setMessage("Enviando...", null);

  try {
    // Content-Type text/plain evita que o navegador dispare uma requisição de
    // pré-voo (CORS preflight) que o Apps Script não sabe responder.
    const response = await fetch(WEBHOOK_URL, {
      method: "POST",
      headers: { "Content-Type": "text/plain;charset=utf-8" },
      body: JSON.stringify({ email }),
    });

    if (!response.ok) throw new Error(`HTTP ${response.status}`);

    setMessage("Pronto! Você está na lista. Avisaremos por e-mail no lançamento.", "success");
    form.reset();
    trackWaitlistConversion();
    loadWaitlistCount();
  } catch (error) {
    console.error("Erro ao enviar e-mail para a lista de espera:", error);
    setMessage("Não foi possível enviar agora. Tente novamente em instantes.", "error");
  } finally {
    submitButton.disabled = false;
  }
});

loadWaitlistCount();
