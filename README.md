# 📚 E-Perpus JSP - Sistem Perpustakaan Digital

Aplikasi perpustakaan digital modern berbasis **Java Server Pages (JSP)** dengan desain minimalis dan user-friendly.  Aplikasi ini mendukung manajemen buku, peminjaman, review, dan wishlist.

---

## ✨ Fitur Utama

### 👤 Untuk Anggota (Member)
- 🔍 **Pencarian & Filter Buku** - Cari buku berdasarkan judul, penulis, atau kategori
- 📖 **Detail Buku Lengkap** - Lihat informasi detail, rating, dan review
- 📚 **Peminjaman Buku** - Pinjam buku dengan sistem tracking otomatis
- ⭐ **Review & Rating** - Berikan rating dan komentar untuk buku
- ❤️ **Wishlist** - Simpan buku favorit untuk dibaca nanti
- 📊 **Riwayat Peminjaman** - Pantau status peminjaman aktif dan history

### 👨‍💼 Untuk Admin
- ➕ **Manajemen Buku** - Tambah, edit, dan hapus data buku
- 📂 **Upload Cover Buku** - Upload gambar cover dengan dukungan multipart
- 👥 **Manajemen Anggota** - Kelola data pengguna terdaftar
- 📋 **Monitoring Peminjaman** - Pantau dan proses pengembalian buku
- 📊 **Dashboard Admin** - Statistik dan overview sistem

---

## 🛠️ Teknologi yang Digunakan

### Backend
- **Java 11**
- **Jakarta EE 10** (formerly Java EE)
- **JSP & Servlets**
- **PostgreSQL 42.7.8** - Database
- **jBCrypt 0.4** - Password hashing
- **Apache Maven** - Build tool

### Frontend
- **Bootstrap 5** - UI Framework
- **Font Awesome 6** - Icons
- **Google Fonts (Inter)** - Typography
- **Custom CSS** - Design system minimalis

---

## 📋 Prasyarat

Sebelum menjalankan aplikasi, pastikan Anda telah menginstall:  

1. **Java Development Kit (JDK) 11** atau lebih tinggi
2. **Apache Maven 3.6+**
3. **PostgreSQL 12+**
4. **Apache Tomcat 10+** atau server aplikasi yang mendukung Jakarta EE 10
5. **IDE** (NetBeans, Eclipse, atau IntelliJ IDEA)

---

## 🚀 Cara Instalasi & Menjalankan

### 1️⃣ Clone Repository

```bash
git clone https://github.com/kamachiii/E-Perpus-JSP. git
cd E-Perpus-JSP
```

### 2️⃣ Setup Database PostgreSQL

#### Buat Database Baru
```sql
CREATE DATABASE dbperpus;
```

#### Import Data Awal
```bash
psql -U postgres -d dbperpus -f dbperpus_backup_data.sql
```

Atau gunakan PgAdmin untuk import file `dbperpus_backup_data.sql`

#### Konfigurasi Koneksi Database

Edit file konfigurasi koneksi database (biasanya di `src/main/java/util/KoneksiDB.java`):

```java
private static final String URL = "jdbc:postgresql://localhost:5432/dbperpus";
private static final String USER = "postgres";
private static final String PASSWORD = "your_password";
```

### 3️⃣ Build Project dengan Maven

```bash
mvn clean install
```

Atau jika menggunakan NetBeans: 
- Klik kanan project → **Clean and Build**

### 4️⃣ Setup Folder Uploads (Cover Buku) ⚠️ **PENTING! **

Untuk menampilkan gambar cover buku, Anda perlu mengekstrak file `target.zip` yang sudah disediakan: 

#### Cara 1: Extract Manual
1. Ekstrak file `target.zip` di root project
2. Akan muncul folder `target/uploads` yang berisi gambar-gambar cover buku
3. Copy folder `uploads` tersebut
4. Paste ke dalam folder `target/E-Perpus-1.0-SNAPSHOT/uploads`

```bash
# Contoh command di Linux/Mac: 
unzip target.zip
cp -r target/uploads target/E-Perpus-1.0-SNAPSHOT/

# Di Windows (PowerShell):
Expand-Archive -Path target.zip -DestinationPath . 
Copy-Item -Path "target\uploads" -Destination "target\E-Perpus-1.0-SNAPSHOT\" -Recurse
```

