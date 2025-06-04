**Truy vấn kiểm thử**
- Lấy danh sách tác giả có từ 5 bài viết trở lên
Author::has('posts', '>=', 5)->get();

- Tạo mới bài viết cho tác giả cụ thể
$author = Author::find(1);
$author->posts()->create([
    'title' => 'bài viết mới tạo thủ công',
    'content' => 'Nội dung chi tiết ở đây...',
    'status' => 'published',
    'published_at' => now()
]);

- Cập nhật một bài viết theo slug
$post = Post::where('slug', 'bai-viet-moi-tao-thu-cong')->first();
$post->update([
    'content' => 'Nội dung đã cập nhật',
    'status' => 'archived',
]);

- Xóa tác giả bất kỳ và kiểm tra post bị xóa
// Trước khi xóa
$countBefore = Post::count();

$author = Author::first();
$author->delete();


$countAfter = Post::count();

