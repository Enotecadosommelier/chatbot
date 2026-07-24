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
│   └── sumario-ebook-vol1.md       ← Sumário detalhado do Ebook Vol.1 (92 páginas)
├── 03-conteudo/
│   └── calendario-editorial-90-dias.md  ← Instagram + YouTube, semana a semana
├── 04-copy/
│   ├── pagina-de-vendas-hotmart.md ← Copy completa da página de vendas
│   └── sequencia-7-emails.md       ← 7 emails pós-captura (régua completa)
├── 05-conhecimento/
│   ├── biblioteca-mestre-uvas.md   ← Fichas de 10 uvas (tintas e brancas)
│   ├── biblioteca-mestre-faqs.md   ← FAQs + Harmonizações do dia a dia
│   └── dores-do-leigo.md           ← Dores, avatar, frases reais do público
├── 06-operacoes/
│   ├── automacao-instagram-manychat.md ← Funil completo ManyChat + roteiros Reels
│   └── automacao-recuperacao-pedidos-manychat.md ← Recuperação de pedidos com pagamento pendente (PIX/Boleto/Cartão)
└── 07-relacionamento-whatsapp-manychat/
    ├── 00-arquitetura-geral.md          ← Visão geral, fluxograma Mermaid, tags, campos
    ├── 01-fluxo1-vinho-da-semana.md     ← Vinho da Semana (terça)
    ├── 02-fluxo2-harmonizacao-semana.md ← Harmonização da Semana (quinta)
    ├── 03-fluxo3-escola-do-vinho.md     ← Escola do Vinho (sexta, alternado)
    ├── 04-fluxo4-descubra-mundo-vinho.md← Descubra o Mundo do Vinho (sexta, alternado)
    ├── 05-calendario-anual.md           ← 156 conteúdos únicos, semana a semana
    ├── 06-integracao-json-api.md        ← JSON de referência Shopify/RD Station
    ├── manychat_setup.py                ← Script para criar Tags/Custom Fields via API
    ├── 07-checklist-implementacao.md    ← Checklist do zero ao ar
    └── 08-manual-operacional-iniciante.md ← Manual sem conhecimento técnico
```

---

## Prioridades de Execução

### FASE 1 — Produto (Semanas 1–2)
- [ ] Diagramar ebook no Canva (usar sumário em `02-produtos/sumario-ebook-vol1.md`)
- [ ] Criar capa profissional + mockup 3D
- [ ] Criar lead magnet gratuito (mini-guia 5 vinhos)
- [ ] Configurar produto na Hotmart
- [ ] Configurar Order Bump (Manual do Bar em Casa)

### FASE 2 — Vendas (Semana 3)
- [ ] Publicar página de vendas (usar copy em `04-copy/pagina-de-vendas-hotmart.md`)
- [ ] Criar sequência de emails no Mailchimp (usar `04-copy/sequencia-7-emails.md`)
- [ ] Configurar ManyChat no Instagram (usar `06-operacoes/automacao-instagram-manychat.md`)

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