#### Cara 2: Otomatis (Jika sudah extract target.zip)
Setelah Maven build selesai, pastikan struktur folder seperti ini:
```
target/
└── E-Perpus-1.0-SNAPSHOT/
    ├── WEB-INF/
    ├── assets/
    ├── admin/
    └── uploads/          ← Folder ini harus ada dengan gambar cover
        ├── book1.jpg
        ├── book2.jpg
        └── ... 
```

> **💡 Catatan:** Tanpa langkah ini, cover buku tidak akan ditampilkan meskipun aplikasi berjalan normal.

### 5️⃣ Deploy ke Server

#### Menggunakan NetBeans:
1. Klik kanan project → **Run**
2. NetBeans akan otomatis deploy ke server yang dikonfigurasi
3. **Pastikan folder uploads sudah di-copy sebelum run! **

#### Manual Deploy:
1. Copy file `target/E-Perpus-1.0-SNAPSHOT.war` ke folder `webapps` Tomcat
2. Atau copy seluruh folder `target/E-Perpus-1.0-SNAPSHOT/` (sudah berisi folder uploads) ke `webapps/`
3. Restart Tomcat
4. Akses aplikasi di `http://localhost:8080/E-Perpus-1.0-SNAPSHOT/`

### 6️⃣ Akses Aplikasi

Buka browser dan akses: 
```
http://localhost:8080/E-Perpus-1.0-SNAPSHOT/
```

Atau jika menggunakan NetBeans dengan custom context path:
```
http://localhost:8080/E-Perpus/
```

#### Default Login Credentials: 

**Admin:**
- Username: `admin`
- Password: `admin123` *(cek file SQL untuk password yang tepat)*

**Member:** 
- Daftar akun baru melalui halaman Register

---

## 📁 Struktur Project

```
E-Perpus-JSP/
├── src/
│   └── main/
│       ├── java/
│       │   ├── controller/        # Servlet Controllers
│       │   │   ├── AuthServlet.java
│       │   │   ├── BookServlet.java
│       │   │   ├── LoanServlet.java
│       │   │   ├── ReviewServlet.java
│       │   │   └── UserServlet.java
│       │   ├── dao/               # Data Access Objects
│       │   │   ├── BookDAO. java
│       │   │   ├── LoanDAO.java
│       │   │   ├── UserDAO.java
│       │   │   ├── ReviewDAO.java
│       │   │   └── BookmarkDAO.java
│       │   ├── model/             # Entity Models
│       │   │   ├── Book.java
│       │   │   ├── User.java
│       │   │   ├── Loan.java
│       │   │   └── Review.java
│       │   └── util/              # Utilities
│       │       └── KoneksiDB.java
│       └── webapp/
│           ├── WEB-INF/
│           │   └── web.xml
│           ├── admin/             # Admin Pages
│           │   ├── dashboard.jsp
│           │   ├── books.jsp
│           │   ├── loans. jsp
│           │   └── users.jsp
│           ├── includes/          # Reusable Components
│           │   ├── navbar.jsp
│           │   ├── sidebar.jsp
│           │   └── footer.jsp
│           ├── assets/
│           │   ├── css/
│           │   │   ├── bootstrap. min.css
│           │   │   └── style.css
│           │   └── js/
│           │       └── app.js
│           ├── uploads/           # Book Cover Images (dari target.zip)
│           ├── index.jsp          # Landing Page
│           ├── login.jsp
│           ├── register.jsp
│           ├── dashboard.jsp      # Member Dashboard
│           ├── book-detail.jsp
│           ├── categories.jsp
│           ├── loans.jsp          # Member Loans
│           └── wishlist.jsp
├── target/                        # Generated by Maven
│   ├── uploads/                   # Extract dari target.zip
│   └── E-Perpus-1.0-SNAPSHOT/
│       └── uploads/               # Copy kesini untuk production
├── pom.xml                        # Maven Configuration
├── target.zip                     # ⚠️ Berisi folder uploads dengan cover buku
├── dbperpus_backup_data.sql      # Database Schema & Data
└── README.md
```

