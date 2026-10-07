# 🧮 Calculator for Kids (Kalkulator Anak)

Aplikasi kalkulator edukatif berbasis **Flutter** untuk membantu anak (dan pelajar) belajar matematika dengan cara yang menyenangkan. Aplikasi ini menggabungkan **kalkulator bertingkat** (Anak → Umum → Tingkat Lanjut) dengan **materi rumus** yang dijelaskan per topik, dalam Bahasa Indonesia.

> Package: `calculator_kids` · Application ID: `com.joyleap.calculator_kids` · Versi: `1.0.0+1`

---

## ✨ Fitur Utama

### 1. Mode Kalkulator
Pilih level sesuai kebutuhan:

| Level | Deskripsi |
|---|---|
| **Anak** | Operasi dasar `+ − × ÷` dan tanda kurung, dengan validasi input ramah anak (mis. mencegah `3++`) dan pesan error berbahasa Indonesia yang bersahabat. |
| **Umum** | Kalkulator ilmiah: `+ − × ÷`, `%`, pangkat `^`, akar `√`, `sin` `cos` `tan` (mode **DEG/RAD**), `log`, `ln`, konstanta `π` dan `e`, plus **riwayat perhitungan** (history). |
| **Tingkat Lanjut** | Kumpulan kalkulator khusus (diakses lewat ikon *tune* di layar Umum), lihat tabel di bawah. |

**Kalkulator Tingkat Lanjut:**

| Kalkulator | Keterangan |
|---|---|
| Pecahan | Operasi pecahan |
| Pangkat | Perhitungan base & eksponen |
| Konversi Persen | Konversi pecahan/desimal/persen |
| Trigonometri | Pilih Sin / Cos / Tan, lalu isi argumen sebagai ekspresi |
| Logaritma | 3 tab: `log` (basis 10), `ln` (basis e), dan `logₓ` (basis kustom) |
| Akar Kuadrat | 2 tab: `√` dan akar ke-n (`ⁿ√`) |
| Deg/Rad | Konversi derajat ↔ radian |

### 2. Mode Rumus
Materi rumus dikelompokkan dalam 3 tingkat:

- **Operasi Dasar**: Penjumlahan, Pengurangan, Perkalian, Pembagian, Tanda Kurung, Bangun Datar
- **Matematika Menengah**: Pecahan, Pangkat, Konversi Persen, Peluang, Aljabar, Statistika
- **Matematika Tingkat Lanjut**: Bangun Ruang, Trigonometri, Logaritma, Akar Kuadrat, Deg/Rad, Barisan & Deret

### 3. UI/UX
- Tema **Light & Dark** otomatis mengikuti sistem (`ThemeMode.system`)
- Desain **responsif** (portrait & landscape)
- Maskot kucing, ilustrasi, dan ikon kustom
- Font lokal **Gotham Rounded** (offline-ready)
- Transisi halaman bergaya Cupertino di Android, iOS, dan Windows

---

## 🛠️ Tech Stack

- **Framework:** Flutter (Dart SDK `>=3.10.0 <4.0.0`)
- **UI:** Material 3
- **Dependencies:** `cupertino_icons`, `google_fonts`
- **Dev dependencies:** `flutter_test`, `flutter_lints`
- **Expression parser:** *custom recursive-descent parser* (tanpa package eksternal), sehingga ringan, mudah di-test, dan pesan error bisa dikustomisasi untuk anak-anak

### Grammar Parser (Kalkulator Umum)

```
expr    = term   ( ( '+' | '-' ) term   )*
term    = unary  ( ( '*' | '/' | '%' ) unary )*
unary   = '-' unary | power
power   = primary ( '^' unary )?          // right-associative: 2^3^2 = 2^9
primary = NUMBER | fn '(' expr ')' | '(' expr ')' | CONST
fn      = 'sin' | 'cos' | 'tan' | 'log' | 'ln' | '√'
CONST   = 'π' | 'e'
```

---

## 📁 Struktur Proyek

