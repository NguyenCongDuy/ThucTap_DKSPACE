@extends('layouts.app')

@section('content')
    <div class="container">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h2>Thông báo chưa đọc</h2>
            @if (auth()->user()->unreadNotifications->count() > 0)
                <form action="{{ route('notifications.markAllAsRead') }}" method="POST">
                    @csrf
                    <button type="submit" class="btn btn-primary">Đánh dấu tất cả đã đọc</button>
                </form>
            @endif
        </div>

        @if (auth()->user()->unreadNotifications->count() > 0)
            <ul class="list-group mb-4">
                @foreach (auth()->user()->unreadNotifications as $notification)
                    <li class="list-group-item d-flex justify-content-between align-items-center">
                        <div>
                            @if ($notification->type === 'App\Notifications\NewUserRegistered')
                                <i class="fas fa-user-plus text-success me-2"></i>
                                <strong>Người dùng mới:</strong> {{ $notification->data['name'] ?? 'Không xác định' }}
                                ({{ $notification->data['email'] ?? 'Không có email' }})
                                đã đăng ký vào {{ \Carbon\Carbon::parse($notification->data['registered_at'] ?? now())->format('d/m/Y H:i') }}
                            @else
                                <i class="fas fa-comment text-primary me-2"></i>
                                {{ $notification->data['commenter'] ?? 'Người dùng' }} đã bình luận:
                                "{{ $notification->data['comment_content'] ?? 'Nội dung bình luận' }}"
                                vào bài viết ID: {{ $notification->data['post_id'] ?? 'N/A' }}
                            @endif
                        </div>
                        <div class="d-flex">
                            <form action="{{ route('notifications.markAsRead', $notification->id) }}" method="POST"
                                class="me-2">
                                @csrf
                                <button type="submit" class="btn btn-sm btn-primary">Đánh dấu đã đọc</button>
                            </form>
                            <form action="{{ route('notifications.destroy', $notification->id) }}" method="POST">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-danger">Xóa</button>
                            </form>
                        </div>
                    </li>
                @endforeach
            </ul>
        @else
            <p>Bạn không có thông báo nào chưa đọc.</p>
        @endif

        <h2 class="mt-5 mb-4">Thông báo đã đọc</h2>

        @if (auth()->user()->readNotifications->count() > 0)
            <ul class="list-group">
                @foreach (auth()->user()->readNotifications as $notification)
                    <li class="list-group-item d-flex justify-content-between align-items-center text-muted">
                        <div>
                            @if ($notification->type === 'App\Notifications\NewUserRegistered')
                                <i class="fas fa-user-plus me-2"></i>
                                <strong>Người dùng mới:</strong> {{ $notification->data['name'] ?? 'Không xác định' }}
                                ({{ $notification->data['email'] ?? 'Không có email' }})
                                đã đăng ký vào {{ \Carbon\Carbon::parse($notification->data['registered_at'] ?? now())->format('d/m/Y H:i') }}
                            @else
                                <i class="fas fa-comment me-2"></i>
                                {{ $notification->data['commenter'] ?? 'Người dùng' }} đã bình luận:
                                "{{ $notification->data['comment_content'] ?? 'Nội dung bình luận' }}"
                                vào bài viết ID: {{ $notification->data['post_id'] ?? 'N/A' }}
                            @endif
                        </div>
                        <form action="{{ route('notifications.destroy', $notification->id) }}" method="POST">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-sm btn-outline-danger">Xóa</button>
                        </form>
                    </li>
                @endforeach
            </ul>
        @else
            <p>Bạn không có thông báo nào đã đọc.</p>
        @endif
    </div>
@endsection

