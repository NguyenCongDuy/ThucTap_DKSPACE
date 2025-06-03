@extends('layout.admin')

@section('title', 'Danh sách bài viết')

@section('content')
    <h1>Danh sách bài viết</h1>

    <a href="{{ route('admin.posts.create') }}" class="btn btn-primary mb-3">+ Tạo bài viết mới</a>

    @if (session('success'))
        <x-alert type="success" :message="session('success')" />
    @endif

    <table class="table">
        <thead>
            <tr>
                <th>Tiêu đề</th>
                <th>Slug</th>
                <th>Ngày tạo</th>
            </tr>
        </thead>
        <tbody>
            @forelse ($posts as $post)
                <tr>
                    <td><a href="{{ route('admin.posts.show', $post->slug) }}">{{ $post->title }}</a></td>
                    <td>{{ $post->slug }}</td>
                    <td>{{ $post->created_at->format('d/m/Y') }}</td>
                </tr>
            @empty
                <tr>
                    <td colspan="3">Chưa có bài viết nào.</td>
                </tr>
            @endforelse
        </tbody>
    </table>
@endsection
