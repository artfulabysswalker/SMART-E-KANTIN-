# Software Requirement Specification (SRS)
## SMART-E-KANTIN: Sistem Manajemen Kantin Digital

---

## PENDAHULUAN

### 1. LATAR BELAKANG

Pembangunan perangkat lunak ini dilatarbelakangi oleh kebutuhan mendesak untuk memodernisasi proses bisnis layanan kantin di sekolah/institusi. Selama ini, proses pemesanan dan pembayaran makanan dilakukan secara manual atau konvensional dengan antrian panjang di kasir.

Masalah utama yang terjadi adalah:

1. **Antrian Panjang**: Proses pemesanan dan pembayaran secara fisik menyebabkan waktu tunggu yang lama, mengurangi efisiensi waktu istirahat siswa/karyawan.

2. **Ketidaksesuaian Stok Makanan**: Ketiadaan sistem manajemen stok real-time menyebabkan kesulitan dalam perencanaan jumlah makanan yang akan disediakan, mengakibatkan pemborosan atau kekurangan stok.

3. **Kesulitan Tracking Pesanan**: Pelanggan sulit melacak status pesanan mereka dari pemesanan hingga pengambilan.

4. **Pencatatan Manual yang Rentan Kesalahan**: Proses pembayaran dan pencatatan masih manual, rentan terhadap human error dan sulit untuk audit.

Aplikasi SMART-E-KANTIN (Sistem Manajemen Kantin Digital) dibangun untuk memecahkan masalah tersebut dengan menyediakan platform digital terpusat yang mengintegrasikan menu makanan, sistem pemesanan, proses pembayaran elektronik, dan manajemen inventori real-time, sehingga menjamin efisiensi operasional dan kepuasan pelanggan.

### 2. TUJUAN

Tujuan pembangunan perangkat lunak ini adalah:

1. **Tujuan Pengelola Kantin (Admin)**: Meningkatkan efisiensi pengelolaan menu, meminimalkan pemborosan makanan melalui manajemen stok real-time, meningkatkan akurasi laporan keuangan, dan mempercepat proses verifikasi pembayaran.

2. **Tujuan Developer (Pembuat Software)**: Merancang dan mengimplementasikan sistem SMART-E-KANTIN yang ternormalisasi (3NF), stabil, dan aman, yang mampu mengelola transaksi (pemesanan dan pembayaran) dengan dukungan Database Engine InnoDB dan fitur SQL Transaction.

3. **Tujuan Dokumen SRS**: Menyediakan spesifikasi kebutuhan perangkat lunak yang jelas, terstruktur, dan disepakati oleh stakeholder, yang akan menjadi dasar utama dalam fase perancangan dan implementasi.

### 3. RUANG LINGKUP

Ruang lingkup perangkat lunak SMART-E-KANTIN ini mencakup:

- **Jenis User**: Software ini memiliki tiga jenis pengguna utama:
  - **Administrator (Admin)**: Bertanggung jawab atas manajemen menu, verifikasi pembayaran, dan manajemen stok makanan.
  - **Operator Kantin**: Mengelola pengiriman pesanan dan update status pesanan.
  - **Customer (Siswa/Karyawan)**: Melakukan pencarian menu, pemesanan, dan pembayaran makanan.

- **Arsitektur Komputer**: Sistem menggunakan arsitektur multi-tier (klien-server), di mana banyak perangkat klien (mobile dan web) terintegrasi melalui jaringan komputer, dengan Server Database diletakkan di lingkungan hosting pusat.

- **Basis Platform**: Software dibangun berbasis Mobile (aplikasi Customer) dan Web Dashboard (Admin dan Operator).

- **Keterlibatan**: Pembangunan melibatkan Developer (Tim IT), Pengelola Kantin, dan Administrator Sistem.

- **Aksesibilitas**: Software dirancang sebagai aplikasi yang dapat diakses secara online, memerlukan koneksi internet stabil untuk seluruh proses, mulai dari pencarian menu hingga konfirmasi pembayaran.

### 4. BATASAN MASALAH

Batasan masalah dari perangkat lunak SMART-E-KANTIN ini adalah:

1. Software tidak mencakup integrasi dengan sistem pembayaran pihak ketiga (misalnya Payment Gateway); pembayaran dilakukan melalui transfer bank dan dikonfirmasi secara manual oleh Admin setelah customer mengunggah bukti transfer.

2. Software hanya mengelola menu makanan utama dan tidak mencakup sistem pre-order untuk pesanan khusus yang memerlukan pemesanan jauh-jauh hari.

3. Sistem tidak melakukan perhitungan pajak atau biaya administrasi; total_harga dihitung murni dari harga menu yang tersedia.

4. Software fokus pada layanan satu kantin; sistem multi-lokasi kantin tidak termasuk dalam fase pengembangan awal ini.

### 5. NAMA SOFTWARE

Nama Software adalah: **SMART-E-KANTIN** (Sistem Manajemen Kantin Digital Terintegrasi Elektronik).

### 6. DEFINISI DAN SINGKATAN

#### Definisi

