# Checklist Final de Implementação
## Do zero ao ar — Sistema de Relacionamento WhatsApp Vino Bianco Store

---

## FASE 0 — Pré-requisitos de conta

- [ ] Conta ManyChat no plano **Pro** (necessário para automações avançadas + API + WhatsApp)
- [ ] Número de WhatsApp Business (Cloud API da Meta) dedicado à loja, não o WhatsApp pessoal
- [ ] Conta Meta Business Manager configurada e verificada
- [ ] WhatsApp conectado ao ManyChat (Settings → WhatsApp → Connect)

---

## FASE 1 — Compliance e Templates

- [ ] Submeter para aprovação da Meta os templates (HSM) necessários para iniciar conversa fora da janela de 24h:
  - [ ] Template de abertura Fluxo 1 (Vinho da Semana)
  - [ ] Template de abertura Fluxo 2 (Harmonização da Semana)
  - [ ] Template de abertura Fluxo 3 (Escola do Vinho)
  - [ ] Template de abertura Fluxo 4 (Descubra o Mundo)
- [ ] Aguardar aprovação (pode levar de horas a 2 dias)
- [ ] Confirmar horário de disparo dentro da política do WhatsApp (evitar volume alto fora de 8h–21h)

---

## FASE 2 — Estrutura no ManyChat

- [ ] Criar as 14 Tags (`06-integracao-json-api.md` tem a lista completa) — manual ou via `manychat_setup.py`
- [ ] Criar os 12 Custom Fields — manual ou via `manychat_setup.py`
- [ ] Criar os 4 Flows principais:
  - [ ] `FLUXO_VINHO_DA_SEMANA`
  - [ ] `FLUXO_HARMONIZACAO_DA_SEMANA`
  - [ ] `FLUXO_ESCOLA_DO_VINHO`
  - [ ] `FLUXO_DESCUBRA_MUNDO_VINHO`
- [ ] Criar os Flows auxiliares reutilizáveis:
  - [ ] `AUX_ENVIAR_CATALOGO`
  - [ ] `AUX_HANDOFF_SOMMELIER`
  - [ ] `AUX_LEMBRETE_48H`
- [ ] Configurar os Goals: `Engajamento Semanal`, `Conversão Harmonização`, `Reengajamento`

---

## FASE 3 — Conteúdo

- [ ] Carregar as 6 mensagens completas de exemplo do Fluxo 1 (`01-fluxo1-vinho-da-semana.md`)
- [ ] Carregar as 6 mensagens completas de exemplo do Fluxo 2 (`02-fluxo2-harmonizacao-semana.md`)
- [ ] Carregar as 6 aulas completas de exemplo do Fluxo 3 (`03-fluxo3-escola-do-vinho.md`)
- [ ] Carregar os 4 países completos de exemplo do Fluxo 4 (`04-fluxo4-descubra-mundo-vinho.md`)
- [ ] Escrever as mensagens completas das semanas restantes usando o calendário (`05-calendario-anual.md`) + os templates de cada fluxo
- [ ] Revisar todo o texto quanto a tom de voz (sommelier, elegante, sem jargão sem explicação) — usar `01-marca/identidade-visual.md` como guia

---

## FASE 4 — Agendamento

- [ ] Configurar disparo semanal de terça 09:00 (Fluxo 1) — via Broadcast recorrente nativo ou via Make/Pabbly Connect
- [ ] Configurar disparo semanal de quinta 09:00 (Fluxo 2)
- [ ] Configurar disparo semanal de sexta 09:00 com lógica de alternância (Custom Field `ultimo_fluxo_sexta`)
- [ ] Testar a lógica de alternância por 2 sextas seguidas para confirmar que nunca repete o mesmo fluxo

---

## FASE 5 — Integrações (preparadas, mas opcionais para o "ao vivo" inicial)

- [ ] Confirmar se a plataforma de e-commerce da loja tem webhook de "pedido pago" disponível
- [ ] Se sim, conectar via Make/Pabbly Connect para aplicar tags de compra automaticamente
- [ ] Deixar os blocos External Request de Shopify e RD Station documentados e prontos, mas **desativados** até ter as contas confirmadas

---

## FASE 6 — Teste antes de ir ao ar

- [ ] Testar o fluxo completo com um número de teste (o seu próprio celular) para cada um dos 4 fluxos
- [ ] Verificar se os botões funcionam e disparam as ações corretas (tags, goals, delays)
- [ ] Verificar se a mensagem de lembrete de 48h dispara corretamente quando não há clique
- [ ] Verificar se o Live Chat Handoff notifica a pessoa certa da equipe

---

## FASE 7 — Ativação e monitoramento

- [ ] Ativar o envio para a base real de contatos
- [ ] Acompanhar semanalmente: taxa de abertura, taxa de clique por CTA, taxa de conversão em compra (Goal "Conversão Harmonização")
- [ ] Revisar mensalmente a tag `Não responde há 30 dias` e considerar uma campanha específica de reengajamento
- [ ] Planejar o "Ano 2" de conteúdo com pelo menos 60 dias de antecedência do fim do ciclo de 52 semanas

---

## SEGURANÇA

- [ ] Nunca deixar a API Key do ManyChat em texto puro em repositórios de código, planilhas compartilhadas ou mensagens de chat
- [ ] Se a chave já foi exposta em algum momento (chat, print, etc.), gerar uma nova chave em Settings → API → Atualizar Chave API
