@extends('layouts.app')
@section('title', 'Sửa bài viết')
@section('content')

<h2 class="mb-4">Sửa bài viết</h2>

<form action="{{ route('posts.update', $post) }}" method="POST" class="needs-validation" novalidate>
    @csrf
    @method('PUT')

    <div class="mb-3">
        <label for="title" class="form-label">Tiêu đề:</label>
        <input
            type="text"
            class="form-control @error('title') is-invalid @enderror"
            id="title"
            name="title"
            value="{{ old('title', $post->title) }}"
            required
        >
        @error('title')
            <div class="invalid-feedback d-block">
                {{ $message }}
            </div>
        @enderror
    </div>

    <div class="mb-3">
        <label for="content" class="form-label">Nội dung:</label>
        <textarea
            class="form-control @error('content') is-invalid @enderror"
            id="content"
            name="content"
            rows="6"
            required
        >{{ old('content', $post->content) }}</textarea>
        @error('content')
            <div class="invalid-feedback d-block">
                {{ $message }}
            </div>
        @enderror
    </div>

    <button type="submit" class="btn btn-primary">Cập nhật</button>
    <a href="{{ route('posts.index') }}" class="btn btn-secondary ms-2">Hủy</a>
</form>

<!-- Optional: Bootstrap 5 validation script -->
<script>
    (() => {
      'use strict'
      const forms = document.querySelectorAll('.needs-validation')
      Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
          if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
          }
          form.classList.add('was-validated')
        }, false)
      })
    })()
</script>

@endsection
