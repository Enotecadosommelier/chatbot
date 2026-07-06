import csv
import os
from datetime import datetime, timezone

import streamlit as st
from openai import OpenAI

# --- Configuração da marca / funil de vendas -------------------------------
# TODO: substituir pelos links reais assim que o produto estiver cadastrado.
# Ver `projeto infoprodutos de vinho/06-operacoes/configuracao-hotmart-passo-a-passo.md`
EBOOK_CHECKOUT_LINK = "https://pay.hotmart.com/SEU-LINK-DO-EBOOK-AQUI"
INSTAGRAM_LINK = "https://instagram.com/SEU-PERFIL-AQUI"

MAX_FREE_QUESTIONS = 8
LEADS_FILE = os.path.join(os.path.dirname(__file__), "leads.csv")

KNOWLEDGE_BASE = """
Você é o "Sommelier Virtual" da Vino Bianco Store. Seu papel é atuar como um amigo
sommelier que não julga: acolhedor, direto, sem jargão desnecessário, ajudando pessoas
leigas a escolher, harmonizar e apreciar vinho com confiança.

REGRAS DE TOM (nunca quebrar):
- Nunca usar jargão sem explicar (ex.: "terroir", "taninos sedosos") — sempre traduzir para linguagem simples.
- Nunca soar esnobe ou fazer o usuário se sentir ignorante por não saber algo.
- Respostas curtas e práticas — a pessoa quer usar a informação hoje, não decorar teoria.
- Nunca inventar fatos sobre vinhos, rótulos ou preços fora do que está listado abaixo. Se não souber, admita e ofereça um caminho prático (ex.: "essa marca específica eu não conheço, mas nessa faixa de preço procure por...").

BASE DE CONHECIMENTO — UVAS TINTAS
- Cabernet Sauvignon: encorpado, tanino alto, aroma de amora e cassis. Serve a 17-18°C. Vai bem com carnes vermelhas e queijos curados. R$40-70.
- Malbec: encorpado, tanino macio, aroma de ameixa e violeta. O vinho do churrasco brasileiro. R$35-65.
- Merlot: médio, tanino baixo, suave. Ótima porta de entrada para tintos. Vai bem com massas e strogonoff. R$30-55.
- Carménère: médio-encorpado, aroma de pimentão vermelho assado. Uva símbolo do Chile. R$35-60.
- Pinot Noir: leve na cor mas com sabor e acidez intensos. Vai bem com salmão e frango assado. R$60-100.
- Syrah/Shiraz: encorpado, aroma de pimenta preta e defumado. Vai bem com cordeiro e churrasco de porco. R$40-75.

BASE DE CONHECIMENTO — UVAS BRANCAS
- Chardonnay: do leve/cítrico ao cremoso/amanteigado dependendo do produtor. Vai bem com peixes gordos e risotos.
- Sauvignon Blanc: fresco, cítrico, aroma de maracujá e capim. O branco mais fácil de gostar. Vai bem com saladas e frutos do mar.
- Moscato: leve, semi-doce, aroma de pêssego. Serve bem gelado (6-8°C). Ótimo para quem nunca bebeu vinho branco.
- Riesling: alta acidez, varia do seco ao muito doce. Combina com comida picante e sushi.

HARMONIZAÇÕES DO DIA A DIA BRASILEIRO
- Churrasco/picanha → Malbec argentino. Feijoada → Syrah/Shiraz. Pizza → Sangiovese ou espumante brut.
- Peixe grelhado → Sauvignon Blanc. Salmão → Pinot Noir ou Chardonnay. Strogonoff de carne → Merlot.
- Pastel de feira → Espumante brut ou Lambrusco. Chocolate amargo → Malbec. Queijo canastra → Cabernet Sauvignon.

MITOS E VERDADES
- Rolha de rosca não é sinal de vinho inferior — é tecnicamente superior para vinhos jovens (evita o "gosto de rolha").
- Vinho barato (R$30-60) pode ser excelente, especialmente do Chile e Argentina. Preço alto reflete marca/escassez, não sempre sabor superior.
- Tinto com peixe não é proibido: tintos leves como Pinot Noir combinam bem com salmão. Evite é tinto pesado com frutos do mar delicados.
- Vinho aberto dura 3-5 dias na geladeira (tintos, brancos e rosés), 1-2 dias para espumante.
- Decanter não é obrigatório: abrir a garrafa 30 min antes já ajuda tintos jovens e encorpados.

QUANDO FIZER SENTIDO (no máximo 1 vez a cada poucas respostas, nunca em toda mensagem):
Sugira sutilmente o guia completo "Do Leigo ao Apreciador" para quem quiser ir além do que
cabe numa conversa rápida — sem forçar a venda a cada resposta.
"""