| NO | ISTILAH | DEFINISI |
|----|---------|----------|
| 1 | Software | Sistem perangkat lunak yang dibangun untuk mengelola pemesanan dan pembayaran makanan di kantin. |
| 2 | SRS | Software Requirement Specification, dokumen spesifikasi kebutuhan perangkat lunak ini. |
| 3 | Customer | Pengguna sistem (siswa/karyawan) yang menggunakan sistem untuk mencari, memesan, dan membayar makanan. |
| 4 | Admin | Pengguna sistem yang memiliki hak penuh untuk mengelola menu, verifikasi pembayaran, dan laporan. |
| 5 | Operator | Pengguna yang mengelola pengiriman pesanan dan update status pesanan. |
| 6 | Menu Makanan | Daftar makanan dan minuman yang tersedia di kantin dengan harga dan stok tertentu. |
| 7 | Pesanan | Transaksi pemesanan yang dibuat oleh customer dengan detail jumlah dan jenis menu. |
| 8 | Pembayaran | Proses verifikasi dana transfer dan konfirmasi status pembayaran oleh Admin. |

#### Singkatan

| NO | SINGKATAN | KEPANJANGAN |
|----|-----------|-------------|
| 1 | SMART-E-KANTIN | Sistem Manajemen Kantin Digital Terintegrasi Elektronik |
| 2 | SRS | Software Requirement Specification |
| 3 | DBMS | Database Management System |
| 4 | ERD | Entity Relationship Diagram |
| 5 | CRUD | Create, Read, Update, Delete |
| 6 | UI/UX | User Interface / User Experience |

### 7. REFERENSI

| NO | NAMA | JABATAN |
|----|------|---------|
| 1 | [Nama Dosen Pengampu] | Dosen Pengampu Mata Kuliah |
| 2 | [Nama Pengelola Kantin] | Manager/Pengelola Kantin |
| 3 | [Nama Administrator Sistem] | Administrator Sistem |

### 8. PENJELASAN UMUM

#### 8.1 Uraian Singkat

SMART-E-KANTIN adalah sebuah sistem manajemen pemesanan makanan yang menghubungkan antara pengelola kantin (Admin/Operator) dengan penyetir makanan (Customer) melalui platform digital terintegrasi. Customer dapat melihat menu, ketersediaan, harga, dan status pesanan secara real-time. Admin dapat mengelola menu, verifikasi pembayaran, dan membuat laporan penjualan. Alur utama sistem dimulai dari pencarian menu dan pemesanan oleh Customer di tabel pesanan, dilanjutkan dengan upload bukti pembayaran, dan diakhiri dengan verifikasi serta konfirmasi status pembayaran oleh Administrator.

#### 8.2 Fitur Software

| NO | FITUR | URAIAN |
|----|-------|--------|
| 1 | Login dan Registrasi | Semua pengguna (Admin, Operator, Customer) harus masuk ke sistem menggunakan username dan password yang terdaftar di tabel user. |
| 2 | Manajemen Menu | Admin dapat menambah, mengubah, atau menghapus data menu makanan, harga, dan stok yang tersedia. |
| 3 | Pencarian Menu | Customer dapat mencari menu berdasarkan kategori (makanan/minuman), harga, dan ketersediaan stok. |
| 4 | Proses Pemesanan | Customer dapat memilih menu, menentukan jumlah, membuat record di tabel pesanan, dan melanjutkan ke pembayaran. |
| 5 | Unggah Bukti Pembayaran | Customer dapat mengunggah bukti transfer untuk verifikasi pembayaran. |
| 6 | Verifikasi Transaksi | Admin dapat melihat bukti pembayaran dan mengubah status_pembayaran dari 'pending' menjadi 'selesai'. |
| 7 | Tracking Pesanan | Customer dapat melacak status pesanan dari pemesanan hingga pengambilan. |
| 8 | Fitur Komentar/Rating | Customer dapat memberikan ulasan atau rating terkait menu yang telah dikonsumsi. |
| 9 | Laporan Penjualan | Admin dapat melihat laporan penjualan harian, mingguan, dan bulanan. |

---

## GAMBARAN UMUM

### 1. KARAKTERISTIK PENGGUNA

- Pengguna (Admin/Operator/Customer) familiar dengan penggunaan smartphone dan aplikasi mobile pada umumnya.
- Pengguna Admin familiar dengan penggunaan dashboard berbasis web untuk manajemen bisnis.
- Pengguna Admin memahami ilmu akuntansi dasar untuk memverifikasi laporan pembayaran.
- Pengguna (Customer) memahami mekanisme transaksi perbankan (transfer dana) dan penggunaan aplikasi mobile.
- Pengguna usia minimum adalah 12 tahun (siswa SMP) hingga dewasa.

### 2. PENGGUNA

- **Super Administrator**: Admin yang memiliki hak penuh untuk mengelola sistem.
- **Operator Kantin**: Pengguna yang mengelola pengiriman pesanan dan update status.
- **Customer**: Pengguna yang melakukan pencarian menu, pemesanan, dan pembayaran.

### 3. HAK AKSES PENGGUNA

| NO | PENGGUNA SOFTWARE | STATUS | HAK AKSES |
|----|-------------------|--------|-----------|
| 1 | Admin | Super Administrator | CRUD (Melihat, menambah, mengubah, dan menghapus data) pada SEMUA tabel, termasuk verifikasi pembayaran dan laporan. |
| 2 | Operator | Operator Kantin | READ pada menu, UPDATE status pesanan, READ laporan pesanan terbaru. |
| 3 | Customer | Customer | CREATE pada pesanan dan pembayaran, READ menu publik dan status pesanan sendiri, CREATE komentar/rating. |

### 4. KETERGANTUNGAN SOFTWARE

