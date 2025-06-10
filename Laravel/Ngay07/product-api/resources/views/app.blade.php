<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>SPA - Product Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    @vite(['resources/css/app.css', 'resources/js/app.js'])
</head>

<body class="d-flex flex-column min-vh-100">
    {{-- Header --}}
    <header class="bg-primary text-white py-3">
        <div class="container d-flex justify-content-between align-items-center">
            <h1 class="h4 mb-0">🛒 Product Management</h1>
            <nav>
                <a href="#" class="text-white text-decoration-none me-3">Dashboard</a>
                <a href="#" class="text-white text-decoration-none me-3">Products</a>
                <a href="#" class="text-white text-decoration-none">Settings</a>
            </nav>
        </div>
    </header>

    {{-- Main App --}}
    <main class="flex-grow-1">
        <div id="app"></div>
    </main>

    {{-- Footer --}}
    <footer class="bg-dark text-white pt-4 mt-auto border-top">
        <div class="container">
            <div class="row text-center text-md-start">
                {{-- Logo & Slogan --}}
                <div class="col-md-4 mb-3">
                    <h5 class="fw-bold">🛍️ Product Management</h5>
                    <p class="text-muted small">Quản lý sản phẩm hiệu quả, đơn giản & nhanh chóng.</p>
                </div>

                {{-- Liên kết --}}
                <div class="col-md-4 mb-3">
                    <h6 class="text-uppercase fw-bold">Liên kết</h6>
                    <ul class="list-unstyled">
                        <li><a href="#" class="text-white text-decoration-none">Trang chủ</a></li>
                        <li><a href="#" class="text-white text-decoration-none">Sản phẩm</a></li>
                        <li><a href="#" class="text-white text-decoration-none">Liên hệ</a></li>
                    </ul>
                </div>

                <div class="col-md-4 mb-3">
                    <h6 class="text-uppercase fw-bold">Kết nối</h6>
                    <a href="#" class="text-white me-3"><i class="bi bi-facebook"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-twitter"></i></a>
                    <a href="#" class="text-white me-3"><i class="bi bi-instagram"></i></a>
                    <a href="#" class="text-white"><i class="bi bi-envelope"></i></a>
                </div>
            </div>

            <div class="text-center mt-3 border-top pt-3">
                <small class="text-muted">&copy; {{ date('Y') }} Product Management SPA. All rights
                    reserved.</small>
            </div>
        </div>
    </footer>
</body>

</html>
<style>
    a.text-white:hover {
        color: #0d6efd !important;
    }
</style>