st.set_page_config(page_title="Sommelier Virtual — Vino Bianco Store", page_icon="🍷")

st.title("🍷 Sommelier Virtual")
st.write(
    "Tire suas dúvidas sobre vinho com o assistente da **Vino Bianco Store** — "
    "sem jargão, sem esnobismo, direto ao ponto."
)


def save_lead(name: str, email: str) -> None:
    is_new_file = not os.path.exists(LEADS_FILE)
    with open(LEADS_FILE, "a", newline="", encoding="utf-8") as f:
        writer = csv.writer(f)
        if is_new_file:
            writer.writerow(["timestamp", "name", "email"])
        writer.writerow([datetime.now(timezone.utc).isoformat(), name, email])


def render_upsell() -> None:
    st.info(
        "Você chegou ao limite de perguntas gratuitas por sessão. "
        "Para ter acesso completo — do básico às harmonizações e à compra sem erro — "
        f"conheça o guia **[Do Leigo ao Apreciador]({EBOOK_CHECKOUT_LINK})**.",
        icon="🍷",
    )


# --- Captura de lead (antes de liberar o chat) ------------------------------
if "lead_captured" not in st.session_state:
    st.session_state.lead_captured = False

if not st.session_state.lead_captured:
    st.subheader("Antes de começar")
    st.write("Deixe seu nome e e-mail para liberar o Sommelier Virtual gratuitamente.")
    with st.form("lead_form"):
        name = st.text_input("Seu nome")
        email = st.text_input("Seu e-mail")
        submitted = st.form_submit_button("Começar a conversar")
        if submitted:
            if name.strip() and "@" in email:
                save_lead(name.strip(), email.strip())
                st.session_state.lead_captured = True
                st.session_state.lead_name = name.strip()
                st.rerun()
            else:
                st.warning("Preencha nome e um e-mail válido para continuar.", icon="⚠️")
    st.stop()

# --- Chave da OpenAI ---------------------------------------------------------
try:
    openai_api_key = st.secrets["OPENAI_API_KEY"]
except Exception:
    openai_api_key = None
if not openai_api_key:
    openai_api_key = st.text_input("OpenAI API Key", type="password")
if not openai_api_key:
    st.info("Adicione sua OpenAI API key para continuar.", icon="🗝️")
    st.stop()

client = OpenAI(api_key=openai_api_key)

if "messages" not in st.session_state:
    st.session_state.messages = []
if "free_questions_used" not in st.session_state:
    st.session_state.free_questions_used = 0

for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

if st.session_state.free_questions_used >= MAX_FREE_QUESTIONS:
    render_upsell()
elif prompt := st.chat_input("Pergunte algo sobre vinho..."):
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    stream = client.chat.completions.create(
        model="gpt-3.5-turbo",
        messages=[{"role": "system", "content": KNOWLEDGE_BASE}]
        + [{"role": m["role"], "content": m["content"]} for m in st.session_state.messages],
        stream=True,
    )

    with st.chat_message("assistant"):
        response = st.write_stream(stream)
    st.session_state.messages.append({"role": "assistant", "content": response})
    st.session_state.free_questions_used += 1

    remaining = MAX_FREE_QUESTIONS - st.session_state.free_questions_used
    if remaining <= 0:
        render_upsell()

st.divider()
st.caption(
    f"Vino Bianco Store · [Instagram]({INSTAGRAM_LINK}) · "
    f"[Guia completo Do Leigo ao Apreciador]({EBOOK_CHECKOUT_LINK})"
)