- Software sangat tergantung pada koneksi internet yang stabil untuk seluruh proses transaksi real-time (pencarian menu, pemesanan, dan upload bukti).
- Software bergantung pada ketersediaan Database Server (Firebase Firestore/MariaDB) dengan engine InnoDB untuk menjamin integritas data transaksi.
- Software memerlukan layanan cloud storage untuk menyimpan bukti pembayaran dan gambar menu.

### 5. SPESIFIKASI PENDUKUNG SOFTWARE

- **Sistem Operasi Server**: Linux (Ubuntu/CentOS), Windows Server, atau Cloud Platform (Firebase).
- **Sistem Operasi Klien**: Android 8.0 ke atas / iOS 12 ke atas untuk aplikasi mobile.
- **Browser Web**: Google Chrome, Mozilla Firefox, Safari, atau setara untuk dashboard admin.
- **Framework**: Flutter (Mobile), laravel/Django (Backend Web Dashboard).
- **Database**: Firebase Firestore atau MariaDB dengan InnoDB Engine.
- **Minimum RAM Server**: 4 GB.
- **Minimum Storage**: 50 GB untuk database dan cloud storage.

---

## ANALISIS KEBUTUHAN

### 1. IDENTIFIKASI AKTOR

| NO | AKTOR | DESKRIPSI AKTOR |
|----|-------|-----------------|
| 1 | Administrator (Admin) | Aktor yang bertugas mengelola sistem secara keseluruhan, mengelola menu, verifikasi pembayaran, manajemen stok, dan membuat laporan penjualan. |
| 2 | Operator Kantin | Aktor yang bertugas mengupdate status pesanan, memproses pengiriman pesanan, dan melaporkan stok makanan. |
| 3 | Customer | Aktor yang menggunakan sistem untuk mencari menu, memesan, membayar, melacak pesanan, dan memberi ulasan. |

### 2. IDENTIFIKASI USE CASE

| NO | KLASIFIKASI USE CASE | USE CASE | DESKRIPSI USE CASE |
|----|----------------------|----------|-------------------|
| 1 | Sistem Otorisasi | Melakukan Login | Masuk ke dalam sistem (Admin, Operator, Customer). |
| 1.1 | Sistem Otorisasi | Melakukan Registrasi | Customer mendaftar akun baru di sistem. |
| 2 | Pengelolaan Menu | Mengelola Menu | Admin menambah, mengubah, dan menghapus data menu makanan/minuman. |
| 2.1 | Pengelolaan Menu | Manajemen Stok | Admin mengupdate stok menu yang tersedia. |
| 3 | Pencarian & Informasi | Mencari Menu | Customer mencari menu berdasarkan kategori, harga, dan ketersediaan stok. |
| 3.1 | Pencarian & Informasi | Melihat Detail Menu | Customer melihat detail lengkap menu termasuk harga, deskripsi, dan rating. |
| 3.2 | Pencarian & Informasi | Melihat Daftar Menu | Admin/Operator melihat daftar menu yang terdaftar dan stoknya. |
| 4 | Transaksi | Membuat Pesanan | Customer membuat record baru di tabel pesanan dengan detail menu, jumlah, dan total harga. |
| 4.1 | Transaksi | Unggah Bukti Bayar | Customer mengunggah file bukti transfer ke sistem. |
| 4.2 | Transaksi | Verifikasi Pembayaran | Admin mengubah status_pembayaran dari 'pending' menjadi 'selesai'. |
| 4.3 | Transaksi | Tracking Pesanan | Customer melacak status pesanan dari pemesanan hingga pengambilan. |
| 5 | Pengelolaan Data | Mengelola Data User | Admin dapat mengubah dan menghapus data pengguna (Customer/Operator). |
| 5.1 | Pengelolaan Data | Memberi Komentar/Rating | Customer mengirimkan ulasan dan rating ke sistem setelah selesai menggunakan layanan. |
| 6 | Laporan | Melihat Laporan Penjualan | Admin dapat melihat laporan penjualan harian, mingguan, dan bulanan. |

### 3. DIAGRAM USE CASE

```
┌─────────────────────────────────────────────────────────────────────┐
│                       SMART-E-KANTIN SYSTEM                         │
└─────────────────────────────────────────────────────────────────────┘

┌──────────────────────┐           ┌──────────────────────┐
│                      │           │                      │
│     ADMINISTRATOR    │           │   OPERATOR KANTIN    │
│                      │           │                      │
└──────────┬───────────┘           └──────────┬───────────┘
           │                                  │
           │                                  │
           │  ┌────────────────────────────┐  │
           │  │   Melakukan Login          │  │
           └──┤   (UC-001)                 ├──┘
              └────────────────────────────┘

           │
           │  ┌────────────────────────────┐
           │  │  Mengelola Menu            │
           └──┤  (UC-002)                  │
              └────────────────────────────┘

           │
           │  ┌────────────────────────────┐
           │  │  Manajemen Stok            │
           └──┤  (UC-002.1)                │
              └────────────────────────────┘
              
           │
           │  ┌────────────────────────────┐
           │  │  Verifikasi Pembayaran     │
           └──┤  (UC-004.2)                │
              └────────────────────────────┘

              ┌──────────────────────────────────────┐
              │                                      │
              │       ┌───────────────────┐          │
              │       │  Melihat Laporan  │          │
              │       │  Penjualan        │          │
              │       │  (UC-006)         │          │
              │       └───────────────────┘          │
              │                                      │
              └──────────────────────────────────────┘

                     Update Status Pesanan
                     (UC-004.3)

┌──────────────────────────┐
│                          │
│   CUSTOMER (SISWA/      │
│    KARYAWAN)            │
│                          │
└──────────┬───────────────┘
           │
           │  ┌────────────────────────────┐
           │  │  Melakukan Login           │
           └──┤  (UC-001)                  │
              └────────────────────────────┘
              
           │  ┌────────────────────────────┐
           │  │  Melakukan Registrasi      │
           └──┤  (UC-001.1)                │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Mencari Menu              │
           └──┤  (UC-003)                  │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Melihat Detail Menu       │
           └──┤  (UC-003.1)                │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Membuat Pesanan           │
           └──┤  (UC-004)                  │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Unggah Bukti Pembayaran   │
           └──┤  (UC-004.1)                │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Tracking Pesanan          │
           └──┤  (UC-004.4)                │
              └────────────────────────────┘

           │  ┌────────────────────────────┐
           │  │  Memberi Komentar/Rating   │
           └──┤  (UC-005.1)                │
              └────────────────────────────┘
```

