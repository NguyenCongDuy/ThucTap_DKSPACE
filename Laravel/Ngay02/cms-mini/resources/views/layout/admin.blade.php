<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>@yield('title', 'Trang Quản Trị')</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    @stack('styles')
</head>
<body>
    <!-- Navbar -->
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark px-3">
        <a class="navbar-brand" href="#">CMS Admin</a>
        <div class="ms-auto">
            @auth
                <span class="text-white me-2">Xin chào, {{ Auth::user()->name }}</span>
                <form method="POST" action="{{ route('logout') }}">
                    @csrf
                    <button class="btn btn-outline-light btn-sm">Đăng xuất</button>
                </form>
            @endauth
            @guest
                <a href="{{ route('login') }}" class="btn btn-outline-light btn-sm">Đăng nhập</a>
            @endguest
        </div>
    </nav>

    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 bg-light border-end pt-3" style="min-height: 100vh">
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a href="{{ route('admin.dashboard') }}" class="nav-link">Dashboard</a>
                    </li>
                    <li class="nav-item">
                        <a href="{{ route('admin.posts.index') }}" class="nav-link">Bài viết</a>
                    </li>
                </ul>
            </div>

            <!-- Main content -->
            <main class="col-md-10 py-4 px-3">
                @yield('content')
            </main>
        </div>
    </div>

    <!-- Footer -->
    <footer class="bg-dark text-white text-center py-3 mt-4">
        <small>&copy; {{ now()->year }} CMS Mini - Laravel</small>
    </footer>

    @stack('scripts')
</body>
</html>
