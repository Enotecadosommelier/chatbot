# FocoZen

App Android nativo de bloqueio de apps por foco + landing page de lista de espera.

```
focozen-android/   # app Kotlin + Jetpack Compose (Clean Architecture)
landing-page/      # site estático de captura de e-mail (HTML/CSS/JS puro)
```

> **Nota sobre este ambiente:** este código foi escrito em um ambiente de nuvem sem o Android
> SDK instalado e sem acesso ao repositório Maven do Google (`dl.google.com`/`maven.google.com`),
> então **não foi possível rodar `./gradlew build` aqui**. Antes de considerar o app pronto, abra
> `focozen-android/` no Android Studio (Hedgehog ou mais recente), deixe o Gradle sincronizar e
> rode `Build > Make Project` — isso vai expor qualquer erro de compilação que não pôde ser
> validado neste ambiente. A landing page, por ser HTML/CSS/JS puro, foi testada e capturada em
> screenshots (mobile e desktop) nesta sessão.

---

## 1. Como testar as permissões do app (use um dispositivo físico, não emulador)

As três permissões sensíveis do FocoZen (acesso a estatísticas de uso, sobreposição de tela e
serviço de acessibilidade) dependem de comportamento real do Android que **emuladores frequentemente
simulam mal ou não simulam** (detecção de troca de app em segundo plano, overlays do sistema,
throttling de bateria). Teste sempre em um aparelho físico Android 8.0+ (API 26+).

Passo a passo:

1. Conecte o aparelho por USB com a **depuração USB** ativada (Ajustes > Sobre o telefone > toque
   7x em "Número da versão" > Ajustes > Opções do desenvolvedor > Depuração USB).
2. No Android Studio, selecione o aparelho na barra de dispositivos e rode o app (`Run > Run 'app'`).
3. Ao abrir o app, siga as 3 telas de onboarding uma por uma:
   - **Acesso a estatísticas de uso**: o botão leva a Ajustes > Acesso a dados de uso. Ative o
     FocoZen na lista e volte com o botão "Voltar" do sistema — a tela deve detectar
     automaticamente que a permissão foi concedida (não precisa reabrir o app).
   - **Sobreposição de tela**: mesmo fluxo, leva a Ajustes > Apps > Acesso especial > Exibir sobre
     outros apps.
   - **Serviço de acessibilidade**: leva a Ajustes > Acessibilidade > Serviços instalados >
     FocoZen. Ative o serviço; o Android mostra um aviso padrão do sistema explicando os riscos de
     serviços de acessibilidade — isso é esperado e não é um bug do app.
4. Vá em "Escolher apps a bloquear" e selecione 1-2 apps (ex: um app de rede social).
5. Saia do FocoZen e abra o app selecionado. Depois de alguns instantes a tela de fricção deve
   aparecer por cima do app, com a contagem regressiva de 20 segundos.
   - Se a tela de bloqueio não aparecer, confira nesta ordem: (a) o serviço de acessibilidade
     ainda está ativo (o Android às vezes desativa serviços de acessibilidade de apps que ficaram
     muito tempo sem uso, por economia de bateria); (b) a permissão de sobreposição segue
     concedida; (c) o app que você abriu é exatamente o que foi marcado na lista.
6. Teste os dois botões ao final da contagem: "Voltar ao que importa" deve te levar à tela inicial
   do sistema; "Continuar mesmo assim" deve fechar o overlay e deixar você usar o app normalmente.
7. Abra o Firebase Console (Analytics > DebugView, com `adb shell setprop debug.firebase.analytics.app com.focozen.app.debug`
   ativo) para confirmar que os eventos de onboarding, seleção de apps e bloqueio estão chegando.

---

## 2. Como hospedar a landing page gratuitamente

A pasta `landing-page/` é HTML/CSS/JS puro — qualquer host estático serve. Três opções gratuitas:

### Opção A — Vercel (mais simples)
1. Crie uma conta em vercel.com com seu GitHub.
2. "Add New… > Project", selecione este repositório.
3. Em "Root Directory", aponte para `landing-page`.
4. Não é preciso build command (site estático) — deixe em branco e clique em "Deploy".
5. A Vercel gera uma URL `https://seu-projeto.vercel.app` automaticamente, com HTTPS grátis.

### Opção B — GitHub Pages
1. No GitHub, vá em Settings > Pages do repositório.
2. Em "Source", escolha a branch atual e a pasta `/landing-page` (ou mova o conteúdo para uma
   branch `gh-pages` se preferir a pasta raiz).
3. O GitHub publica em `https://seu-usuario.github.io/seu-repo/`.