---

## SPESIFIKASI KEBUTUHAN FUNGSIONAL

### 1. Requirement Fungsional UC-001: Melakukan Login

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-001 |
| **Nama Use Case** | Melakukan Login |
| **Aktor Utama** | Administrator, Operator Kantin, Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Aplikasi sudah dijalankan<br>2. User memiliki akun terdaftar di sistem |
| **Main Flow** | 1. Aktor membuka halaman login<br>2. Aktor memasukkan username dan password<br>3. Sistem memvalidasi kredensial terhadap database<br>4. Jika valid, sistem menampilkan dashboard sesuai role user<br>5. Use case berakhir |
| **Alternative Flow** | Jika kredensial tidak valid:<br>- Sistem menampilkan pesan error "Username atau password salah"<br>- Aktor dapat mencoba login kembali |
| **Postcondition** | User berhasil login dan masuk ke dashboard sesuai role |
| **Exception** | 1. Koneksi internet tidak stabil<br>2. Server database offline<br>3. Akun user terkunci karena login gagal berkali-kali |

### 2. Requirement Fungsional UC-001.1: Melakukan Registrasi

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-001.1 |
| **Nama Use Case** | Melakukan Registrasi |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Aplikasi sudah dijalankan<br>2. Customer belum memiliki akun |
| **Main Flow** | 1. Customer membuka halaman registrasi<br>2. Customer memasukkan data: username, email, password, nama lengkap, nomor telepon<br>3. Sistem memvalidasi input (email belum terdaftar, password kuat)<br>4. Sistem menyimpan data ke tabel user<br>5. Sistem menampilkan pesan sukses "Registrasi berhasil"<br>6. Use case berakhir |
| **Alternative Flow** | Jika email sudah terdaftar:<br>- Sistem menampilkan pesan "Email sudah terdaftar"<br>- Customer dapat menggunakan email lain atau login dengan akun existing |
| **Postcondition** | Customer berhasil membuat akun baru |
| **Validasi Input** | - Username: minimal 5 karakter, unik<br>- Email: format valid, unik<br>- Password: minimal 8 karakter, kombinasi huruf dan angka<br>- Nama lengkap: minimal 3 karakter<br>- Nomor telepon: format valid |

### 3. Requirement Fungsional UC-002: Mengelola Menu

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-002 |
| **Nama Use Case** | Mengelola Menu |
| **Aktor Utama** | Administrator |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Admin sudah login<br>2. Admin berada di halaman manajemen menu |
| **Main Flow** | **CREATE:**<br>1. Admin klik tombol "Tambah Menu Baru"<br>2. Admin memasukkan data: nama menu, kategori, harga, deskripsi, gambar<br>3. Admin klik tombol "Simpan"<br>4. Sistem menyimpan data ke tabel menu<br><br>**READ:**<br>1. Admin dapat melihat daftar menu dalam bentuk tabel/list<br><br>**UPDATE:**<br>1. Admin klik tombol "Edit" pada menu tertentu<br>2. Admin mengubah data menu<br>3. Admin klik tombol "Simpan"<br>4. Sistem mengupdate data di tabel menu<br><br>**DELETE:**<br>1. Admin klik tombol "Hapus" pada menu tertentu<br>2. Sistem menampilkan konfirmasi "Yakin ingin menghapus?"<br>3. Jika ya, sistem menghapus data |
| **Alternative Flow** | Jika admin membatalkan, data tidak disimpan |
| **Postcondition** | Data menu berhasil ditambah/diubah/dihapus |
| **Validasi Input** | - Nama menu: tidak boleh kosong<br>- Kategori: harus dipilih dari list<br>- Harga: angka positif, minimal Rp 1.000<br>- Deskripsi: opsional, maksimal 500 karakter<br>- Gambar: format jpg/png, ukuran max 5MB |

### 4. Requirement Fungsional UC-002.1: Manajemen Stok

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-002.1 |
| **Nama Use Case** | Manajemen Stok |
| **Aktor Utama** | Administrator, Operator Kantin |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Admin/Operator sudah login<br>2. Admin/Operator berada di halaman manajemen stok |
| **Main Flow** | 1. Admin/Operator melihat daftar menu dengan stok saat ini<br>2. Admin/Operator dapat mengubah stok dengan cara:<br>   - Menginput jumlah stok baru<br>   - Klik tombol "Update Stok"<br>3. Sistem mengupdate stok di tabel menu<br>4. Sistem mencatat history perubahan stok di tabel stok_history |
| **Alternative Flow** | Jika stok mencapai batas minimum (contoh: 5 item):<br>- Sistem menampilkan alert/warning di dashboard |
| **Postcondition** | Stok menu berhasil diupdate |
| **Business Rules** | - Stok tidak boleh negatif<br>- Perubahan stok harus tercatat di history<br>- Jika stok < stok minimum, menu ditandai "Stok Terbatas" |

