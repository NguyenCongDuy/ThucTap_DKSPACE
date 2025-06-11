@extends('layouts.app')

@section('content')
<div class="container">
    <h1>Bài viết mới nhất</h1>
    
    @foreach($posts as $post)
    <div class="card mb-3">
        <div class="card-body">
            <h5 class="card-title"><a href="{{ url('/posts/' . $post->id) }}">{{ $post->title }}</a></h5>
            <p class="card-text">{{ \Str::limit($post->content, 200) }}</p>
            <p class="card-text">
                <small class="text-muted">
                    @if($post->user)
                        Đăng bởi {{ $post->user->name }} - {{ $post->created_at->diffForHumans() }}
                    @else
                        Đăng {{ $post->created_at->diffForHumans() }}
                    @endif
                </small>
            </p>
        </div>
    </div>
    @endforeach

</div>
@endsection
