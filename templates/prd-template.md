# PRD — <Nama Project>

> **Status:** Draft | In Review | Approved | Locked
> **Versi:** 1.0
> **Tanggal:** <YYYY-MM-DD>
> **Owner:** <nama kamu>

<!--
ATURAN PAKAI TEMPLATE INI:
- Isi SEMUA bagian. Kalau tidak relevan, tulis "Tidak ada" + alasannya.
  Bagian kosong = sumber halusinasi agent.
- PRD ini adalah SATU-SATUNYA sumber kebenaran. Agent dilarang mengambil
  requirement dari tempat lain.
- Perubahan setelah Approved HARUS lewat Change Request (lihat §7).
- Angka Requirement Level menentukan seberapa ketat agent boleh menafsirkan.
-->

---

## 1. Visi & Tujuan

**Masalah yang diselesaikan:**
<1-3 kalimat. Masalah konkret, bukan fitur.>

**Tujuan akhir (Definition of Done keseluruhan):**
<Kondisi terukur yang membuat project ini dianggap 100% selesai.
Contoh: "User bisa daftar, login, buat invoice, dan menerima PDF — terbukti lolos semua test di tasks/">

**Bukan tujuan (Out of Scope):**
<Sebutkan eksplisit apa yang TIDAK akan dibangun. Ini pagar anti scope-creep.>

---

## 2. Requirement Level (Fleksibilitas)

Project ini memakai mode: **HYBRID**

| Area | Level | Artinya |
|---|---|---|
| <misal: alur checkout> | STRICT | Wajib persis seperti PRD, tanpa deviasi |
| <misal: styling UI> | FLEXIBLE | Agent boleh memilih implementasi selama AC terpenuhi |
| <default untuk yang tidak tertulis> | FLEXIBLE | — |

> **STRICT** = deviasi = PR ditolak. **FLEXIBLE** = agent bebas memilih cara, tapi TIDAK boleh menambah fitur di luar AC.

---

## 3. Sub-Menu & Fitur

### 3.1 <Nama Sub-Menu>

**Tujuan sub-menu:** <kenapa ini ada>

#### Fitur 3.1.1 — <Nama Fitur>
- **Deskripsi:** <apa yang dilakukan, dari sudut pandang user>
- **Acceptance Criteria:**
  - [ ] <kriteria terukur 1 — bisa ditest>
  - [ ] <kriteria terukur 2>
- **Edge cases yang WAJIB ditangani:**
  - <contoh: input kosong, koneksi putus, duplikat data>
- **Requirement Level:** STRICT | FLEXIBLE

#### Fitur 3.1.2 — <Nama Fitur>
...

### 3.2 <Nama Sub-Menu>
...

---

## 4. Keputusan Teknis (Sudah Diputuskan — Bukan untuk Diperdebatkan)

| Keputusan | Pilihan | Alasan |
|---|---|---|
| Stack | <misal: Next.js + SQLite> | <singkat> |
| Struktur folder | <misal: feature-based> | |
| Testing | <misal: vitest, wajib lolos tiap PR> | |
| CI | <misal: GitHub Actions> | |

> Agent DILARANG mengganti keputusan di tabel ini. Kalau menurut agent ada yang
> lebih baik → catat sebagai Improvement Ticket, jangan diimplementasikan.

---

## 5. Batasan & Non-Negotiable

- <misal: tidak ada dependency berbayar>
- <misal: semua teks UI bahasa Indonesia>
- <misal: tidak ada kode yang tidak ditest>

---

## 6. Metrik Keberhasilan

| Metrik | Target | Cara ukur |
|---|---|---|
| Seluruh task selesai | 100% | PROGRESS.md semua ✅ |
| Test | 100% pass di main | CI hijau |
| <metrik produk> | | |

---

## 7. Change Log (PRD Hidup)

> PRD ini BOLEH berubah (hybrid, adaptif) — tapi hanya lewat jalur resmi:
> Change Request → ditulis di sini → task list di-regenerasi bila perlu.

| Versi | Tanggal | Perubahan | Disetujui oleh | Dampak ke task |
|---|---|---|---|---|
| 1.0 | | Initial | Owner | tasks/ dibuat |
