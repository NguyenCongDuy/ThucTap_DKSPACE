@extends('layouts.app')
@section('title', 'Trang Chủ')
@section('content')

    <h2 class="mb-4">Danh sách bài viết</h2>

    <a href="{{ route('posts.create') }}" class="btn btn-success mb-3">Thêm bài viết</a>

    @if ($posts->count())
        <div class="row g-4">
            @foreach ($posts as $post)
                <div class="col-md-6 col-lg-4">
                    <div class="card h-100 shadow-sm">
                        <div class="card-body d-flex flex-column">
                            <h5 class="card-title">{{ $post->title }}</h5>
                            <p class="card-text flex-grow-1 text-truncate" style="max-height: 6rem;">
                                {{ Str::limit($post->content, 150, '...') }}
                            </p>
                            <div class="mt-3">
                                @can('update', $post)
                                    <a href="{{ route('posts.edit', $post) }}" class="btn btn-primary btn-sm me-2">Sửa</a>
                                @endcan

                                @can('delete', $post)
                                    <form action="{{ route('posts.destroy', $post) }}" method="POST" class="d-inline-block"
                                        onsubmit="return confirm('Bạn có chắc muốn xóa bài viết này?');">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="btn btn-danger btn-sm">Xóa</button>
                                    </form>
                                @endcan
                            </div>
                        </div>
                    </div>
                </div>
            @endforeach
        </div>

        <div class="mt-4">
            {{ $posts->onEachSide(1)->links('pagination::bootstrap-5') }}
        </div>
    @else
        <p>Chưa có bài viết nào.</p>
    @endif

@endsection
