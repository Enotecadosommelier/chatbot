# Configuração Hotmart — Valores Exatos Para Copiar e Colar
## Vino Bianco Store — Esteira Ebook + Order Bump

Este documento não substitui o acesso à sua conta Hotmart — a Hotmart não expõe API pública de cadastro de produto para automação externa, e o cadastro exige seus dados fiscais/bancários. O que segue são os valores exatos já decididos, prontos para você preencher em cada tela, sem precisar decidir nada no momento do cadastro.

---

## PASSO 1 — Criar conta Hotmart Producer

1. Acesse hotmart.com → "Quero vender" → cadastro como Produtor.
2. Complete verificação de identidade e dados bancários (obrigatório para receber pagamentos).

---

## PASSO 2 — Cadastrar o produto principal

| Campo | Valor exato |
|---|---|
| Nome do produto | Do Leigo ao Apreciador — Guia Definitivo de Vinho |
| Categoria | E-books / Gastronomia & Bebidas |
| Tipo de produto | Digital — E-book |
| Preço | R$ 57,00 (variação A/B sugerida: testar R$47 e R$67 após 30 dias de dados) |
| Formato de entrega | Upload de arquivo (PDF) + versão ePub opcional |
| Arquivo a subir | Versão final diagramada de `02-produtos/ebook-vol1-manuscrito-completo.md` (ver Passo 5) |
| Comissão de afiliados | 30% |
| Garantia | 7 dias incondicional |
| Descrição curta (para o marketplace) | "Aprenda a escolher, harmonizar e apreciar vinho com confiança — sem jargão, sem esnobismo, em linguagem simples para quem nunca estudou sobre o assunto." |
| Página de vendas | Usar copy completa de `04-copy/pagina-de-vendas-hotmart.md` |

---

## PASSO 3 — Configurar o Order Bump

| Campo | Valor exato |
|---|---|
| Nome | Manual do Bar em Casa |
| Preço | R$ 17,00 |
| Onde aparece | Mesma tela de checkout do produto principal (ativar em "Order Bump" nas configurações de checkout) |
| Arquivo | Versão final diagramada de `02-produtos/bonus-manual-bar-em-casa.md` |
| Texto de oferta sugerido | "Adicione por apenas R$17: o guia prático para montar seu cantinho de vinhos em casa — taças, temperatura e como servir como um anfitrião confiante." |

---

## PASSO 4 — Configurar upsell pós-compra (página de obrigado)

| Campo | Valor exato |
|---|---|
| Produto ofertado | Acesso antecipado ao Curso Fundamentos do Vinho Brasileiro |
| Preço normal | R$ 97,00 |
| Preço da oferta (24h) | R$ 67,00 |
| Onde configurar | Hotmart → Produto → Página de Obrigado → "Oferta Única" (One Time Offer) |

*Observação: o Curso Fundamentos ainda não existe como produto gravado — este upsell só deve ser ativado quando o curso estiver produzido. Até lá, deixe a página de obrigado apenas com o vídeo de boas-vindas.*

---

## PASSO 5 — Preparar os arquivos finais para upload

Os manuscritos completos já estão escritos e prontos para diagramação:
- `02-produtos/ebook-vol1-manuscrito-completo.md` → produto principal
- `02-produtos/bonus-manual-bar-em-casa.md` → order bump
- `02-produtos/lead-magnet-5-vinhos.md` → isca gratuita (não vai para o Hotmart, ver Passo 7)

Passos de diagramação (fora do escopo de código, requer Canva):
1. Abrir Canva → criar design tipo "eBook" com as dimensões A4.
2. Aplicar Brand Kit com as cores e fontes de `01-marca/identidade-visual.md`.
3. Colar o texto de cada capítulo, adicionar ao menos 1 imagem/gráfico por capítulo (usar bancos gratuitos como Unsplash/Pexels com termo "wine", ou gerar imagens próprias).
4. Exportar como PDF de alta qualidade (Canva: "Compartilhar" → "Baixar" → PDF Padrão).
5. Repetir para o order bump.

---

## PASSO 6 — Checklist final antes de divulgar

- [ ] Produto principal cadastrado com preço R$57
- [ ] Order Bump "Manual do Bar em Casa" ativo (R$17)
- [ ] Garantia de 7 dias configurada
- [ ] PDF final revisado (sem erros de digitação, links funcionando)
- [ ] Área de membros ativada (mesmo para ebook — aumenta percepção de valor)
- [ ] Webhook configurado para Mailchimp (Hotmart → Ferramentas → Webhook → apontar para integração Mailchimp/Zapier)
- [ ] Link de afiliados gerado e documentado para futuros parceiros
- [ ] Compra de teste completa feita do zero (do checkout até o recebimento do PDF) antes de qualquer divulgação paga ou orgânica

---

## PASSO 7 — Onde entra o Lead Magnet gratuito

O lead magnet **não** é cadastrado na Hotmart (é grátis). Ele é hospedado como link direto (Google Drive/Dropbox com permissão "qualquer pessoa com o link pode visualizar") e entregue via:
- Automação ManyChat no Instagram (fluxo completo já documentado em `06-operacoes/automacao-instagram-manychat.md`)
- Ou formulário de e-mail no Mailchimp, com o link de download na primeira mensagem da sequência de `04-copy/sequencia-7-emails.md`

---

*Depois de completar os Passos 1–6, a esteira de entrada (lead magnet → ebook → order bump) está tecnicamente pronta para começar a vender. Os produtos de ticket mais alto (curso R$97, curso premium R$297, consultoria R$997, clube R$47/mês) permanecem como próxima fase — não são bloqueadores para o lançamento inicial.*
