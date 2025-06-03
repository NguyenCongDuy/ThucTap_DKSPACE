@extends('layout.admin')

@section('title', 'Tạo bài viết mới')

@section('content')
    <h1>Tạo bài viết mới</h1>
    <x-alert type="success" :message="session('success')" />
    <x-alert type="error" :message="session('error')" />
    <x-alert type="warning" :message="session('warning')" />
    
    <form method="POST" action="{{ route('admin.posts.store') }}">
        @csrf

        <div class="mb-3">
            <label for="title" class="form-label">Tiêu đề</label>
            <input type="text" name="title" class="form-control" value="{{ old('title') }}">
            @error('title')
                <div class="text-danger">{{ $message }}</div>
            @enderror
        </div>

        <div class="mb-3">
            <label for="content" class="form-label">Nội dung</label>
            <textarea name="content" rows="5" class="form-control">{{ old('content') }}</textarea>
            @error('content')
                <div class="text-danger">{{ $message }}</div>
            @enderror
        </div>

        <button type="submit" class="btn btn-success">Lưu bài viết</button>
    </form>
@endsection
