# tmux Cheat Sheet 📌

## 1. **Dasar-Dasar tmux**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `tmux`                       | Mulai sesi baru |
| `tmux new -s nama_sesi`      | Buat sesi baru dengan nama |
| `tmux attach -t nama_sesi`   | Hubungkan ke sesi yang ada |
| `tmux list-sessions`         | Lihat daftar sesi yang sedang berjalan |
| `tmux detach` (Ctrl + B, D)  | Lepas dari sesi aktif |
| `tmux kill-session -t nama_sesi` | Hapus sesi tertentu |
| `tmux kill-server`           | Hapus semua sesi tmux |

## 2. **Prefix Key**
📌 **tmux menggunakan prefix key** `Ctrl + B`.  
Semua perintah **harus dimulai dengan prefix ini**.

---

## 3. **Manajemen Jendela (Windows)**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `Ctrl + B, C`                 | Buat jendela baru |
| `Ctrl + B, W`                 | Daftar jendela yang tersedia |
| `Ctrl + B, N`                 | Pindah ke jendela berikutnya |
| `Ctrl + B, P`                 | Pindah ke jendela sebelumnya |
| `Ctrl + B, [0-9]`             | Pindah ke jendela tertentu |
| `Ctrl + B, &`                 | Tutup jendela aktif |
| `Ctrl + B, ,`                 | Ganti nama jendela |

---

## 4. **Manajemen Panel (Panes)**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `Ctrl + B, %`                 | Split vertikal |
| `Ctrl + B, "`                 | Split horizontal |
| `Ctrl + B, O`                 | Pindah ke pane berikutnya |
| `Ctrl + B, {`                 | Geser pane ke kiri |
| `Ctrl + B, }`                 | Geser pane ke kanan |
| `Ctrl + B, X`                 | Tutup pane aktif |
| `Ctrl + B, Space`             | Toggle layout pane |
| `Ctrl + B, Q`                 | Tampilkan nomor pane |

🔹 **Resize Pane:**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `Ctrl + B, Alt + ←`           | Kecilkan pane ke kiri |
| `Ctrl + B, Alt + →`           | Besarkan pane ke kanan |
| `Ctrl + B, Alt + ↑`           | Besarkan pane ke atas |
| `Ctrl + B, Alt + ↓`           | Besarkan pane ke bawah |

---

## 5. **Copy Mode & Scrolling**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `Ctrl + B, [`                 | Masuk ke copy mode |
| `Ctrl + B, ]`                 | Paste teks yang telah disalin |
| `Space`                       | Mulai pemilihan teks |
| `Enter`                       | Salin teks yang dipilih |
| `Arrow Keys / PgUp / PgDn`    | Navigasi dalam copy mode |

---

## 6. **Manajemen Sesi**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `tmux new -s nama_sesi`       | Buat sesi baru |
| `tmux ls`                     | Lihat daftar sesi |
| `tmux attach -t nama_sesi`    | Hubungkan ke sesi tertentu |
| `tmux switch -t nama_sesi`    | Pindah ke sesi lain |
| `tmux kill-session -t nama_sesi` | Tutup sesi tertentu |

🔹 **Pindah Antara Sesi:**
| Perintah                      | Fungsi |
|-------------------------------|--------|
| `Ctrl + B, S`                 | Lihat daftar sesi & pilih |
| `Ctrl + B, D`                 | Lepas dari sesi tanpa keluar |
| `Ctrl + B, (`                 | Pindah ke sesi sebelumnya |
| `Ctrl + B, )`                 | Pindah ke sesi berikutnya |

---

## 7. **Customizing tmux**
📌 **File Konfigurasi:**
Konfigurasi **tmux** disimpan di:
```bash
~/.tmux.conf
```