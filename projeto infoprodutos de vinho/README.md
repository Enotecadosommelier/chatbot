# Projeto: Infoprodutos de Vinho — Leigo ao Expert
## Vino Bianco Store | Jorge Berto

---

## Estrutura do Projeto

```
projeto-vinho/
├── 01-marca/
│   └── identidade-visual.md        ← Paleta cores, fontes, tom de voz, logo
├── 02-produtos/
│   ├── esteira-completa.md         ← Todos os produtos + configuração Hotmart
│   ├── sumario-ebook-vol1.md       ← Sumário detalhado do Ebook Vol.1 (92 páginas)
│   ├── ebook-vol1-manuscrito-completo.md  ← Manuscrito completo, pronto para diagramação
│   ├── lead-magnet-5-vinhos.md     ← Isca gratuita completa
│   └── bonus-manual-bar-em-casa.md ← Order bump completo (R$17)
├── 03-conteudo/
│   └── calendario-editorial-90-dias.md  ← Instagram + YouTube, semana a semana
├── 04-copy/
│   ├── pagina-de-vendas-hotmart.md ← Copy completa da página de vendas
│   └── sequencia-7-emails.md       ← 7 emails pós-captura (régua completa)
├── 05-conhecimento/
│   ├── biblioteca-mestre-uvas.md   ← Fichas de 10 uvas (tintas e brancas)
│   ├── biblioteca-mestre-faqs.md   ← FAQs + Harmonizações do dia a dia
│   └── dores-do-leigo.md           ← Dores, avatar, frases reais do público
└── 06-operacoes/
    ├── automacao-instagram-manychat.md ← Funil completo ManyChat + roteiros Reels
    └── configuracao-hotmart-passo-a-passo.md ← Valores exatos para cadastrar produto/order bump/upsell na Hotmart
```

---

## Prioridades de Execução

### FASE 1 — Produto (Semanas 1–2)
- [x] Escrever manuscrito completo do ebook (`02-produtos/ebook-vol1-manuscrito-completo.md`)
- [x] Escrever lead magnet gratuito completo (`02-produtos/lead-magnet-5-vinhos.md`)
- [x] Escrever Order Bump "Manual do Bar em Casa" completo (`02-produtos/bonus-manual-bar-em-casa.md`)
- [ ] Diagramar ebook no Canva (texto pronto — falta só a diagramação visual, passos em `06-operacoes/configuracao-hotmart-passo-a-passo.md#passo-5`)
- [ ] Criar capa profissional + mockup 3D
- [ ] Configurar produto na Hotmart (valores exatos prontos em `06-operacoes/configuracao-hotmart-passo-a-passo.md`)
- [ ] Configurar Order Bump na tela de checkout (valores exatos no mesmo arquivo acima)

### FASE 2 — Vendas (Semana 3)
- [ ] Publicar página de vendas (usar copy em `04-copy/pagina-de-vendas-hotmart.md`)
- [ ] Criar sequência de emails no Mailchimp (usar `04-copy/sequencia-7-emails.md`)
- [ ] Configurar ManyChat no Instagram (usar `06-operacoes/automacao-instagram-manychat.md`)
- [ ] Publicar o Sommelier Virtual (chatbot) como isca de captura de lead — ver `../streamlit_app.py`

### FASE 3 — Conteúdo (Semanas 4–16)
- [ ] Gravar primeiros 7 Reels (roteiros em `06-operacoes/automacao-instagram-manychat.md`)
- [ ] Seguir calendário editorial (`03-conteudo/calendario-editorial-90-dias.md`)
- [ ] Usar Biblioteca Mestre como base de conhecimento para todos os posts

---

## Esteira de Produtos (Resumo)

| Produto                    | Preço    | Status      |
|----------------------------|----------|-------------|
| Lead Magnet (gratuito)     | R$0      | Criar       |
| Ebook Vol.1 Do Leigo ao Apreciador | R$57 | **PRIORIDADE** |
| Order Bump: Manual do Bar  | R$17     | Criar junto |
| Curso Fundamentos (vídeo)  | R$97     | Próximo     |
| Curso Premium              | R$297    | Futuro      |
| Consultoria Individual     | R$997    | Futuro      |
| Clube Vino Bianco          | R$47/mês | Futuro      |

---

## Plataformas e Ferramentas

| Ferramenta        | Uso                          | Status         |
|-------------------|------------------------------|----------------|
| Hotmart           | Venda do ebook               | Configurar     |
| ManyChat          | Automação Instagram          | Configurar     |
| Mailchimp         | Email marketing              | Configurar     |
| Canva             | Design (ebook, posts)        | Criar templates|
| Instagram Business| Publicação de conteúdo       | Já ativo       |
| YouTube           | Vídeos longos                | Criar canal    |

---

## Instrução para o Claude (manutenção do projeto)

> Sempre que for criar conteúdo, copy ou responder dúvidas deste projeto, consulte primeiro:
> 1. `05-conhecimento/` — para fatos técnicos sobre vinho
> 2. `05-conhecimento/dores-do-leigo.md` — para tom e linguagem correta
> 3. `01-marca/identidade-visual.md` — para tom de voz e identidade
>
> **Nunca inventar informações sobre vinhos.** Usar apenas o que está na biblioteca mestre.
> **Nunca usar jargão sem explicar.** Sempre traduzir termos técnicos.
