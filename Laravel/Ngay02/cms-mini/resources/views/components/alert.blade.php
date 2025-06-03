@props([
    'type' => 'success',
    'message' => '',
])

@php
    $alertTypes = [
        'success' => 'alert-success',
        'error' => 'alert-danger',
        'warning' => 'alert-warning',
    ];

    $alertClass = $alertTypes[$type] ?? 'alert-info';
@endphp

@if ($message)
    <div class="alert {{ $alertClass }} alert-dismissible fade show" role="alert">
        {{ $message }}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Đóng"></button>
    </div>
@endif
