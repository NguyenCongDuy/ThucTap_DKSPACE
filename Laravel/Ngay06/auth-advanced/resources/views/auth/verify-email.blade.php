<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8" />
    <title>Xác minh email</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<body class="bg-light d-flex align-items-center" style="height: 100vh;">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6 col-lg-5">
                <div class="card shadow-sm">
                    <div class="card-body p-4 text-center">
                        <h2 class="card-title mb-4">Xác minh email</h2>

                        @if (session('error'))
                            <div class="alert alert-danger">{{ session('error') }}</div>
                        @endif

                        @if (session('success'))
                            <div class="alert alert-success">{{ session('success') }}</div>
                        @endif

                        <p class="mb-4">Vui lòng kiểm tra email và xác minh trước khi truy cập hệ thống.</p>

                        <form method="POST" action="{{ route('verification.resend') }}" class="mb-3">
                            @csrf
                            <button type="submit" class="btn btn-primary w-100">Gửi lại email xác minh</button>
                        </form>

                        <form method="POST" action="/logout">
                            @csrf
                            <button type="submit" class="btn btn-outline-secondary w-100">Đăng xuất</button>
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