### Opção C — Firebase Hosting
1. Instale a CLI: `npm install -g firebase-tools`.
2. `firebase login`, depois `firebase init hosting` dentro de `landing-page/` (escolha "Use an
   existing project" ou crie um novo projeto Firebase gratuito).
3. Quando perguntado pelo diretório público, use `.` (a própria pasta `landing-page`).
4. `firebase deploy` — a CLI retorna a URL pública (`https://seu-projeto.web.app`).

Em qualquer uma das opções, depois do deploy, edite `index.html` e `script.js` para trocar os IDs
placeholder (GA4, Google Ads, `WEBHOOK_URL`) pelos valores reais e faça o deploy de novo.

---

## 3. Como conectar o formulário ao Google Sheet (via Google Apps Script — gratuito)

1. Crie uma nova planilha no Google Sheets. Na primeira linha, adicione os cabeçalhos `email` e
   `timestamp`.
2. Nessa planilha, vá em **Extensões > Apps Script**.
3. Apague o conteúdo padrão e cole o script abaixo:

   ```javascript
   function doPost(e) {
     const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sheet1");
     const data = JSON.parse(e.postData.contents);
     const email = (data.email || "").trim();

     if (!email || email.indexOf("@") === -1) {
       return ContentService.createTextOutput(
         JSON.stringify({ success: false, error: "invalid_email" })
       ).setMimeType(ContentService.MimeType.JSON);
     }

     sheet.appendRow([email, new Date()]);

     return ContentService.createTextOutput(
       JSON.stringify({ success: true })
     ).setMimeType(ContentService.MimeType.JSON);
   }

   function doGet(e) {
     const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName("Sheet1");
     // -1 para descontar a linha de cabeçalho.
     const count = Math.max(0, sheet.getLastRow() - 1);
     return ContentService.createTextOutput(
       JSON.stringify({ count: count })
     ).setMimeType(ContentService.MimeType.JSON);
   }
   ```

4. Clique em **Implantar > Nova implantação**.
5. Tipo: "App da Web". Em "Executar como", escolha "Eu (seu e-mail)". Em "Quem pode acessar",
   escolha **"Qualquer pessoa"** (obrigatório para o formulário público conseguir enviar dados).
6. Autorize as permissões solicitadas (é a sua própria planilha, o aviso de "app não verificado" é
   esperado — clique em Avançado > Acessar).
7. Copie a URL gerada (formato `https://script.google.com/macros/s/AAAA.../exec`).
8. Cole essa URL na constante `WEBHOOK_URL` no topo de `landing-page/script.js`.
9. Sempre que editar o código do Apps Script, você precisa **implantar uma nova versão**
   (Implantar > Gerenciar implantações > editar > Nova versão) para as mudanças valerem — só
   salvar o script não é suficiente.

Limitação conhecida: o Apps Script não permite configurar cabeçalhos CORS customizados, então o
`script.js` envia o POST com `Content-Type: text/plain` (para evitar o preflight OPTIONS, que o
Apps Script não responde) e assume sucesso quando o `fetch` não lança erro de rede. Se quiser
confirmação mais rígida de entrega, migre para uma função serverless própria (Cloudflare Workers,
Vercel Functions) no futuro — mas para uma lista de espera de pré-lançamento, o Apps Script é
suficiente e gratuito.

---

## 4. Antes de publicar o app: checklist

Não publique o FocoZen na Play Store sem resolver os itens abaixo:

- [ ] **Produtos de billing reais**: os IDs `focozen_weekly` e `focozen_yearly` usados no código
      são apenas os identificadores esperados — você precisa criar esses produtos de assinatura de
      verdade no Play Console (Monetização > Produtos > Assinaturas), com preço, período de trial
      de 7 dias e textos legais. Sem isso, `BillingManager` não encontra `ProductDetails` e a tela
      de Paywall fica vazia.
- [ ] **`google-services.json` real**: o arquivo em `focozen-android/app/google-services.json`
      neste repositório é um **placeholder** com valores falsos. Crie um projeto Firebase de
      verdade (Analytics + Crashlytics) e baixe o `google-services.json` real, substituindo o
      placeholder antes do build de release.
- [ ] **Política de privacidade completa do app**: a política na landing page (seção
      "Privacidade") cobre só a coleta de e-mail da lista de espera. O app em si acessa dados bem
      mais sensíveis (estatísticas de uso, apps instalados, evento de acessibilidade) — você
      precisa de uma política de privacidade específica do app, hospedada publicamente, cobrindo
      exatamente o que é coletado e por quê.
- [ ] **Formulário de permissões sensíveis do Google Play (Sensitive Apps permissions
      declaration)**: apps que usam `PACKAGE_USAGE_STATS`, `SYSTEM_ALERT_WINDOW` e, principalmente,
      **serviço de acessibilidade** passam por revisão manual da Google. No Play Console, em
      "Políticas > Declarações de apps", você precisa justificar o uso do serviço de acessibilidade
      (o caso de uso "bloqueio de apps para foco/bem-estar digital" é aceito, mas precisa de vídeo
      demonstrativo e justificativa por escrito — apps rejeitados nessa etapa são o motivo mais
      comum de app de bloqueio de distração ser barrado na Play Store).
- [ ] Revisar `applicationId`, ícone final do app (o ícone incluído neste repositório é um
      placeholder vetorial simples) e testar o fluxo de compra em modo sandbox (contas de teste de
      licença no Play Console) antes de liberar para produção.

---

## 5. ⚠️ Aviso sobre orçamento de Google Ads

> **NÃO aumentar o orçamento de Ads além de R$ 300/mês antes de ter pelo menos 60 dias de dados
> reais de conversão.** Priorize uma campanha manual de **Search por palavra-chave** em vez de
> **App Campaigns automáticas**, devido ao baixo volume de orçamento — App Campaigns precisam de
> volume e dados de conversão para o algoritmo otimizar bem, e com R$ 300/mês elas tendem a gastar
> o orçamento sem aprender direito. Uma campanha manual de Search te dá controle total sobre
> palavras-chave, permite pausar termos que não convertem, e gera dados de conversão mais
> confiáveis para decidir se vale a pena escalar depois.
