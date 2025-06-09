<?php

namespace App\Http\Controllers;

use App\Models\Post;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Gate;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;

class PostController extends Controller
{
    use AuthorizesRequests;
    public function index()
    {
        $posts = Post::latest()->paginate(5);
        
    }
    public function edit(Post $post)
    {
        if (!Gate::allows('edit-post', $post)) {
            abort(403);
        }
        return view('posts.edit', compact('post'));
    }

    public function update(Request $request, Post $post)
    {
        $this->authorize('update', $post);

        $post->update($request->only('title', 'content'));

        return redirect()->route('dashboard')->with('success', 'Bài viết đã được cập nhật.');
    }

    public function destroy(Post $post)
    {
        $this->authorize('delete', $post);
        $post->delete();

        return redirect()->route('dashboard')->with('success', 'Bài viết đã bị xóa.');
    }
}
