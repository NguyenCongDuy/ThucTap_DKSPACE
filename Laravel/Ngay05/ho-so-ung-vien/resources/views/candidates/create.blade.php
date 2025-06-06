@extends('layouts.app')

@section('content')
    <div class="container">
        <h2>Gửi Hồ Sơ Ứng Tuyển</h2>
        @if (session('success'))
            <div class="alert alert-success mt-3">
                {{ session('success') }}
            </div>
            <script>
                setTimeout(function() {
                    var msg = document.getElementById('flash-message');
                    if (msg) msg.style.display = 'none';
                }, 3000);
            </script>
        @endif
        {{-- @include('components.alert') --}}

        <form action="{{ route('candidates.store') }}" method="POST" enctype="multipart/form-data">
            @csrf

            {{-- Họ tên --}}
            <div class="mb-3">
                <label for="name" class="form-label">Họ tên</label>
                <input type="text" name="name" class="form-control" value="{{ old('name') }}">
                @error('name')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            {{-- Email --}}
            <div class="mb-3">
                <label for="email" class="form-label">Email</label>
                <input type="email" name="email" class="form-control" value="{{ old('email') }}">
                @error('email')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            {{-- Ngày sinh --}}
            <div class="mb-3">
                <label for="birthday" class="form-label">Ngày sinh</label>
                <input type="date" name="birthday" class="form-control" value="{{ old('birthday') }}">
                @error('birthday')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            {{-- Ảnh đại diện --}}
            @livewire('candidate-upload')

            {{-- CV PDF --}}
            <div class="mb-3">
                <label for="cv" class="form-label">CV (PDF)</label>
                <input type="file" name="cv" class="form-control">
                @error('cv')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            {{-- Mô tả ngắn --}}
            <div class="mb-3">
                <label for="bio" class="form-label">Mô tả ngắn</label>
                <textarea name="bio" class="form-control" rows="4">{{ old('bio') }}</textarea>
                @error('bio')
                    <div class="text-danger">{{ $message }}</div>
                @enderror
            </div>

            <button type="submit" class="btn btn-primary">Gửi hồ sơ</button>
        </form>
    </div>
@endsection
