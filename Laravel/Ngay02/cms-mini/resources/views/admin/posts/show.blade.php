@extends('layout.admin')

@section('title', $post->title)

@section('content')
    <h1>{{ $post->title }}</h1>
    <p><strong>Slug:</strong> {{ $post->slug }}</p>
    <p><strong>Nội dung:</strong></p>
    <div class="border p-3">
        {!! nl2br(e($post->content)) !!}
    </div>
@endsection