---

## 🗄️ Skema Database

### Tabel Utama: 

- **users** - Data pengguna (admin & member)
- **books** - Data buku
- **categories** - Kategori buku
- **loans** - Data peminjaman
- **reviews** - Review dan rating buku
- **bookmarks** - Wishlist buku

Lihat file `dbperpus_backup_data. sql` untuk skema lengkap.

---

## 🎨 Desain System

Aplikasi menggunakan **Modern Minimalist Scholar** design system dengan: 

- **Color Palette:**
  - Dominant: `#2c3e50` (Midnight Blue)
  - Accent: `#3498db` (Ocean Blue)
  - Background: `#f4f6f9` (Soft Cloud)
  - Indicator: `#f1c40f` (Golden Yellow)

- **Typography:** Inter (Google Fonts)
- **Components:** Card-based layout dengan soft shadows
- **Responsive:** Mobile-first design dengan Bootstrap 5

---

## 🔐 Keamanan

- ✅ Password di-hash menggunakan **jBCrypt**
- ✅ Session management untuk authentication
- ✅ Role-based access control (Admin & Member)
- ✅ SQL injection prevention dengan PreparedStatement
- ✅ File upload validation untuk cover buku

---

## 📝 Cara Penggunaan

### Untuk Anggota (Member):

1. **Daftar Akun** - Buat akun baru melalui halaman Register
2. **Login** - Masuk dengan username dan password
3. **Cari Buku** - Gunakan search bar atau filter berdasarkan kategori
4. **Pinjam Buku** - Klik detail buku → "Borrow Now"
5. **Beri Review** - Setelah membaca, berikan rating dan komentar
6. **Cek Peminjaman** - Lihat status peminjaman di menu "My Loans"

### Untuk Admin:

1. **Login sebagai Admin**
2. **Kelola Buku** - Tambah/edit/hapus buku dari menu Books
3. **Upload Cover** - Upload gambar cover saat menambah buku
4. **Monitor Peminjaman** - Proses pengembalian di menu Loans
5. **Kelola User** - Manage member di menu Users

---

## 🐛 Troubleshooting

### Error koneksi database
```
Pastikan PostgreSQL running dan credentials di KoneksiDB.java benar
```

### Port sudah digunakan
```
Ganti port Tomcat di server.xml atau hentikan aplikasi yang menggunakan port 8080
```

### Cover buku tidak muncul / gambar broken
```
1. Pastikan sudah extract target.zip
2. Copy folder uploads ke target/E-Perpus-1.0-SNAPSHOT/uploads
3. Restart server setelah copy folder
4. Check path di BookDAO.java untuk upload directory
```

### Upload gambar gagal
```
Pastikan folder uploads/ memiliki permission write (chmod 755 di Linux/Mac)
```

### Session timeout
```
Sesuaikan session-timeout di web. xml (default 30 menit)
```

---

## 🤝 Kontribusi

Kontribusi selalu diterima! Silakan: 

1. Fork repository ini
2. Buat branch fitur baru (`git checkout -b feature/AmazingFeature`)
3. Commit perubahan (`git commit -m 'Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

---

## 📄 Lisensi

Project ini dibuat untuk keperluan pembelajaran dan portfolio. 

---

## 👨‍💻 Author

**Muhammad Kamil**
- GitHub: [@kamachiii](https://github.com/kamachiii)

**Fahrezi Noviansyah**
- GitHub: [@Rezi277](https://github.com/Rezi277)

**Satya Fadhilah Hamdy**
- GitHub: [@SatyaFadhilah](https://github.com/SatyaFadhilah)

**Tendan Triyanto**
- GitHub: [@TendanTriyanto](https://github.com/TendanTriyanto)

**Achmad Muflih AlRasyid**
- GitHub: [@Reikyuu09](https://github.com/Reikyuu09)

---

## 📞 Support

Jika ada pertanyaan atau masalah, silakan buat issue di repository ini. 

---

## 🙏 Acknowledgments

- Bootstrap Team untuk UI framework yang luar biasa
- Font Awesome untuk koleksi icon
- PostgreSQL Community
- Apache Tomcat Team

---

**⭐ Jangan lupa berikan star jika project ini membantu!**
