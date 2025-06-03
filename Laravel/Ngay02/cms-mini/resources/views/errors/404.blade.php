@extends('layout.admin')

@section('title', 'Không tìm thấy trang')

@section('content')
    <div class="text-center mt-5">
        <h1 class="display-4">404 - Không tìm thấy trang</h1>
        <p class="lead">Trang bạn đang tìm kiếm không tồn tại.</p>
        <a href="{{ route('admin.posts.index') }}" class="btn btn-primary">Quay lại trang bài viết</a>
    </div>
@endsection