### 5. Requirement Fungsional UC-003: Mencari Menu

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-003 |
| **Nama Use Case** | Mencari Menu |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Customer sudah login<br>2. Customer berada di halaman beranda/menu |
| **Main Flow** | 1. Customer dapat mencari menu dengan beberapa cara:<br>   - **Pencarian berdasarkan kategori**: Customer memilih kategori (Makanan/Minuman/Dessert)<br>   - **Pencarian berdasarkan harga**: Customer memilih range harga<br>   - **Pencarian berdasarkan text**: Customer mengetik nama menu di search bar<br>2. Sistem menampilkan hasil pencarian sesuai filter yang dipilih<br>3. Customer dapat melihat menu yang tersedia (stok > 0) |
| **Alternative Flow** | Jika tidak ada hasil pencarian:<br>- Sistem menampilkan pesan "Menu tidak ditemukan" |
| **Postcondition** | Customer melihat daftar menu sesuai kriteria pencarian |

### 6. Requirement Fungsional UC-003.1: Melihat Detail Menu

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-003.1 |
| **Nama Use Case** | Melihat Detail Menu |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Customer sudah login<br>2. Customer sudah melakukan pencarian menu (UC-003) |
| **Main Flow** | 1. Customer klik pada salah satu menu dari hasil pencarian<br>2. Sistem menampilkan detail menu:<br>   - Gambar menu<br>   - Nama menu<br>   - Kategori<br>   - Harga<br>   - Deskripsi lengkap<br>   - Rating/ulasan dari customer lain<br>   - Status stok (Tersedia/Terbatas/Habis)<br>3. Customer dapat kembali ke daftar menu atau melanjutkan ke pemesanan |
| **Postcondition** | Customer melihat detail lengkap menu |

### 7. Requirement Fungsional UC-004: Membuat Pesanan

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-004 |
| **Nama Use Case** | Membuat Pesanan |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database, Sistem Pembayaran |
| **Precondition** | 1. Customer sudah login<br>2. Customer sudah melihat detail menu<br>3. Menu yang akan dipesan memiliki stok > 0 |
| **Main Flow** | 1. Customer klik tombol "Pesan Sekarang"<br>2. Customer memasukkan jumlah menu yang diinginkan<br>3. Sistem menampilkan ringkasan pesanan (menu, jumlah, harga satuan, total harga)<br>4. Customer dapat menambah/mengurangi jumlah atau membatalkan<br>5. Customer klik tombol "Lanjutkan ke Pembayaran"<br>6. Sistem membuat record di tabel pesanan dengan status "pending_pembayaran"<br>7. Sistem menampilkan nomor pesanan (order ID)<br>8. Sistem mengurangi stok menu di tabel menu |
| **Alternative Flow** | Jika customer membatalkan:<br>- Pesanan tidak disimpan<br>- Customer kembali ke halaman menu |
| **Postcondition** | Pesanan berhasil dibuat dengan status "pending_pembayaran" |
| **Data yang disimpan** | - order_id (auto-generated)<br>- customer_id<br>- menu_id & jumlah<br>- total_harga<br>- status_pesanan: "pending_pembayaran"<br>- tanggal_pesanan: timestamp saat ini |

### 8. Requirement Fungsional UC-004.1: Unggah Bukti Pembayaran

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-004.1 |
| **Nama Use Case** | Unggah Bukti Pembayaran |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database, Cloud Storage |
| **Precondition** | 1. Customer sudah membuat pesanan (UC-004)<br>2. Customer sudah melakukan transfer ke rekening kantin<br>3. Customer memiliki bukti transfer (screenshot/foto) |
| **Main Flow** | 1. Sistem menampilkan halaman pembayaran dengan:<br>   - Nomor rekening tujuan (kantin)<br>   - Nominal yang harus ditransfer<br>   - Petunjuk pembayaran<br>2. Customer upload file bukti transfer<br>3. Sistem memvalidasi file (format jpg/png, ukuran max 5MB)<br>4. Sistem menyimpan bukti ke cloud storage<br>5. Sistem membuat record di tabel bukti_pembayaran<br>6. Sistem mengupdate status_pesanan menjadi "menunggu_verifikasi"<br>7. Sistem menampilkan pesan "Bukti pembayaran berhasil diupload. Tunggu verifikasi dari Admin" |
| **Alternative Flow** | Jika file tidak valid:<br>- Sistem menampilkan pesan error<br>- Customer dapat upload ulang |
| **Postcondition** | Bukti pembayaran berhasil diupload, pesanan menunggu verifikasi |
| **Data yang disimpan** | - bukti_id (auto-generated)<br>- order_id<br>- file_url (path di cloud storage)<br>- tanggal_upload: timestamp saat ini<br>- status_bukti: "menunggu_verifikasi" |

