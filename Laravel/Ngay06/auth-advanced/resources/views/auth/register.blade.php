<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Đăng ký</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body class="bg-light d-flex align-items-center" style="height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4">
                        <h2 class="card-title text-center mb-4">Đăng ký</h2>

                        @if (session('success'))
                            <div class="alert alert-success">{{ session('success') }}</div>
                        @endif

                        @if ($errors->any())
                            <div class="alert alert-danger">
                                <ul class="mb-0">
                                    @foreach ($errors->all() as $error)
                                        <li>{{ $error }}</li>
                                    @endforeach
                                </ul>
                            </div>
                        @endif

                        <form method="POST" action="/register" novalidate>
                            @csrf

                            <div class="mb-3">
                                <input type="text" name="name" placeholder="Họ tên" class="form-control"
                                    value="{{ old('name') }}">
                            </div>

                            <div class="mb-3">
                                <input type="email" name="email" placeholder="Email" class="form-control"
                                    value="{{ old('email') }}">
                            </div>

                            <div class="mb-3">
                                <input type="password" name="password" placeholder="Mật khẩu" class="form-control">
                            </div>

                            <div class="mb-3">
                                <input type="password" name="password_confirmation" placeholder="Xác nhận mật khẩu"
                                    class="form-control">
                            </div>

                            <div class="d-grid mb-3">
                                <button type="submit" class="btn btn-success">Đăng ký</button>
                            </div>

                            <div class="text-center">
                                <a href="/login" class="btn btn-link">Đã có tài khoản?</a>
                            </div>
                        </form>
                    </div>
                </div>
                <p class="text-center text-muted mt-3 mb-0">© 2025 MyUserSite</p>
            </div>
        </div>
    </div>

    <!-- Bootstrap 5 JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
