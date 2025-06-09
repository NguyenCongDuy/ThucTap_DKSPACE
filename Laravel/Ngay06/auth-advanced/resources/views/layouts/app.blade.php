<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>@yield('title', 'Trang Người Dùng')</title>
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet" />
    @stack('styles')
</head>

<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-primary">
        <div class="container-fluid">
            <a class="navbar-brand" href="#">MyUserSite</a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarUser"
                aria-controls="navbarUser" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarUser">
                <ul class="navbar-nav me-auto mb-2 mb-lg-0">
                    <a class="nav-link active" aria-current="page" href="{{ route('dashboard') }}">Trang Chủ</a>
                    <li class="nav-item"><a class="nav-link" href="{{ route('dashboard') }}">Bài Viết</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Tin Tức</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Liên Hệ</a></li>
                </ul>

                <form class="d-flex me-3" role="search">
                    <input class="form-control me-2" type="search" placeholder="Tìm kiếm" aria-label="Search" />
                    <button class="btn btn-light" type="submit">Tìm</button>
                </form>
                @auth
                    <div class="d-flex align-items-center">
                        <span class="text-white me-3">Xin chào, {{ auth()->user()->name }}</span>
                        <form method="POST" action="{{ route('logout') }}">
                            @csrf
                            <button type="submit" class="btn btn-danger btn-sm">Đăng xuất</button>
                        </form>
                    </div>
                @else
                    <a href="{{ route('login') }}" class="btn btn-outline-light">Đăng nhập</a>
                @endauth
            </div>
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <nav id="sidebarMenu" class="col-md-3 col-lg-2 d-md-block bg-light sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-cart"></i> Giỏ Hàng
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="{{ route('profile.two-factor') }}">
                                <i class="bi bi-people"></i> Tài Khoản
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link" href="#">
                                <i class="bi bi-gear"></i> Cài Đặt
                            </a>
                        </li>
                    </ul>
                </div>
            </nav>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 py-4">
                @yield('content')
            </main>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-primary text-white text-center py-4 mt-auto">
        <div class="container">
            <div class="row">
                <div class="col-md-4 mb-3 mb-md-0">
                    <h5>Về chúng tôi</h5>
                    <p>MyUserSite là trang web cung cấp các bài viết chất lượng và sản phẩm đa dạng, phục vụ cộng đồng
                        người dùng Việt Nam.</p>
                </div>
                <div class="col-md-4 mb-3 mb-md-0">
                    <h5>Liên hệ</h5>
                    <p>Email: contact@myusersite.com</p>
                    <p>Điện thoại: 0123 456 789</p>
                    <p>Địa chỉ: 123 Đường ABC, Quận XYZ, Hà Nội</p>
                </div>
                <div class="col-md-4">
                    <h5>Kết nối với chúng tôi</h5>
                    <a href="#" class="text-white me-3" title="Facebook">
                        <i class="bi bi-facebook fs-4"></i>
                    </a>
                    <a href="#" class="text-white me-3" title="Twitter">
                        <i class="bi bi-twitter fs-4"></i>
                    </a>
                    <a href="#" class="text-white me-3" title="Instagram">
                        <i class="bi bi-instagram fs-4"></i>
                    </a>
                    <a href="#" class="text-white" title="LinkedIn">
                        <i class="bi bi-linkedin fs-4"></i>
                    </a>
                </div>
            </div>

            <hr class="my-4" style="border-color: rgba(255,255,255,0.3)" />

            <small>&copy; 2025 MyUserSite. Bản quyền thuộc về Duy. Thiết kế &amp; phát triển bởi đội ngũ
                MyUserSite.</small>
        </div>
    </footer>

    <!-- Bootstrap 5 JS + Popper -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    @stack('scripts')
</body>

</html>
