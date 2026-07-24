#!/usr/bin/env python3
"""
Cria automaticamente as Tags e os Custom Fields do sistema de relacionamento
WhatsApp da Vino Bianco Store na conta ManyChat.

IMPORTANTE:
- Rode este script no SEU computador (ou qualquer máquina com acesso livre à
  internet) — não dentro de um ambiente sandbox restrito. Ele não funciona
  em ambientes que bloqueiam saída para api.manychat.com.
- Antes de rodar, confirme os endpoints contra o Swagger do ManyChat
  (link disponível em Settings -> API na sua conta), pois a API pode ter
  mudanças desde a escrita deste script.
- Nunca coloque a API key direto no código. Use a variável de ambiente
  MANYCHAT_API_KEY.
- Rode primeiro com --dry-run para conferir o que seria criado, sem
  chamar a API de verdade.

Uso:
    export MANYCHAT_API_KEY="sua_chave_aqui"
    python3 manychat_setup.py --dry-run   # só mostra o que faria
    python3 manychat_setup.py             # cria de verdade
"""

import argparse
import os
import sys
import time
import urllib.request
import urllib.error
import json

API_BASE = "https://api.manychat.com"

TAGS = [
    "Cliente Novo",
    "Cliente VIP",
    "Comprou Espumante",
    "Comprou Branco",
    "Comprou Rosé",
    "Comprou Tinto",
    "Cliente Frequente",
    "Interesse Bordeaux",
    "Interesse Itália",
    "Interesse Portugal",
    "Interesse Espumantes",
    "Interesse Promoções",
    "Não responde há 30 dias",
    "Reengajado",
]

# type: "text" | "number" | "date" | "datetime" | "boolean"
CUSTOM_FIELDS = [
    ("nome", "text"),
    ("ultimo_vinho_comprado", "text"),
    ("data_ultima_compra", "date"),
    ("cidade", "text"),
    ("estado", "text"),
    ("tipo_favorito", "text"),
    ("faixa_de_preco", "text"),
    ("data_aniversario", "date"),
    ("sommelier_responsavel", "text"),
    ("ticket_medio", "number"),
    ("ultimo_fluxo_sexta", "text"),
    ("contador_semanas_sem_clique", "number"),
]


def call_api(api_key: str, path: str, payload: dict, dry_run: bool):
    url = f"{API_BASE}{path}"
    if dry_run:
        print(f"[DRY-RUN] POST {url}  body={json.dumps(payload, ensure_ascii=False)}")
        return {"status": "dry-run"}

    data = json.dumps(payload).encode("utf-8")
    req = urllib.request.Request(
        url,
        data=data,
        method="POST",
        headers={
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
        },
    )
    try:
        with urllib.request.urlopen(req, timeout=20) as resp:
            body = resp.read().decode("utf-8")
            return json.loads(body) if body else {}
    except urllib.error.HTTPError as e:
        body = e.read().decode("utf-8", errors="replace")
        print(f"  -> ERRO HTTP {e.code} em {path}: {body}", file=sys.stderr)
        return None
    except urllib.error.URLError as e:
        print(f"  -> ERRO DE CONEXÃO em {path}: {e}", file=sys.stderr)
        return None


def create_tags(api_key: str, dry_run: bool):
    print("\n== Criando Tags ==")
    for tag_name in TAGS:
        print(f"Tag: {tag_name}")
        result = call_api(api_key, "/fb/page/createTag", {"name": tag_name}, dry_run)
        if result is None:
            print(f"  -> falhou (pode já existir — confira manualmente)")
        else:
            print(f"  -> ok")
        time.sleep(0.3)  # evita rate limit


def create_custom_fields(api_key: str, dry_run: bool):
    print("\n== Criando Custom Fields ==")
    for field_name, field_type in CUSTOM_FIELDS:
        print(f"Campo: {field_name} ({field_type})")
        result = call_api(
            api_key,
            "/fb/page/createCustomField",
            {"caption": field_name, "type": field_type},
            dry_run,
        )
        if result is None:
            print(f"  -> falhou (pode já existir — confira manualmente)")
        else:
            print(f"  -> ok")
        time.sleep(0.3)


def main():
    parser = argparse.ArgumentParser(description="Setup inicial de Tags e Custom Fields no ManyChat")
    parser.add_argument("--dry-run", action="store_true", help="Só mostra o que seria feito, sem chamar a API")
    args = parser.parse_args()

    api_key = os.environ.get("MANYCHAT_API_KEY")
    if not api_key and not args.dry_run:
        print("ERRO: defina a variável de ambiente MANYCHAT_API_KEY antes de rodar sem --dry-run.", file=sys.stderr)
        sys.exit(1)

    if args.dry_run:
        print("Modo DRY-RUN: nenhuma chamada real será feita.")

    create_tags(api_key or "DRY-RUN-KEY", args.dry_run)
    create_custom_fields(api_key or "DRY-RUN-KEY", args.dry_run)

    print("\nConcluído. Confira em ManyChat -> Settings -> Tags / Custom Fields se tudo foi criado corretamente.")


if __name__ == "__main__":
    main()
