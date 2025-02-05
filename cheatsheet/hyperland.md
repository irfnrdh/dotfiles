# Hyperland Cheat Sheet 🚀

## 1. **Dasar-Dasar Navigasi**
| Perintah                    | Fungsi |
|-----------------------------|--------|
| `Mod + Return`              | Buka terminal |
| `Mod + Q`                   | Tutup jendela aktif |
| `Mod + E`                   | Restart Hyperland |
| `Mod + Shift + E`           | Logout dari Hyperland |
| `Mod + D`                   | Buka launcher (misalnya `wofi` atau `fuzzel`) |
| `Mod + T`                   | Toggle terminal floating |

## 2. **Navigasi Jendela**
| Perintah                    | Fungsi |
|-----------------------------|--------|
| `Mod + H`                   | Pindah ke jendela kiri |
| `Mod + J`                   | Pindah ke jendela bawah |
| `Mod + K`                   | Pindah ke jendela atas |
| `Mod + L`                   | Pindah ke jendela kanan |
| `Mod + Shift + H`           | Geser jendela ke kiri |
| `Mod + Shift + J`           | Geser jendela ke bawah |
| `Mod + Shift + K`           | Geser jendela ke atas |
| `Mod + Shift + L`           | Geser jendela ke kanan |

## 3. **Layout dan Floating Mode**
| Perintah                    | Fungsi |
|-----------------------------|--------|
| `Mod + Space`               | Toggle floating untuk jendela aktif |
| `Mod + F`                   | Fullscreen toggle |
| `Mod + W`                   | Mode tabbed |
| `Mod + S`                   | Mode stacked |
| `Mod + V`                   | Mode split vertikal |
| `Mod + H`                   | Mode split horizontal |

## 4. **Workspace & Multi-Monitor**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + [1-9]`                | Pindah ke workspace tertentu |
| `Mod + Shift + [1-9]`        | Pindahkan jendela ke workspace tertentu |
| `Mod + Ctrl + [1-9]`         | Pindah ke workspace di monitor lain |
| `Mod + Shift + Ctrl + [1-9]` | Pindahkan jendela ke workspace di monitor lain |

## 5. **Resize Jendela**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + R`                    | Masuk ke mode resize |
| `H / J / K / L`              | Resize ke kiri/bawah/atas/kanan |
| `Esc / Enter`                | Keluar dari mode resize |

## 6. **Screenshot & Screen Recording**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Print`                      | Screenshot layar penuh |
| `Mod + Print`                | Screenshot area tertentu |
| `Mod + Shift + Print`        | Screenshot jendela aktif |
| `Mod + Shift + R`            | Mulai/menghentikan screen recording |

## 7. **Menjalankan Program**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + D`                    | Buka launcher (`wofi`, `fuzzel`, dll.) |
| `Mod + Shift + D`            | Jalankan aplikasi dari launcher |

## 8. **Lock, Logout, Reboot, Shutdown**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + Shift + E`            | Logout Hyperland |
| `Mod + L`                    | Kunci layar (`swaylock`, `hyprlock`, dll.) |
| `Mod + Shift + P`            | Matikan komputer |
| `Mod + Shift + R`            | Restart komputer |

## 9. **Scratchpad Mode**
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + Shift + Minus`        | Kirim jendela ke scratchpad |
| `Mod + Minus`                | Panggil kembali jendela dari scratchpad |

## 10. **Konfigurasi Dasar**
Konfigurasi Hyperland berada di:
`~/.config/hypr/hyprland.conf`

### **Contoh Custom Keybinding**
Tambahkan ke `hyprland.conf`:
```bash
bind=SUPER,F2,exec,firefox
bind=SUPER,Shift,Q,killactive
bind=SUPER,Shift,E,exit
bind=SUPER,Space,togglefloating
```

Agar perubahan diterapkan tanpa restart: `Mod + E`

## 11. **Konfigurasi Dasar**

Mod + Shift + P	Matikan komputer
Mod + Shift + R	Restart komputer
Mod + G	Mode grid layout dengan script eksternal
Mod + N	Toggle bar i3blocks/i3status