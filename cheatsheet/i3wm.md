# i3 Window Manager Cheat Sheet

## 1. Dasar-Dasar i3
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + Enter`                | Buka terminal baru |
| `Mod + d`                    | Buka dmenu (launcher) |
| `Mod + Shift + q`            | Tutup jendela aktif |
| `Mod + Shift + e`            | Keluar dari i3 |
| `Mod + Shift + r`            | Restart i3 |
| `Mod + Shift + c`            | Reload konfigurasi i3 |

## 2. Navigasi Jendela
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + h`                    | Pindah ke jendela kiri |
| `Mod + j`                    | Pindah ke jendela bawah |
| `Mod + k`                    | Pindah ke jendela atas |
| `Mod + l`                    | Pindah ke jendela kanan |
| `Mod + Shift + h`            | Geser jendela ke kiri |
| `Mod + Shift + j`            | Geser jendela ke bawah |
| `Mod + Shift + k`            | Geser jendela ke atas |
| `Mod + Shift + l`            | Geser jendela ke kanan |

## 3. Modus Tiling & Floating
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + w`                    | Mode tabbed |
| `Mod + e`                    | Mode stacked |
| `Mod + s`                    | Mode split horizontal |
| `Mod + v`                    | Mode split vertikal |
| `Mod + f`                    | Mode fullscreen |
| `Mod + Shift + space`        | Mode floating untuk jendela aktif |
| `Mod + klik tahan`           | Pindahkan jendela floating |

## 4. Workspace & Multi-monitor
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + [1-9]`                | Pindah ke workspace tertentu |
| `Mod + Shift + [1-9]`        | Pindahkan jendela ke workspace tertentu |
| `Mod + Ctrl + [1-9]`         | Pindah ke workspace di monitor lain |
| `Mod + Shift + Ctrl + [1-9]` | Pindahkan jendela ke workspace di monitor lain |

## 5. Resize Jendela
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + r`                    | Masuk ke mode resize |
| `h / j / k / l`              | Resize ke kiri/bawah/atas/kanan |
| `Esc / Enter`                | Keluar dari mode resize |

## 6. Bar & Status
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + Shift + b`            | Toggle i3bar |
| `Mod + Shift + d`            | Restart i3status |

## 7. Menjalankan Program & Screenshot
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + d`                    | Buka dmenu (launcher) |
| `Mod + Shift + d`            | Jalankan aplikasi melalui dmenu |
| `Mod + Print`                | Ambil screenshot seluruh layar |
| `Mod + Shift + Print`        | Ambil screenshot area tertentu |

## 8. Lock, Logout, Reboot, Shutdown
| Perintah                     | Fungsi |
|------------------------------|--------|
| `Mod + Shift + e`            | Logout dari i3 |
| `i3lock`                     | Kunci layar (i3lock perlu diinstal) |
| `Mod + Shift + p`            | Matikan komputer |
| `Mod + Shift + r`            | Restart komputer |

## 9. Autostart Program
Tambahkan program ke file konfigurasi `~/.config/i3/config`:
```bash
exec --no-startup-id program-name
```

