@extends('layouts.app')

@section('content')
<h2>{{ $post->title }}</h2>
<p>{{ $post->content }}</p>

<hr>
<h4>Bình luận</h4>
@foreach($post->comments as $comment)
    <p><strong>{{ $comment->user->name }}:</strong> {{ $comment->content }}</p>
@endforeach

<p>Trạng thái: {{ Auth::check() ? '🟢' : 'Đăng nhập để bình luận.' }}</p>

@auth
<form method="POST" action="{{ url('/posts/' . $post->id . '/comments') }}">
    @csrf
    <textarea name="content" rows="3" required></textarea>
    <br>
    <button type="submit">Gửi bình luận</button>
</form>
@else
<p>Vui lòng <a href="{{ route('login') }}">đăng nhập</a> để bình luận.</p>
@endauth
@endsection
