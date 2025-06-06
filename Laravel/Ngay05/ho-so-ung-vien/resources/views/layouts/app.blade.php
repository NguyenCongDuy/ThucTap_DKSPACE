<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>@yield('title', 'Hệ thống tuyển dụng')</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    @livewireStyles
</head>

<body>
    @livewireScripts
    <nav class="navbar navbar-expand-lg navbar-light bg-light shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold" href="#">Tuyển Dụng</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-end" id="navbarNav">
                <ul class="navbar-nav">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Trang chủ</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/candidates">Ứng viên</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/jobs">Việc làm</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/contact">Liên hệ</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        @yield('content')
    </div>

    <footer class="text-muted py-4 mt-5" style="background-color: #f8f9fa; border-top: 1px solid #dee2e6;">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3">
                    <h5 class="fw-bold">Hệ thống tuyển dụng </h5>
                    <p>Nền tảng hỗ trợ nhà tuyển dụng và ứng viên kết nối nhanh chóng, hiệu quả và đáng tin cậy.</p>
                </div>

                <div class="col-md-4 mb-3">
                    <h6 class="fw-bold">Liên kết nhanh</h6>
                    <ul class="list-unstyled">
                        <li><a href="/" class="text-decoration-none text-muted">Trang chủ</a></li>
                        <li><a href="/candidates" class="text-decoration-none text-muted">Danh sách ứng viên</a></li>
                        <li><a href="/jobs" class="text-decoration-none text-muted">Việc làm</a></li>
                        <li><a href="/contact" class="text-decoration-none text-muted">Liên hệ</a></li>
                    </ul>
                </div>

                <div class="col-md-4 mb-3">
                    <h6 class="fw-bold">Thông tin liên hệ</h6>
                    <p class="mb-1"><i class="bi bi-geo-alt-fill me-1"></i> Hà Nội, Việt Nam</p>
                    <p class="mb-1"><i class="bi bi-envelope-fill me-1"></i> support@duytuyendung.vn</p>
                    <p><i class="bi bi-telephone-fill me-1"></i> 0123 456 789</p>
                </div>
            </div>

            <hr>
            <div class="text-center small">
                <p class="mb-0">© {{ date('Y') }} Hệ thống tuyển dụng Duy. All rights reserved.</p>
            </div>
        </div>
    </footer>


    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
<style>
    footer {
        background-color: #f8f9fa;
        padding: 20px 0;
        border-top: 1px solid #dee2e6;
        margin-top: 40px;
    }
</style>
