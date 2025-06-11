<!DOCTYPE html>
<html>
<head>
    <title>Laravel News Pro - Trang chủ</title>
</head>
<body>
    <h1>Top 5 bài viết hôm nay</h1>

    @if($topPosts->isEmpty())
        <p>Chưa có bài viết nào hôm nay.</p>
    @else
        <ul>
            @foreach($topPosts as $post)
                <li>
                    <strong>{{ $post->title }}</strong> – {{ $post->views }} lượt xem
                </li>
            @endforeach
        </ul>
    @endif
</body>
</html>
