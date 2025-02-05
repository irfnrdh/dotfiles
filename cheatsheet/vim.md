# Vim Cheat Sheet untuk Professional

## 1. Mode Dasar
| Perintah           | Fungsi |
|--------------------|--------|
| `Esc`             | Kembali ke Normal Mode |
| `i`               | Insert Mode (sebelum kursor) |
| `I`               | Insert Mode (awal baris) |
| `a`               | Insert Mode (setelah kursor) |
| `A`               | Insert Mode (akhir baris) |
| `o`               | Tambah baris baru di bawah |
| `O`               | Tambah baris baru di atas |
| `v`               | Visual Mode (pilih teks) |
| `V`               | Visual Line Mode |
| `Ctrl + v`        | Visual Block Mode |
| `R`               | Replace Mode |
| `:`               | Command Mode |

## 2. Navigasi
| Perintah          | Fungsi |
|-------------------|--------|
| `h`              | Kiri |
| `l`              | Kanan |
| `j`              | Bawah |
| `k`              | Atas |
| `0`              | Awal baris |
| `^`              | Awal teks non-spasi |
| `$`              | Akhir baris |
| `gg`             | Awal file |
| `G`              | Akhir file |
| `5G`             | Lompat ke baris 5 |
| `Ctrl + d`       | Scroll setengah halaman ke bawah |
| `Ctrl + u`       | Scroll setengah halaman ke atas |
| `Ctrl + f`       | Scroll satu halaman ke bawah |
| `Ctrl + b`       | Scroll satu halaman ke atas |
| `H`              | Pindah ke baris atas layar |
| `M`              | Pindah ke baris tengah layar |
| `L`              | Pindah ke baris bawah layar |
| `fx`             | Lompat ke karakter `x` dalam baris |
| `tx`             | Lompat sebelum karakter `x` dalam baris |
| `%`              | Lompat ke pasangan tanda kurung `{}`, `[]`, `()` |

## 3. Editing
| Perintah         | Fungsi |
|------------------|--------|
| `x`             | Hapus karakter di bawah kursor |
| `X`             | Hapus karakter sebelum kursor |
| `r<char>`       | Ganti karakter di bawah kursor |
| `dd`            | Hapus satu baris |
| `dw`            | Hapus satu kata |
| `D`             | Hapus dari kursor ke akhir baris |
| `C`             | Hapus dari kursor ke akhir baris & masuk Insert Mode |
| `J`             | Gabungkan baris berikutnya |
| `u`             | Undo |
| `Ctrl + r`      | Redo |
| `.`             | Ulangi aksi terakhir |
| `ciw`           | Hapus isi kata di bawah kursor & masuk Insert Mode |
| `diw`           | Hapus kata di bawah kursor tanpa masuk Insert Mode |
| `yaw`           | Copy satu kata |
| `ci"`           | Hapus isi dalam tanda kutip & masuk Insert Mode |
| `di(`           | Hapus isi dalam tanda kurung |
| `yi{`           | Copy isi dalam `{}` |
| `>>`            | Indentasi satu baris ke kanan |
| `<<`            | Indentasi satu baris ke kiri |

## 4. Copy, Cut, Paste
| Perintah        | Fungsi |
|-----------------|--------|
| `yy`           | Copy satu baris |
| `Y`            | Copy satu baris (sama seperti `yy`) |
| `yw`           | Copy satu kata |
| `p`            | Paste setelah kursor |
| `P`            | Paste sebelum kursor |
| `"*p`          | Paste dari clipboard sistem (Linux dengan `xclip`) |

## 5. Multi-Barisan & Blok
| Perintah        | Fungsi |
|-----------------|--------|
| `V`            | Pilih satu baris penuh |
| `Ctrl + v`     | Pilih dalam mode blok (column select) |
| `y`            | Copy blok yang dipilih |
| `d`            | Hapus blok yang dipilih |
| `>`            | Indentasi blok ke kanan |
| `<`            | Indentasi blok ke kiri |

## 6. Pencarian & Penggantian
| Perintah        | Fungsi |
|-----------------|--------|
| `/kata`        | Cari "kata" ke bawah |
| `?kata`        | Cari "kata" ke atas |
| `n`            | Lompat ke hasil berikutnya |
| `N`            | Lompat ke hasil sebelumnya |
| `:%s/old/new/g` | Ganti semua "old" jadi "new" |
| `:%s/old/new/gc` | Ganti semua "old" dengan konfirmasi |
| `:10,20s/old/new/g` | Ganti dari baris 10 sampai 20 |

## 7. Split Windows
| Perintah         | Fungsi |
|------------------|--------|
| `:split`        | Split horizontal |
| `:vsplit`       | Split vertikal |
| `Ctrl + w + w`  | Pindah antar split |
| `Ctrl + w + h`  | Pindah ke split kiri |
| `Ctrl + w + j`  | Pindah ke split bawah |
| `Ctrl + w + k`  | Pindah ke split atas |
| `Ctrl + w + l`  | Pindah ke split kanan |

## 8. Tabs
| Perintah        | Fungsi |
|-----------------|--------|
| `:tabnew`      | Buat tab baru |
| `:tabn`        | Pindah ke tab berikutnya |
| `:tabp`        | Pindah ke tab sebelumnya |
| `:tabclose`    | Tutup tab aktif |

## 9. Macro (Rekam & Jalankan Ulang)
| Perintah        | Fungsi |
|-----------------|--------|
| `q<register>`  | Rekam ke register (contoh: `qa`) |
| `<commands>`   | Lakukan serangkaian perintah |
| `q`            | Stop recording |
| `@<register>`  | Jalankan macro (contoh: `@a`) |
| `@@`           | Jalankan ulang macro terakhir |

## 10. Mode EX (Command Mode)
| Perintah        | Fungsi |
|-----------------|--------|
| `:w`           | Simpan file |
| `:q`           | Keluar |
| `:q!`          | Keluar tanpa menyimpan |
| `:wq`          | Simpan & keluar |
| `ZZ`           | Simpan & keluar (shortcut `:wq`) |

## 11. Buffer Management
| Perintah        | Fungsi |
|-----------------|--------|
| `:ls`          | Tampilkan daftar buffer |
| `:buffer <num>` | Pindah ke buffer tertentu |
| `:bnext`       | Pindah ke buffer berikutnya |
| `:bprevious`   | Pindah ke buffer sebelumnya |
| `:bd`          | Tutup buffer saat ini |

## 12. Trik Profesional
- Gunakan `.` untuk mengulang aksi terakhir dengan cepat.
- Gunakan `:w !sudo tee %` untuk menyimpan file dengan sudo.
- Gunakan `gf` untuk membuka file berdasarkan path di bawah kursor.

---

**"If you master Vim, you master the terminal!"** 🚀
