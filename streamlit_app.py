import streamlit as st
from openai import OpenAI

# Page configuration
st.set_page_config(page_title="Vino Bianco - Sommelier Virtual", page_icon="🍷", layout="centered")

# Custom CSS for Vino Bianco branding
st.markdown("""
    <style>
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap');

    html, body, [class*="css"] {
        font-family: 'Inter', sans-serif;
    }

    .main {
        background-color: #ffffff;
    }

    .stButton>button {
        background-color: #7a1b3d;
        color: white;
        border-radius: 4px;
        border: none;
        padding: 0.5rem 1rem;
        font-weight: 700;
    }

    .stButton>button:hover {
        background-color: #5e152f;
        color: white;
    }

    .hero-title {
        color: #7a1b3d;
        font-size: 3rem;
        font-weight: 700;
        text-align: center;
        margin-top: 2rem;
    }

    .hero-subtitle {
        color: #505050;
        font-size: 1.5rem;
        text-align: center;
        margin-bottom: 2rem;
    }

    .benefit-card {
        text-align: center;
        padding: 1rem;
    }

    .benefit-icon {
        font-size: 2rem;
        color: #7a1b3d;
    }

    .benefit-text {
        font-weight: 700;
        color: #151414;
    }
    </style>
    """, unsafe_allow_html=True)

# Header with Logo
st.image("https://static.vowt.com.br/vinobianco/image/catalog/banners/logo-vinobianco1.png", width=250)

# Hero Section
st.markdown('<h1 class="hero-title">Vino Bianco</h1>', unsafe_allow_html=True)
st.markdown('<p class="hero-subtitle">Excelência em Vinhos Selecionados na Sua Mesa</p>', unsafe_allow_html=True)

# Benefits Section
col1, col2, col3 = st.columns(3)
with col1:
    st.markdown('<div class="benefit-card"><div class="benefit-icon">🚚</div><div class="benefit-text">Entrega em todo o Brasil</div></div>', unsafe_allow_html=True)
with col2:
    st.markdown('<div class="benefit-card"><div class="benefit-icon">💰</div><div class="benefit-text">10% OFF no PIX</div></div>', unsafe_allow_html=True)
with col3:
    st.markdown('<div class="benefit-card"><div class="benefit-icon">💳</div><div class="benefit-text">Até 8x sem juros</div></div>', unsafe_allow_html=True)

st.divider()

# AI Sommelier Section
st.title("🍷 Sommelier Virtual Vino Bianco")
st.write(
    "Olá! Eu sou o seu Sommelier Virtual. Posso te ajudar a escolher o vinho perfeito para qualquer ocasião, "
    "harmonizar com pratos especiais ou tirar dúvidas sobre nossa seleção exclusiva."
)

# OpenAI API key setup
openai_api_key = st.sidebar.text_input("OpenAI API Key", type="password")
if not openai_api_key:
    st.info("Por favor, adicione sua OpenAI API key para conversar com o Sommelier.", icon="🗝️")
else:
    client = OpenAI(api_key=openai_api_key)

    if "messages" not in st.session_state:
        st.session_state.messages = [
            {"role": "system", "content": "Você é um Sommelier profissional da Vino Bianco, uma loja de vinhos de alta qualidade no Brasil. Seu objetivo é ajudar os clientes a escolher vinhos, explicar harmonizações e falar sobre a cultura do vinho de forma elegante, prestativa e conhecedora. Seja cordial e use termos técnicos de forma acessível."}
        ]

    for message in st.session_state.messages:
        if message["role"] != "system":
            with st.chat_message(message["role"]):
                st.markdown(message["content"])

    if prompt := st.chat_input("Como posso te ajudar hoje?"):
        st.session_state.messages.append({"role": "user", "content": prompt})
        with st.chat_message("user"):
            st.markdown(prompt)

        stream = client.chat.completions.create(
            model="gpt-3.5-turbo",
            messages=[
                {"role": m["role"], "content": m["content"]}
                for m in st.session_state.messages
            ],
            stream=True,
        )

        with st.chat_message("assistant"):
            response = st.write_stream(stream)
        st.session_state.messages.append({"role": "assistant", "content": response})

st.divider()

# Call to Action
st.markdown('<div style="text-align: center;">', unsafe_allow_html=True)
st.link_button("Ir para a Loja Completa Vino Bianco", "https://www.vinobianco.com.br")
st.markdown('</div>', unsafe_allow_html=True)