### 9. Requirement Fungsional UC-004.2: Verifikasi Pembayaran

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-004.2 |
| **Nama Use Case** | Verifikasi Pembayaran |
| **Aktor Utama** | Administrator |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Admin sudah login<br>2. Ada pesanan dengan bukti pembayaran yang menunggu verifikasi |
| **Main Flow** | 1. Admin masuk ke halaman "Verifikasi Pembayaran"<br>2. Admin melihat daftar pesanan yang menunggu verifikasi dengan bukti pembayaran<br>3. Admin dapat melihat detail bukti dengan klik "Lihat Bukti"<br>4. Admin melakukan verifikasi:<br>   - Cek nominal transfer sesuai dengan total_harga pesanan<br>   - Cek tanggal transfer (harus hari ini atau kemarin)<br>5. Admin klik tombol "Setujui" atau "Tolak"<br><br>**Jika Setujui:**<br>- Sistem mengupdate status_pembayaran menjadi "selesai" di tabel bukti_pembayaran<br>- Sistem mengupdate status_pesanan menjadi "pembayaran_dikonfirmasi" di tabel pesanan<br>- Sistem menampilkan pesan sukses<br><br>**Jika Tolak:**<br>- Admin memasukkan alasan penolakan<br>- Sistem mengupdate status_pembayaran menjadi "ditolak" di tabel bukti_pembayaran<br>- Sistem mengupdate status_pesanan menjadi "pending_pembayaran" (kembali)<br>- Customer mendapat notifikasi bahwa pembayaran ditolak |
| **Postcondition** | Status pembayaran dan pesanan berhasil diverifikasi |
| **Business Rules** | - Admin harus memverifikasi dalam 1x24 jam sejak upload bukti<br>- Jika pembayaran ditolak, customer dapat upload bukti lagi |

### 10. Requirement Fungsional UC-004.3: Tracking Pesanan (Tambahan)

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-004.3 |
| **Nama Use Case** | Tracking Pesanan |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Customer sudah login<br>2. Customer sudah membuat pesanan |
| **Main Flow** | 1. Customer membuka menu "Riwayat Pesanan" atau "Pesanan Saya"<br>2. Sistem menampilkan daftar pesanan customer dengan status:<br>   - pending_pembayaran<br>   - menunggu_verifikasi<br>   - pembayaran_dikonfirmasi (siap diambil)<br>   - selesai (sudah diambil)<br>   - dibatalkan<br>3. Customer dapat klik pesanan untuk melihat detail dan timeline status |
| **Postcondition** | Customer melihat tracking pesanan |

### 11. Requirement Fungsional UC-005.1: Memberi Komentar/Rating

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-005.1 |
| **Nama Use Case** | Memberi Komentar/Rating |
| **Aktor Utama** | Customer |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Customer sudah login<br>2. Customer sudah selesai mengonsumsi menu (pesanan status "selesai")<br>3. Customer belum memberikan rating untuk menu tersebut |
| **Main Flow** | 1. Customer membuka detail menu yang sudah dikonsumsi<br>2. Customer dapat memberikan:<br>   - Rating: 1-5 bintang<br>   - Komentar: teks (opsional)<br>3. Customer klik tombol "Kirim"<br>4. Sistem menyimpan data ke tabel komentar<br>5. Sistem menampilkan pesan "Rating dan komentar berhasil disimpan" |
| **Postcondition** | Rating dan komentar berhasil disimpan |
| **Business Rules** | - Satu customer hanya bisa memberi rating 1x per menu per pesanan<br>- Rating minimal 1 bintang, maksimal 5 bintang |

### 12. Requirement Fungsional UC-006: Melihat Laporan Penjualan

| Item | Deskripsi |
|------|-----------|
| **Use Case ID** | UC-006 |
| **Nama Use Case** | Melihat Laporan Penjualan |
| **Aktor Utama** | Administrator |
| **Aktor Pendukung** | Sistem Database |
| **Precondition** | 1. Admin sudah login<br>2. Admin berada di halaman laporan |
| **Main Flow** | 1. Admin dapat memilih periode laporan:<br>   - Harian (hari ini)<br>   - Mingguan (minggu ini)<br>   - Bulanan (bulan ini)<br>   - Custom (pilih tanggal awal dan akhir)<br>2. Sistem menampilkan laporan yang mencakup:<br>   - Total pesanan dalam periode<br>   - Total pendapatan<br>   - Menu terlaris<br>   - Menu dengan rating tertinggi<br>   - Tren penjualan (grafik)<br>3. Admin dapat export laporan ke format PDF/Excel |
| **Postcondition** | Admin melihat laporan penjualan dan dapat export |

---

## SPESIFIKASI KEBUTUHAN NON-FUNGSIONAL

### 1. Performance

- **Response Time**: Aplikasi harus merespons setiap aksi user dalam waktu maksimal 2 detik.
- **Throughput**: Sistem harus mampu menangani minimal 100 concurrent user.
- **Loading Speed**: Halaman utama harus load dalam waktu < 3 detik dengan koneksi 4G.
- **Database Query**: Query harus selesai dalam waktu < 1 detik.

### 2. Security

- **Authentication**: Username dan password harus dienkripsi menggunakan algoritma bcrypt atau sejenisnya.
- **Authorization**: Sistem harus menerapkan role-based access control (RBAC) yang ketat.
- **Data Encryption**: Data sensitif (nomor telepon, email) harus dienkripsi di database.
- **HTTPS**: Semua komunikasi harus menggunakan protokol HTTPS dengan sertifikat valid.
- **Input Validation**: Semua input user harus divalidasi untuk mencegah SQL injection, XSS, dan attack lainnya.
- **Session Management**: Session harus timeout setelah 30 menit tidak ada aktivitas.

### 3. Reliability

