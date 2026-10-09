#!/usr/bin/env bash
# Installer Software Factory (prd-sys) ke direktori project.
#
# Cara pakai:
#   ./scripts/install.sh /path/ke/project-saya        # dari clone factory ini, atau
#   bash <(curl -fsSL https://raw.githubusercontent.com/priaculun/prd-sys/main/scripts/install.sh) /path/ke/project-saya
#
# Sifat: idempotent (aman dijalankan ulang), tidak pernah menimpa
# PRD.md / tasks/ / tickets/ / PROGRESS.md milik project.
set -euo pipefail

FACTORY_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

usage() {
  echo "Pakai: $0 <direktori-project>"
  echo "Contoh: $0 ~/Projects/todo-app"
  exit 1
}

[[ $# -eq 1 ]] || usage
TARGET="$1"

# --- Guard: jangan install ke dalam factory sendiri ---
if [[ -f "$TARGET/.factory-system" || "$TARGET" == "$FACTORY_DIR"* && "$TARGET" != "$FACTORY_DIR" && -f "$FACTORY_DIR/.factory-system" ]]; then
  # Sederhanakan: tolak kalau target mengandung marker factory
  if [[ -f "$TARGET/.factory-system" ]]; then
    echo "ERROR: '$TARGET' adalah FACTORY (ada .factory-system), bukan project." >&2
    echo "Install ke direktori project yang BERBEDA, misal: $0 ~/Projects/nama-project" >&2
    exit 1
  fi
fi
if [[ "$TARGET" == "$FACTORY_DIR" ]]; then
  echo "ERROR: target adalah factory itu sendiri. Pilih direktori project lain." >&2
  exit 1
fi

# --- Mode remote: script dijalankan via curl tanpa clone ---
if [[ ! -f "$FACTORY_DIR/AGENTS.md" ]]; then
  echo "ERROR: file factory tidak ditemukan di $FACTORY_DIR." >&2
  echo "Clone dulu: git clone https://github.com/priaculun/prd-sys.git" >&2
  exit 1
fi

mkdir -p "$TARGET"

copy_if_missing() { # src dst
  if [[ -e "$2" ]]; then
    echo "  skip (sudah ada): $2"
  else
    mkdir -p "$(dirname "$2")"
    cp -r "$1" "$2"
    echo "  copy: $2"
  fi
}

echo "Install factory → $TARGET"

# Aturan + workflow (selalu segarkan ke versi terbaru dari factory)
mkdir -p "$TARGET/docs"
cp "$FACTORY_DIR/AGENTS.md" "$TARGET/AGENTS.md"
cp "$FACTORY_DIR/docs/WORKFLOW.md" "$TARGET/docs/WORKFLOW.md"
echo "  refresh: AGENTS.md, docs/WORKFLOW.md"

# Definisi agent
mkdir -p "$TARGET/.pi/agents"
for agent in prd-writer executor reviewer; do
  cp "$FACTORY_DIR/.pi/agents/$agent.md" "$TARGET/.pi/agents/$agent.md"
  echo "  refresh: .pi/agents/$agent.md"
done

# Template (hanya tambah yang belum ada — custom project dilindungi)
mkdir -p "$TARGET/templates"
for tpl in prd-template task-template improvement-ticket-template progress-template; do
  copy_if_missing "$FACTORY_DIR/templates/$tpl.md" "$TARGET/templates/$tpl.md"
done

# Instance project (JANGAN PERNAH ditimpa — ini milik project)
mkdir -p "$TARGET/tasks" "$TARGET/tickets"
copy_if_missing "$FACTORY_DIR/templates/prd-template.md" "$TARGET/PRD.md"
copy_if_missing "$FACTORY_DIR/templates/progress-template.md" "$TARGET/PROGRESS.md"

echo ""
echo "Selesai. Langkah berikut:"
echo "  cd $TARGET"
echo "  (panggil agent prd-writer di direktori itu untuk mulai interview)"
