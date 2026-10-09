# Workflow Software Factory

Alur lengkap dari ide sampai kode ter-merge. Semua perubahan lewat PR. Semua fase punya aturan main di `AGENTS.md` dan definisi agent di `.pi/agents/`.

## Batas Sistem vs Project

JANGAN TERTUKAR — ini sumber bug paling umum:

| | FACTORY (repo ini) | PROJECT |
|---|---|---|
| Tanda | ada file `.factory-system` di root | tidak ada file itu |
| Isi | Aturan, template, agent, installer | PRD, tasks/, tickets/, PROGRESS.md, kode |
| Peran agent | TIDAK BEKERJA di sini | semua kerja project terjadi di sini |

Aturan batas:

1. **Agent tidak pernah menulis PRD/tasks/tickets/progress di dalam factory.** Kalau diminta mengerjakan project tapi posisi ada di factory → BERHENTI, beri tahu owner untuk install dulu lalu panggil dari direktori project.
2. Setiap agent (prd-writer, executor, reviewer) wajib menjalankan **Step 0 — Cek Batas** sebelum bekerja.
3. **PR yang mengubah factory (sistem) hanya direview owner manusia**, bukan reviewer agent. Reviewer agent hanya berwenang atas PR task (`task/NNN-*`).

## Diagram Alur

```
┌─────────────────────────────────────────────────────────────┐
│  FASE 1: INTERVIEW (agent: prd-writer + owner)              │
│  Owner menjawab pertanyaan → pemahaman dikonfirmasi         │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  FASE 2: PRD (agent: prd-writer)                            │
│  Output: PRD.md status "In Review" → owner approve          │
│  ⚠ GATE: tidak ada task dibuat sebelum "Approved"           │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  FASE 3: DEKOMPOSISI (agent: prd-writer)                    │
│  Output: tasks/NNN-*.md + PROGRESS.md                       │
│  Task diurutkan by dependensi, ditandai mana yang paralel   │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  FASE 4: EKSEKUSI (agent: executor, BISA MULTI-AGENT)       │
│  Per task: branch task/NNN → kerja → test gate → PR         │
│  Gagal? → Recovery Protocol level 1-5 (lihat bawah)         │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
┌─────────────────────────────────────────────────────────────┐
│  FASE 5: REVIEW (agent: reviewer)                           │
│  Cek kontrak + scope creep + jalankan test nyata            │
│  APPROVE → merge → PROGRESS.md ✅                           │
│  CHANGES/REJECT → balik ke executor (percobaan tercatat)    │
└──────────────────────────┬──────────────────────────────────┘
                           ▼
              PROGRESS.md 100% ✅ = GOAL TERCAPAI
```

## Aturan Multi-Agent (PR-based)

1. **Satu task = satu agent = satu branch = satu PR.** Tidak ada dua agent di task yang sama.
2. Agent hanya boleh `git add` file yang relevan task-nya. Konflik paralel diminimalkan dengan desain task (prd-writer menandai task yang aman paralel).
3. `main` selalu hijau: merge hanya setelah reviewer approve + CI/test pass.
4. Dependensi dihormati: task `Depends on: 003` tidak boleh dimulai sebelum PR task 003 merge.
5. Rebase sebelum review: `git fetch origin && git rebase origin/main`.

## Recovery Protocol (Anti-Gantung)

Sistem ini TIDAK BOLEH berhenti dalam keadaan gagal. Hierarki pemulihan:

| Level | Pemicu | Aksi | Siapa |
|---|---|---|---|
| 1 | Error kecil (typo, import, sintaks) | Perbaiki langsung, maks 3x | executor |
| 2 | Salah paham requirement | Baca ulang task+PRD, pendekatan baru, maks 2x | executor |
| 3 | Pengetahuan kurang | Riset docs/contoh/versi, maks 2x | executor |
| 4 | Pendekatan terlalu kompleks | Turunkan ke implementasi paling sederhana yang memenuhi AC, 1x | executor |
| 5 | Semua level habis | Catat Log Percobaan → status `blocked` → PROGRESS.md berisi penyebab + 2-3 opsi solusi → lapor owner | executor → **owner memutuskan** |

**Prinsip:** `blocked` bukan kegagalan — itu permintaan keputusan yang terdokumentasi. Yang dilarang keras: berhenti tanpa jejak, atau stuck loop mengulang pendekatan yang sama (itulah gunanya Log Percobaan).

## Improvement Ticket (Anti-Halusinasi)

Agent DILARANG mengimplementasikan improvement yang tidak diminta. Jalur resmi untuk ide:

1. Saat bekerja, agent menemukan ide/masalah di luar task.
2. Agent membuat `tickets/IMP-NNN.md` dari `templates/improvement-ticket-template.md`.
3. Agent menautkan tiket di "Catatan Executor" task-nya, lalu **melanjutkan task asli**.
4. Owner mereview tiket secara berkala (lihat PROGRESS.md bagian tiket).
5. Jika approved → prd-writer membuat Change Request di PRD §7 + task baru. Jika rejected → tiket ditutup dengan alasan.

Dengan cara ini: tidak ada ide yang hilang, tidak ada halusinasi yang masuk kode.

## Change Request (PRD Hybrid)

PRD boleh berubah kapan saja, TAPI:
- Hanya owner yang menyetujui perubahan.
- Setiap perubahan dicatat di PRD §7 dengan versi baru.
- prd-writer menilai dampak: task mana yang berubah/bertambah/dihapus, lalu update `PROGRESS.md`.
- Executor yang sedang bekerja di task terdampak diberi tahu SEBELUM task-nya direview.

## Definisi "Goal 100% Tercapai"

1. Semua task di `PROGRESS.md` berstatus ✅ (done, PR merged).
2. Test gate keseluruhan di PRD §6 hijau di `main`.
3. Semua acceptance criteria tiap fitur di PRD §3 terverifikasi.
4. Tidak ada tiket `proposed` yang belum direview owner (bukan berarti harus diimplementasikan — cukup diputuskan).

Sampai keempatnya terpenuhi, factory belum selesai — dan sistem punya kewajiban terus bergerak lewat Recovery Protocol, bukan berhenti.