- **Availability**: Sistem harus tersedia 99.5% dalam sebulan (downtime maksimal 3.6 jam).
- **Backup**: Database harus di-backup minimal 2x sehari (setiap 12 jam).
- **Disaster Recovery**: Sistem harus dapat recover dari kegagalan dalam waktu maksimal 1 jam.
- **Error Handling**: Sistem harus menampilkan pesan error yang informatif kepada user.

### 4. Maintainability

- **Code Documentation**: Semua modul code harus memiliki dokumentasi yang lengkap.
- **Code Quality**: Code harus mengikuti standard dan best practice industry.
- **Version Control**: Semua perubahan code harus tercatat di Git dengan commit message yang jelas.
- **Testing**: Minimal 80% code coverage untuk unit test.

### 5. Scalability

- **Horizontal Scaling**: Aplikasi backend harus dapat di-scale secara horizontal (menambah server).
- **Database Scaling**: Database harus mendukung replication dan sharding jika diperlukan di masa depan.
- **API Rate Limiting**: API harus menerapkan rate limiting untuk mencegah abuse.

### 6. Usability

- **User Interface**: Interface harus intuitif dan mudah digunakan oleh user dengan minimal tech knowledge.
- **Mobile Responsive**: Aplikasi mobile harus responsive dan bekerja baik di berbagai ukuran layar.
- **Accessibility**: Aplikasi harus mendukung aksesibilitas dasar (dark mode, font scalable).
- **Language**: Aplikasi harus menggunakan Bahasa Indonesia untuk user Indonesia.

### 7. Compatibility

- **Browser Support**: Dashboard web harus kompatibel dengan browser modern (Chrome, Firefox, Safari, Edge).
- **Mobile Support**: Aplikasi mobile harus kompatibel dengan Android 8.0+ dan iOS 12.0+.
- **API Version**: API harus backward compatible minimal 2 versi sebelumnya.

---

## ENTITY RELATIONSHIP DIAGRAM (ERD)

### Entitas dan Atribut

#### Tabel: user
```
user (
  user_id: INT PRIMARY KEY AUTO_INCREMENT,
  username: VARCHAR(50) UNIQUE NOT NULL,
  email: VARCHAR(100) UNIQUE NOT NULL,
  password_hash: VARCHAR(255) NOT NULL,
  nama_lengkap: VARCHAR(100) NOT NULL,
  nomor_telepon: VARCHAR(15),
  role: ENUM('admin', 'operator', 'customer') NOT NULL,
  status: ENUM('aktif', 'nonaktif') DEFAULT 'aktif',
  tanggal_registrasi: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  terakhir_login: TIMESTAMP
)
```

#### Tabel: menu
```
menu (
  menu_id: INT PRIMARY KEY AUTO_INCREMENT,
  nama_menu: VARCHAR(100) NOT NULL,
  kategori: ENUM('makanan', 'minuman', 'dessert') NOT NULL,
  harga: INT NOT NULL,
  deskripsi: TEXT,
  gambar_url: VARCHAR(255),
  stok: INT DEFAULT 0,
  stok_minimum: INT DEFAULT 5,
  status: ENUM('tersedia', 'terbatas', 'habis') DEFAULT 'tersedia',
  tanggal_ditambahkan: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  terakhir_diupdate: TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
)
```

#### Tabel: stok_history
```
stok_history (
  history_id: INT PRIMARY KEY AUTO_INCREMENT,
  menu_id: INT NOT NULL,
  stok_sebelum: INT NOT NULL,
  stok_sesudah: INT NOT NULL,
  perubahan: INT NOT NULL,
  keterangan: VARCHAR(255),
  user_id: INT NOT NULL,
  tanggal_perubahan: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
  FOREIGN KEY (user_id) REFERENCES user(user_id)
)
```

#### Tabel: pesanan
```
pesanan (
  order_id: INT PRIMARY KEY AUTO_INCREMENT,
  customer_id: INT NOT NULL,
  total_harga: INT NOT NULL,
  status_pesanan: ENUM('pending_pembayaran', 'menunggu_verifikasi', 'pembayaran_dikonfirmasi', 'selesai', 'dibatalkan') DEFAULT 'pending_pembayaran',
  tanggal_pesanan: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  tanggal_diambil: TIMESTAMP NULL,
  catatan: TEXT,
  FOREIGN KEY (customer_id) REFERENCES user(user_id)
)
```

#### Tabel: pesanan_detail
```
pesanan_detail (
  detail_id: INT PRIMARY KEY AUTO_INCREMENT,
  order_id: INT NOT NULL,
  menu_id: INT NOT NULL,
  jumlah: INT NOT NULL,
  harga_satuan: INT NOT NULL,
  subtotal: INT NOT NULL,
  FOREIGN KEY (order_id) REFERENCES pesanan(order_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id)
)
```

#### Tabel: bukti_pembayaran
```
bukti_pembayaran (
  bukti_id: INT PRIMARY KEY AUTO_INCREMENT,
  order_id: INT NOT NULL,
  file_url: VARCHAR(255) NOT NULL,
  status_bukti: ENUM('menunggu_verifikasi', 'disetujui', 'ditolak') DEFAULT 'menunggu_verifikasi',
  tanggal_upload: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (order_id) REFERENCES pesanan(order_id)
)
```