```
Calculator-for-Kids/
├── android/                     # Konfigurasi platform Android
├── assets/
│   ├── fonts/                   # Gotham Rounded
│   ├── ic_cal_advance/          # Ikon menu kalkulator & rumus
│   └── *.png                    # Maskot & ilustrasi
├── lib/
│   ├── main.dart                # Entry point, tema, dan routing
│   ├── core/theme/              # app_colors.dart, app_fonts.dart
│   ├── logic/                   # Logic kalkulator (terpisah dari UI)
│   │   ├── calculator_logic.dart            # Mode Anak
│   │   ├── calculator_umum_logic.dart       # Mode Umum (parser utama)
│   │   ├── fraction_calculator_logic.dart
│   │   ├── power_calculator_logic.dart
│   │   ├── percent_conversion_logic.dart
│   │   ├── logarithm_calculator_logic.dart
│   │   ├── square_root_calculator_logic.dart
│   │   └── trigonometry_calculator_logic.dart
│   ├── screens/                 # Seluruh halaman aplikasi
│   │   └── rumus/               # Menu & detail materi rumus
│   ├── utils/responsive.dart    # Helper layout responsif
│   └── widgets/                 # Widget reusable
├── test/                        # Unit & widget tests
├── pubspec.yaml
└── analysis_options.yaml
```

---

## 🚀 Memulai

### Prasyarat
- [Flutter SDK](https://docs.flutter.dev/get-started/install) dengan Dart `>=3.10.0`
- Android Studio / VS Code + emulator atau perangkat fisik

### Instalasi

```bash
# 1. Clone repository
git clone https://github.com/Adam-Nurwahid/Calculator-for-Kids.git
cd Calculator-for-Kids

# 2. Install dependencies
flutter pub get

# 3. Jalankan aplikasi
flutter run
```

### Build Release (Android)

```bash
flutter build apk --release        # APK
flutter build appbundle --release  # AAB (Play Store)
```

Release build mengaktifkan **R8 code shrinking** dan **resource shrinking**.

**Signing (opsional):** buat file `android/key.properties` (sudah di-*git-ignore*) berisi:

```properties
storePassword=...
keyPassword=...
keyAlias=...
storeFile=/path/ke/keystore.jks
```

Jika file ini tidak ada, release build otomatis memakai debug key, sehingga `flutter run --release` tetap bisa dijalankan.

---

## 🧪 Testing

```bash
flutter test
```

Cakupan test saat ini:

- `calculator_logic_test.dart`: logic kalkulator Anak
- `fraction_calculator_logic_test.dart`: pecahan
- `power_calculator_logic_test.dart`: pangkat
- `percent_conversion_logic_test.dart`: konversi persen
- `basic_formulas_test.dart`, `advanced_formulas_test.dart`, `geometry_formulas_test.dart`: halaman rumus
- `responsive_layout_test.dart`, `widget_test.dart`: layout & widget

---

## 🗺️ Routing

Navigasi menggunakan *named routes* di `main.dart`:

| Route | Halaman |
|---|---|
| `/` | Pilih mode (Rumus / Kalkulator) |
| `/level` | Pilih level kalkulator |
| `/kalkulator-anak` | Kalkulator Anak |
| `/kalkulator-umum` | Kalkulator Umum |
| `/kalkulator-tingkat-lanjut` | Menu kalkulator Tingkat Lanjut |
| `/kalkulator-pecahan` · `/kalkulator-pangkat` · `/konversi-persen` | Kalkulator khusus |
| `/rumus` | Menu materi rumus |
| `/rumus/...` | Detail materi per topik |

---

## 📸 Screenshots


| Pilih Mode | Kalkulator Anak | Kalkulator Umum | Rumus |
|:---:|:---:|:---:|:---:|
| _coming soon_ | _coming soon_ | _coming soon_ | _coming soon_ |

---

## 🛣️ Roadmap

- [ ] Dukungan iOS & platform lain (saat ini folder yang tersedia baru Android)
- [ ] Bahasa Inggris (localization)
- [ ] Latihan soal / kuis interaktif
- [ ] Penyimpanan riwayat secara persisten

---

## 🤝 Kontribusi

Kontribusi sangat terbuka!

1. Fork repository ini
2. Buat branch fitur: `git checkout -b fitur/nama-fitur`
3. Commit perubahan: `git commit -m "Tambah fitur ..."`
4. Push: `git push origin fitur/nama-fitur`
5. Buka Pull Request

---

## 📄 Lisensi

Belum ada file lisensi di repository ini. Tambahkan `LICENSE` (mis. MIT) sesuai kebutuhan.

---

## 👤 Author

**Adam Nurwahid**
GitHub: [@Adam-Nurwahid](https://github.com/Adam-Nurwahid)
