# Börü CRM

Flutter ve Supabase kullanılarak geliştirilmiş, küçük ölçekli bir **CRM (Customer Relationship Management)** mobil uygulaması. Bu proje 1 haftalık bir zaman diliminde, Flutter'da BLoC/Cubit state management ve Supabase backend'ini birlikte kullanma pratiği yapmak amacıyla geliştirilmiştir.

##  Proje Hakkında

Börü CRM, küçük işletmelerin müşterilerini, ürünlerini ve müşteri-ürün ilişkilerini (satın alma, ödeme durumu, notlar) tek bir yerden takip edebilmesini sağlayan basit bir müşteri ilişkileri yönetim uygulamasıdır. Proje kapsamında:

- Kimlik doğrulama (auth) akışı
- Müşteri kayıtlarının oluşturulması, listelenmesi ve düzenlenmesi
- Ürün kataloğu yönetimi
- Müşteri bazlı satın alma ve ödeme takibi
- Müşteri bazlı not (aktivite geçmişi) tutulması

gibi temel bir CRM'in çekirdek özellikleri hedeflenmiştir.

## Kullanılan Teknoloji Yığını

- **Flutter** — mobil arayüz
- **flutter_bloc / bloc (Cubit)** — state management
- **Supabase** — backend (PostgreSQL veritabanı, Authentication, Row Level Security)
- **flutter_dotenv** — ortam değişkenlerinin (Supabase URL/key) koddan ayrıştırılması

 ## Mimari

Proje, sorumlulukların ayrıştırıldığı katmanlı bir mimariyle yapılandırılmıştır:

```
lib/
  core/
    constants/     → renkler, string'ler, text style'lar tek yerden yönetilir
    utils/         → status/zaman formatlama gibi yardımcı fonksiyonlar
    widgets/       → yeniden kullanılabilir UI bileşenleri
    features/
      auth/        → giriş, oturum yönetimi
      customers/   → müşteri model, repository, cubit, ekranlar
      product/     → ürün model, repository, cubit, ekranlar
      purchase/    → satın alma model, repository, cubit, ekranlar
      notes/       → not model, repository, cubit
```

Her feature kendi içinde **Model → Repository → Cubit → UI** akışını takip eder:
- **Model**: Supabase'den gelen JSON verisini Dart nesnesine çevirir.
- **Repository**: Supabase sorgularının (select/insert/update/delete) yazıldığı katman.
- **Cubit**: Repository'yi çağırıp UI'ın tüketeceği state'leri (loading/loaded/error) yönetir.
- **UI**: Cubit'i dinleyip ekrana yansıtan widget'lar.

Bu ayrım, iş mantığını Flutter'dan bağımsız tutmayı (Cubit'ler `package:bloc`, UI `package:flutter_bloc` kullanır) ve test edilebilirliği (repository'ler constructor injection ile veriliyor) hedefler.

### Veritabanı ve Güvenlik

Supabase tarafında 4 tablo bulunur: `customers`, `products`, `purchases`, `notes`. Her tabloda **Row Level Security (RLS)** açıktır ve her kullanıcı yalnızca kendi `user_id`'sine ait kayıtlara erişebilir — bu sayede birden fazla kullanıcı aynı uygulamayı kullansa bile veriler birbirinden izole kalır.

## Tasarım Süreci

Uygulamanın arayüz tasarımları **Google Stitch** ile prototiplenmiş, ardından Flutter widget koduna geçirilmiştir. Geliştirme süreci boyunca UI kod yazımı **Claude** ile birlikte çalışılmıştır.



- [x] Email/şifre ile giriş, oturum kalıcılığı (session persistence)
- [x] Müşteri ekleme, düzenleme, listeleme
- [x] Müşteri detayında iletişim bilgisi, satın alma geçmişi ve notlar
- [x] Ürün ekleme ve listeleme
- [x] Müşteriye satın alma/ödeme kaydı ekleme
- [x] Row Level Security ile kullanıcı bazlı veri izolasyonu


> **Not:**
`.env` dosyası `.gitignore` ile gizlenmiştir önceki key'ler görünüyor amacım .env i yide dahil etmekti,
Projenin database şemasına `/supabase` klasörü içindeki `schema.sql` ile ulaşabilirsiniz.
Bu proje eğitim ve portföy amacıyla geliştirilmiştir.