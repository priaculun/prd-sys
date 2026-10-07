# Aturan Main Software Factory

File ini adalah **konstitusi** untuk semua agent (dan manusia) yang bekerja di repo ini. Definisi detail per peran ada di `.pi/agents/`. Alur lengkap ada di `docs/WORKFLOW.md`.

## Hierarki Kebenaran

1. **PRD.md** — satu-satunya sumber requirement. Tidak tertulis = tidak ada.
2. **tasks/NNN-\*.md** — kontrak eksekusi per unit kerja.
3. **AGENTS.md + docs/WORKFLOW.md** — aturan proses.
4. Dokumen lain (README, komentar kode) — referensi sekunder, TIDAK boleh menimpa PRD.

## 5 Hukum Tertinggi

1. **PR untuk segalanya.** Tidak ada commit langsung ke `main`. Satu task = satu branch `task/NNN-*` = satu PR.
2. **PRD dulu, kode kemudian.** Tidak ada task tanpa PRD berstatus `Approved`. Tidak ada kode tanpa task.
3. **Selesai = AC terbukti.** Acceptance criteria dicek dengan bukti (test exit 0, output nyata), bukan klaim.
4. **Gagal ≠ berhenti.** Wajib menempuh Recovery Protocol level 1-5 sebelum boleh menyerah ke owner — dan itupun dengan dokumentasi lengkap (lihat `docs/WORKFLOW.md`).
5. **Zero halusinasi.** Dilarang menambah fitur, refactor, atau "improvement" yang tidak diminta AC. Ide dicatat ke `tickets/IMP-NNN.md`, dieksekusi hanya setelah owner approve.

## Peran

| Peran | File | Tugas | Boleh menulis kode? |
|---|---|---|---|
| prd-writer | `.pi/agents/prd-writer.md` | Interview → PRD → task list | Tidak (hanya dokumen) |
| executor | `.pi/agents/executor.md` | Kerjakan 1 task → PR | Ya, di branch task |
| reviewer | `.pi/agents/reviewer.md` | Nilai PR vs kontrak | Tidak |
| owner (manusia) | — | Approve PRD, putuskan blocked, review tiket | Terserah |

## Status Task

`todo` → `in-progress` → `in-review` → `done`
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;↘ `blocked` (hanya lewat Recovery Protocol level 5) ↗

## Status PRD

`Draft` → `In Review` → `Approved` (task boleh dibuat) → perubahan hanya via Change Request (§7 PRD).
