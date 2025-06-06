@extends('layout.admin')

@section('content')
    <div class="container">
        <h2>Danh sách ứng viên</h2>
        @if (session('success'))
            @include('components.alert', ['type' => 'success', 'message' => session('success')])
        @endif
        <table class="table">
            <thead>
                <tr>
                    <th>Họ tên</th>
                    <th>Email</th>
                    <th>Ngày sinh</th>
                    <th>Ảnh đại diện</th>
                    <th>CV</th>
                    <th>Hàng động</th>
                </tr>
            </thead>
            <tbody>
                @foreach ($candidates as $candidate)
                    <tr>
                        <td>{{ $candidate->name }}</td>
                        <td>{{ $candidate->email }}</td>
                        <td>{{ $candidate->birthday }}</td>
                        <td>
                            @if ($candidate->avatar_path)
                                <img src="{{ asset('storage/' . $candidate->avatar_path) }}" alt="avatar" width="60">
                            @endif
                        </td>
                        <td>
                            @if ($candidate->cv_path)
                                <a href="{{ asset('storage/' . $candidate->cv_path) }}" target="_blank">Xem CV</a>
                            @endif
                        </td>
                        <td>
                            <form action="{{ route('admin.candidates.destroy', $candidate->id) }}" method="POST"
                                onsubmit="return confirm('Bạn có chắc chắn muốn xoá ứng viên này không?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="btn btn-sm btn-danger">Xoá</button>
                            </form>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        {{ $candidates->links() }} 
    </div>
@endsection
