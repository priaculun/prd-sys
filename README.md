# prd-sys — Software Factory (PRD-first)

Repo ini adalah **FACTORY**: mesin pembuat software yang bekerja dengan pola
**interview → PRD → task → PR → review**. Repo ini **BUKAN** tempat mengerjakan project.

## Sistem vs Project — bedanya

| | FACTORY (repo ini) | PROJECT (hasil instalasi) |
|---|---|---|
| Isi | Aturan, template, definisi agent, installer | PRD, task, progress, kode project |
| Sifat | Read-only untuk agent | Tempat agent bekerja |
| Contoh file | `AGENTS.md`, `templates/`, `.pi/agents/`, `scripts/` | `PRD.md`, `tasks/`, `tickets/`, `PROGRESS.md` |
| Cara bedakan | Ada file `.factory-system` | Tidak ada file `.factory-system` |

## Cara memakai untuk project baru

```bash
# 1. Install mesin ke direktori project (baru atau existing)
./scripts/install.sh /path/ke/project-saya

# 2. Pindah ke project, panggil agent dari sana
cd /path/ke/project-saya
# → "mulai interview" (agent: prd-writer)
```

Semua kerja (PRD, task, PR, review) terjadi **di project**, tidak pernah di sini.

## Isi factory

- `AGENTS.md` — konstitusi untuk semua agent (berlaku juga di project hasil instalasi)
- `docs/WORKFLOW.md` — alur lengkap 5 fase + recovery protocol + batas sistem vs project
- `templates/` — template PRD, task, improvement ticket, progress
- `.pi/agents/` — definisi 3 agent: `prd-writer`, `executor`, `reviewer`
- `scripts/install.sh` — installer mesin ke project apapun

## Mengubah factory ini sendiri

Factory boleh di-improve (ini template hidup), tapi hanya owner + via PR:

1. Buat branch dari `main`, ubah sistem, kirim PR.
2. **PR sistem direview owner langsung (manusia)** — agent `reviewer` tidak berwenang menilai PR sistem.
3. Setelah merge, project yang sudah ter-install bisa `git pull` pola terbaru atau install ulang file sistem (installer tidak menimpa `PRD.md`/`tasks/`/`tickets/`/`PROGRESS.md` project).

## Aturan untuk agent yang membaca repo ini

Kalau kamu adalah agent dan menemukan file `.factory-system` di root:
**BERHENTI.** Jangan menulis PRD/tasks/progress di sini. Beri tahu owner
untuk menjalankan installer ke direktori project dulu.
