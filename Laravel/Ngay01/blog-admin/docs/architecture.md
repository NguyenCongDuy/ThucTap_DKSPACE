**app/Http: Chứa các thành phần xử lý các yêu cầu HTTP đến ứng dụng.**
- Controllers: Chứa các lớp controller, nơi xử lý logic chính của yêu cầu HTTP, tương tác với model và trả về phản hồi.

**app/Providers:Chứa các Service Provider**
- Các provider khác như AuthServiceProvider, BroadcastServiceProvider, EventServiceProvider, RouteServiceProvider có vai trò cụ thể trong - việc cấu hình xác thực, broadcast, sự kiện và định tuyến.

**resources/views:Chứa tất cả các Blade template của ứng dụng.**
- Các file này chứa mã HTML với cú pháp Blade để hiển thị dữ liệu cho người dùng

**routes/: Chứa các file định nghĩa tuyến đường (routes) của ứng dụng.**
- web.php: Định nghĩa các tuyến đường cho giao diện web 
- console.php: Định nghĩa các lệnh Artisan tùy chỉnh.

**storage/: Chứa các file được tạo ra bởi ứng dụng, không nên được kiểm soát phiên bản (version control).**
- app/: Nơi lưu trữ các file được tạo bởi ứng dụng (ví dụ: uploads của người dùng).
- framework/: Chứa các file được tạo bởi framework (ví dụ: sessions, cache, views đã biên dịch).
- logs/: Chứa các file log của ứng dụng.

**bootstrap/Chứa các file cần thiết để khởi động (bootstrap) framework.**
- app.php: File chính khởi tạo ứng dụng Laravel, tạo ra Service Container và đăng ký các Service Provider cơ bản.
- cache/: Chứa các file cache được tạo ra trong quá trình tối ưu hóa ứng dụng (ví dụ: cache các service provider, routes, config).

**Service Container**
- là hệ thống **Dependency Injection Container** của Laravel, giúp:
  + Quản lý và khởi tạo các class có phụ thuộc (dependencies).
  + Tự động inject các phụ thuộc vào Controller, Middleware, Job, Event, Service,...

**Chuẩn đặt tên PSR-4, PSR-12**
- PSR-4: Autoloading Standard
  + Tên file PHP phải trùng với tên class.
  + Cấu trúc thư mục phải tương ứng với namespace.
  + Laravel đã tuân thủ PSR-4 sẵn thông qua composer.json
- PSR-12: Coding Style Standard
  + Quy định rõ ràng về indentation, dấu ngoặc, khoảng trắng, độ dài dòng,...
  + Laravel 12 tuân thủ PSR-12 mặc định, đặc biệt khi dùng php-cs-fixer hoặc laravel pint.
**Kiến trúc: Domain > Services > Interfaces**
 - Tách biệt logic nghiệp vụ (domain logic) khỏi tầng controller và model.
 - Dễ mở rộng, test và bảo trì.
VD:
 app/
├── Domain/
│   └── User/
│       ├── Entities/
│       ├── Services/
│       │   └── UserService.php
│       ├── Interfaces/
│       │   └── UserRepositoryInterface.php
│       └── Repositories/
│           └── EloquentUserRepository.php


