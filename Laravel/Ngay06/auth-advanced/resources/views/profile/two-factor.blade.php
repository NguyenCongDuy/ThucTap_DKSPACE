@extends('layouts.app')

@section('content')
    <div class="container py-4">
        <h2 class="mb-4 text-center">Two-Factor Authentication (Xác thực 2 bước)</h2>

        @if (session('success'))
            <div class="alert alert-success">
                {{ session('success') }}
            </div>
        @endif

        @if (session('error'))
            <div class="alert alert-danger">
                {{ session('error') }}
            </div>
        @endif

        <div class="card shadow-sm">
            <div class="card-body">
                @if (!auth()->user()->two_factor_secret)
                    <form method="POST" action="{{ route('two-factor.enable') }}">
                        @csrf
                        <button type="submit" class="btn btn-primary w-100">Bật xác thực 2 bước</button>
                    </form>
                @else
                    <div class="mb-4 text-center">
                        <p>Scan mã QR trong ứng dụng Google Authenticator:</p>
                        <div class="d-flex justify-content-center mb-3">
                            {!! auth()->user()->twoFactorQrCodeSvg() !!}
                        </div>
                        <p><strong>Mã khôi phục:</strong></p>
                        <ul class="list-group mb-4">
                            @php
                                $recoveryCodes =
                                    json_decode(decrypt(auth()->user()->two_factor_recovery_codes), true) ?? [];
                            @endphp

                            @foreach ($recoveryCodes as $code)
                                <li class="list-group-item">{{ $code }}</li>
                            @endforeach
                        </ul>
                    </div>

                    <form method="POST" action="{{ route('two-factor.disable') }}">
                        @csrf
                        @method('DELETE')
                        <button type="submit" class="btn btn-danger w-100">Tắt xác thực 2 bước</button>
                    </form>
                @endif
            </div>
        </div>
    </div>
@endsection