#### Tabel: pembayaran
```
pembayaran (
  pembayaran_id: INT PRIMARY KEY AUTO_INCREMENT,
  order_id: INT NOT NULL,
  bukti_id: INT,
  nominal_transfer: INT NOT NULL,
  status_pembayaran: ENUM('pending', 'selesai', 'ditolak') DEFAULT 'pending',
  alasan_penolakan: TEXT,
  diverifikasi_oleh: INT,
  tanggal_verifikasi: TIMESTAMP NULL,
  FOREIGN KEY (order_id) REFERENCES pesanan(order_id),
  FOREIGN KEY (bukti_id) REFERENCES bukti_pembayaran(bukti_id),
  FOREIGN KEY (diverifikasi_oleh) REFERENCES user(user_id)
)
```

#### Tabel: komentar
```
komentar (
  komentar_id: INT PRIMARY KEY AUTO_INCREMENT,
  customer_id: INT NOT NULL,
  menu_id: INT NOT NULL,
  order_id: INT NOT NULL,
  rating: INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  teks_komentar: TEXT,
  tanggal_komentar: TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (customer_id) REFERENCES user(user_id),
  FOREIGN KEY (menu_id) REFERENCES menu(menu_id),
  FOREIGN KEY (order_id) REFERENCES pesanan(order_id),
  UNIQUE KEY unique_rating (customer_id, menu_id, order_id)
)
```

### ERD Diagram (Text Format)

```
┌──────────────────┐
│      user        │
├──────────────────┤
│ user_id (PK)     │
│ username         │
│ email            │
│ password_hash    │
│ nama_lengkap     │
│ nomor_telepon    │
│ role             │
│ status           │
└──────────────────┘
        │
        │ 1:N
        ├─────────────────┬──────────────┬──────────────┐
        │                 │              │              │
        ▼                 ▼              ▼              ▼
  ┌──────────┐    ┌──────────────┐  ┌──────────┐  ┌──────────┐
  │ pesanan  │    │stok_history  │  │komentar  │  │pembayaran│
  ├──────────┤    ├──────────────┤  ├──────────┤  ├──────────┤
  │order_id  │    │history_id    │  │komentar_ │  │pembayaran│
  │customer_ │    │menu_id (FK)  │  │id        │  │_id       │
  │id (FK)   │    │stok_sebelum  │  │customer_ │  │order_id  │
  │total_    │    │stok_sesudah  │  │id (FK)   │  │(FK)      │
  │harga     │    │perubahan     │  │menu_id   │  │nominal   │
  │status    │    │keterangan    │  │(FK)      │  │_transfer │
  │pesanan   │    │user_id (FK)  │  │order_id  │  │status    │
  │tanggal   │    │tanggal       │  │(FK)      │  │pembayaran│
  └──────────┘    └──────────────┘  │rating    │  └──────────┘
        │                            │teks      │
        │                            └──────────┘
        │ 1:N
        ▼
  ┌──────────────┐
  │pesanan_detail│
  ├──────────────┤
  │detail_id     │
  │order_id (FK) │
  │menu_id (FK)  │
  │jumlah        │
  │harga_satuan  │
  │subtotal      │
  └──────────────┘
        │
        │ N:1
        ▼
  ┌──────────┐
  │  menu    │
  ├──────────┤
  │menu_id   │
  │nama_menu │
  │kategori  │
  │harga     │
  │deskripsi │
  │gambar_url│
  │stok      │
  │status    │
  └──────────┘

  ┌──────────────────┐
  │bukti_pembayaran  │
  ├──────────────────┤
  │bukti_id (PK)     │
  │order_id (FK)     │
  │file_url          │
  │status_bukti      │
  │tanggal_upload    │
  └──────────────────┘
        │
        │ 1:1
        └────────────────→ pembayaran
```

---

## RENCANA TESTING

### 1. Unit Testing
- Test setiap fungsi/method secara isolated.
- Coverage minimal 80%.

### 2. Integration Testing
- Test interaksi antar modul.
- Test database transactions.
- Test payment verification flow.

### 3. System Testing
- Test seluruh sistem end-to-end.
- Test dengan data volume besar.

### 4. User Acceptance Testing (UAT)
- Involve stakeholder dan end-user.
- Gather feedback dan suggestions.

---

## TIMELINE PENGEMBANGAN

| Fase | Durasi | Aktivitas |
|------|--------|-----------|
| Analisis & Desain | 2 minggu | Analisis kebutuhan, design database, design UI/UX |
| Development | 8 minggu | Development backend API, Development mobile app, Development web dashboard |
| Testing | 3 minggu | Unit testing, Integration testing, System testing, UAT |
| Deployment | 1 minggu | Production setup, Data migration, Go-live |

---

## KESIMPULAN

Dokumen SRS SMART-E-KANTIN ini telah menjabarkan seluruh kebutuhan sistem secara terperinci, mencakup latar belakang, tujuan, ruang lingkup, analisis kebutuhan fungsional dan non-fungsional, serta desain database. Dokumen ini akan menjadi fondasi bagi tim developer dalam membangun sistem yang memenuhi ekspektasi stakeholder dan memecahkan masalah yang dihadapi oleh kantin.

---

**Dokumen ini disusun dan disepakati oleh:**

| Jabatan | Nama | Tanggal | Tanda Tangan |
|---------|------|---------|-------------|
| Dosen Pengampu | [.........................] | .................... | [...............] |
| Pengelola Kantin | [.........................] | .................... | [...............] |
| Ketua Tim Developer | [.........................] | .................... | [...............] |

---

*Document Version: 1.0*  
*Last Updated: December 1, 2025*  
*Status: Draft*
